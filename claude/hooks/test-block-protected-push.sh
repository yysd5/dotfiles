#!/usr/bin/env bash
# block-protected-push.sh のテスト
# 使い方: bash claude/hooks/test-block-protected-push.sh

set -uo pipefail

HOOK="$(cd "$(dirname "$0")" && pwd)/block-protected-push.sh"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

# 現在のブランチ判定用の作業リポジトリ
make_repo() {
  local dir="$1" branch="$2"
  git init -q -b "$branch" "$dir"
  git -C "$dir" -c user.name=t -c user.email=t@example.com \
    commit -q --allow-empty -m init
}
make_repo "$WORK/on-main" main
make_repo "$WORK/on-feature" feature/foo

pass=0
fail=0

# $1: 期待値(block|allow) $2: cwd $3: コマンド
check() {
  local expected="$1" cwd="$2" cmd="$3" code actual
  jq -n --arg c "$cmd" --arg d "$cwd" \
    '{tool_name: "Bash", tool_input: {command: $c}, cwd: $d}' \
    | bash "$HOOK" >/dev/null 2>&1
  code=$?
  case "$code" in
    0) actual=allow ;;
    2) actual=block ;;
    *) actual="error($code)" ;;
  esac
  if [ "$actual" = "$expected" ]; then
    pass=$((pass + 1))
  else
    fail=$((fail + 1))
    echo "FAIL: [$cwd] $cmd => $actual (expected $expected)"
  fi
}

M="$WORK/on-main"
F="$WORK/on-feature"

# push 以外は対象外
check allow "$M" "git status"
check allow "$M" "echo git push origin main"
check allow "$M" "ls -la"

# 保護対象外ブランチへの明示的な push
check allow "$M" "git push origin feature/foo"
check allow "$M" "git push -u origin feature/foo"
check allow "$M" "git push --set-upstream origin fix/bar"
check allow "$M" "git push origin feature/foo:feature/foo"
check allow "$M" "git push origin HEAD:feature/foo"
check allow "$M" "git push --force-with-lease origin feature/foo"
check allow "$M" "git push origin feature/maintenance"

# 保護ブランチへの明示的な push
check block "$F" "git push origin main"
check block "$F" "git push origin master"
check block "$F" "git push origin develop"
check block "$F" "git push origin release"
check block "$F" "git push origin release/1.2.0"
check block "$F" "git push -u origin main"
check block "$F" "git push origin feature/foo:main"
check block "$F" "git push origin HEAD:refs/heads/main"
check block "$F" "git push origin refs/heads/develop"
check block "$F" "git push origin feature/foo main"
check block "$F" "git push origin :main"
check block "$F" "git push --delete origin main"
check block "$F" "git push -o ci.skip origin main"

# refspec 省略・HEAD のときは現在のブランチで判定する
check block "$M" "git push"
check block "$M" "git push origin"
check block "$M" "git push -u origin HEAD"
check allow "$F" "git push"
check allow "$F" "git push origin"
check allow "$F" "git push -u origin HEAD"

# -C で別リポジトリを指定した場合はそちらのブランチで判定する
check block "$F" "git -C $M push"
check allow "$M" "git -C $F push"
check block "$F" "cd $M && git push"

# 全ブランチ push
check block "$F" "git push --all origin"
check block "$F" "git push --mirror origin"

# force push (--force-with-lease 以外)
check block "$F" "git push -f origin feature/foo"
check block "$F" "git push --force origin feature/foo"
check block "$F" "git push -uf origin feature/foo"
check block "$F" "git push origin +feature/foo"
check block "$M" "git push --force-with-lease origin main"

# 複合コマンド
check block "$F" "git add . && git commit -m x && git push origin main"
check block "$F" "git status; git push origin main"
check allow "$F" "git add . && git commit -m x && git push origin feature/foo"
check block "$F" "git push origin feature/foo && git push origin main"

# git のグローバルオプション付き
check block "$F" "git -c push.default=current push origin main"
check block "$F" "git --no-pager push origin main"

echo "passed: $pass, failed: $fail"
[ "$fail" -eq 0 ]
