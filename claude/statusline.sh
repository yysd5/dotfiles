#!/bin/bash
# Claude Code ステータスライン
# 1行目: モデル / ディレクトリ / gitブランチ
# 2行目: コンテキスト残量バー / 5h・7dレートリミット使用量
input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "?"')
dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // "?"')
branch=$(git -C "$dir" branch --show-current 2>/dev/null)

line1="\033[1;36m[$model]\033[0m 📁 ${dir##*/}"
[ -n "$branch" ] && line1+="  ⎇ $branch"
echo -e "$line1"

# 使用率に応じてANSI色コードを返す (緑→黄→赤)
color_for() {
  if [ "$1" -ge 80 ]; then echo "31"
  elif [ "$1" -ge 50 ]; then echo "33"
  else echo "32"
  fi
}

# コンテキスト残量バー
ctx_used=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
ctx_free=$((100 - ctx_used))
bar_len=12
filled=$((ctx_used * bar_len / 100))
bar=""
for ((i = 0; i < bar_len; i++)); do
  [ "$i" -lt "$filled" ] && bar+="█" || bar+="░"
done
c=$(color_for "$ctx_used")
line2="🧠 CTX \033[${c}m${bar} ${ctx_free}% free\033[0m"

# 5時間レートリミット (サブスクプランのセッションのみ値が来る)
rl5=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty' | cut -d. -f1)
if [ -n "$rl5" ]; then
  reset5=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
  reset_str=""
  [ -n "$reset5" ] && reset_str=" (reset $(date -r "$reset5" +%H:%M))"
  c=$(color_for "$rl5")
  line2+=" │ ⏱ 5h: \033[${c}m${rl5}% used\033[0m${reset_str}"
fi

# 7日レートリミット
rl7=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty' | cut -d. -f1)
if [ -n "$rl7" ]; then
  c=$(color_for "$rl7")
  line2+=" │ 7d: \033[${c}m${rl7}%\033[0m"
fi

echo -e "$line2"
