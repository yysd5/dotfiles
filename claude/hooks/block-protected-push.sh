#!/usr/bin/env bash
# Claude Code の PreToolUse hook (Bash)
# 保護ブランチへの git push と force push を常にブロックする。
# push 自体の許可はリポジトリごとの permissions.allow で行い、
# この hook はどのリポジトリでも保護ブランチを守る最後の砦とする。
#
# ブロックした場合は理由を stderr に出して exit 2 する。
# コマンド文字列の簡易解析なので sh -c や alias 経由は検出できない。

set -uo pipefail

input="$(cat)"
command="$(jq -r '.tool_input.command // empty' <<<"$input" 2>/dev/null)"
cwd="$(jq -r '.cwd // empty' <<<"$input" 2>/dev/null)"
[ -n "$command" ] || exit 0
[ -n "$cwd" ] || cwd="$PWD"

is_protected() {
  case "$1" in
    main | master | develop | release | release/*) return 0 ;;
  esac
  return 1
}

block() {
  echo "BLOCKED: $1" >&2
  echo "保護ブランチ(main/master/develop/release)への直接 push と" >&2
  echo "force push は禁止。feature ブランチに push して PR を作ること。" >&2
  exit 2
}

current_branch() {
  git -C "$1" symbolic-ref --short -q HEAD 2>/dev/null
}

# 相対パスを基準ディレクトリから解決する
resolve_dir() {
  case "$2" in
    /*) echo "$2" ;;
    ~*) echo "${HOME}${2#\~}" ;;
    *) echo "$1/$2" ;;
  esac
}

# refspec の宛先ブランチ名を返す
refspec_dest() {
  local spec="$1" dir="$2" dst
  dst="${spec#+}"
  case "$dst" in
    *:*) dst="${dst#*:}" ;;
  esac
  case "$dst" in
    HEAD | @) dst="$(current_branch "$dir")" ;;
  esac
  echo "${dst#refs/heads/}"
}

# push の引数を検査する。$1: 対象ディレクトリ, 以降: push の引数
check_push() {
  local dir="$1"
  shift
  local -a positional=()
  local arg end_opts=0 branch

  while [ $# -gt 0 ]; do
    arg="$1"
    shift
    if [ "$end_opts" -eq 1 ]; then
      positional+=("$arg")
      continue
    fi
    case "$arg" in
      --) end_opts=1 ;;
      --all | --mirror | --branches) block "$arg による全ブランチの push" ;;
      --force) block "force push ($arg)。--force-with-lease を使うこと" ;;
      --force-with-lease* | --force-if-includes | --no-force*) ;;
      -o | --push-option | --repo | --receive-pack | --exec) shift ;;
      --*) ;;
      -*f*) block "force push ($arg)。--force-with-lease を使うこと" ;;
      -*) ;;
      [0-9]\>* | [0-9]\<* | \>* | \<*) ;;
      *) positional+=("$arg") ;;
    esac
  done

  # positional[0] はリモート、以降が refspec
  if [ "${#positional[@]}" -le 1 ]; then
    branch="$(current_branch "$dir")"
    if [ -n "$branch" ] && is_protected "$branch"; then
      block "現在のブランチ $branch への push"
    fi
    return 0
  fi

  local spec dst
  for spec in "${positional[@]:1}"; do
    case "$spec" in
      +*) block "force push ($spec)。--force-with-lease を使うこと" ;;
    esac
    dst="$(refspec_dest "$spec" "$dir")"
    if is_protected "$dst"; then
      block "保護ブランチ $dst への push ($spec)"
    fi
  done
}

# 1つの単純コマンドを検査する。cd は後続コマンドの基準に反映する
check_segment() {
  local -a tokens
  local i=0 dir tok
  read -ra tokens <<<"$1"
  [ "${#tokens[@]}" -gt 0 ] || return 0

  # クォートは除去して扱う
  for i in "${!tokens[@]}"; do
    tok="${tokens[$i]//\"/}"
    tokens[$i]="${tok//\'/}"
  done

  i=0
  # 先頭の環境変数代入と command を読み飛ばす
  while [ "$i" -lt "${#tokens[@]}" ]; do
    case "${tokens[$i]}" in
      [A-Za-z_]*=* | command) i=$((i + 1)) ;;
      *) break ;;
    esac
  done

  if [ "${tokens[$i]:-}" = "cd" ]; then
    cwd="$(resolve_dir "$cwd" "${tokens[$((i + 1))]:-$HOME}")"
    return 0
  fi
  [ "${tokens[$i]:-}" = "git" ] || return 0
  i=$((i + 1))

  # git のグローバルオプションを読み飛ばす
  dir="$cwd"
  while [ "$i" -lt "${#tokens[@]}" ]; do
    case "${tokens[$i]}" in
      -C)
        dir="$(resolve_dir "$dir" "${tokens[$((i + 1))]:-}")"
        i=$((i + 2))
        ;;
      -c | --git-dir | --work-tree | --namespace) i=$((i + 2)) ;;
      -*) i=$((i + 1)) ;;
      *) break ;;
    esac
  done

  [ "${tokens[$i]:-}" = "push" ] || return 0
  check_push "$dir" "${tokens[@]:$((i + 1))}"
}

# 複合コマンドを単純コマンドに分割して順に検査する
while IFS= read -r segment; do
  check_segment "$segment"
done < <(sed -E 's/(&&|\|\||[;|&])/\n/g' <<<"$command")

exit 0
