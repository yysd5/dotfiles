#!/usr/bin/env bash

set -euo pipefail

# リポジトリの場所はこのスクリプトの位置から決める(~/dotfiles以外にcloneしても動くように)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_TIMESTAMP="${LOG_TIMESTAMP:-$(date +%Y%m%d-%H%M%S)}"
LOG_FILE="$DOTFILES_DIR/setup-$LOG_TIMESTAMP.log"
BACKUP_SUFFIX=".bak.$LOG_TIMESTAMP"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

backup_and_link() {
  local target="$1"
  local source="$2"

  if [ -e "$target" ] && [ ! -L "$target" ]; then
    log "Backing up $target to ${target}${BACKUP_SUFFIX}"
    mv "$target" "${target}${BACKUP_SUFFIX}"
  fi

  if [ -L "$target" ]; then
    log "Removing existing symlink $target"
    rm "$target"
  fi

  ln -s "$source" "$target"
  log "Linked $source → $target"
}

remove_symlink_if_exists() {
  local target="$1"

  if [ -L "$target" ]; then
    log "Removing old symlink $target (superseded by apm)"
    rm "$target"
  fi
}

backup_and_copy() {
  local source="$1"
  local target="$2"

  if [ -e "$target" ] && [ ! -L "$target" ]; then
    log "Backing up $target to ${target}${BACKUP_SUFFIX}"
    mv "$target" "${target}${BACKUP_SUFFIX}"
  fi

  cp "$source" "$target"
  log "Copied $source → $target"
}

install_zsh() {
  log "Setting up zsh..."
  install_ohmyzsh
  backup_and_link "$HOME/.zshrc" "$DOTFILES_DIR/zsh/.zshrc"
}

# .zshrcが使うoh-my-zshと、標準に含まれないプラグインを入れる
install_ohmyzsh() {
  local zsh_dir="$HOME/.oh-my-zsh"

  if [ -d "$zsh_dir" ]; then
    log "oh-my-zsh already installed, skipping"
  else
    log "Installing oh-my-zsh..."
    # 既存の.zshrcを残し、インストール後にzshを起動しない
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
      "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
      "" --unattended 2>&1 | tee -a "$LOG_FILE"
  fi

  local plugin_dir="$zsh_dir/custom/plugins"
  for repo in zsh-users/zsh-autosuggestions zsh-users/zsh-syntax-highlighting; do
    local dir="$plugin_dir/${repo#*/}"
    if [ -d "$dir" ]; then
      log "${repo#*/} already installed, skipping"
    else
      log "Installing ${repo#*/}..."
      git clone --depth 1 "https://github.com/$repo" "$dir" 2>&1 | tee -a "$LOG_FILE"
    fi
  done
}

install_nvim() {
  log "Setting up Neovim..."
  mkdir -p "$HOME/.config"
  backup_and_link "$HOME/.config/nvim" "$DOTFILES_DIR/nvim"
}

install_tmux() {
  log "Setting up tmux..."
  backup_and_link "$HOME/.tmux.conf" "$DOTFILES_DIR/tmux/.tmux.conf"
}

install_lazygit() {
  log "Setting up lazygit config..."
  mkdir -p "$HOME/Library/Application Support/lazygit"
  backup_and_link "$HOME/Library/Application Support/lazygit/config.yml" "$DOTFILES_DIR/lazygit/config.yml"
}

install_gitconfig() {
  log "Setting up git config..."
  backup_and_link "$HOME/.gitconfig" "$DOTFILES_DIR/git/.gitconfig"

  local local_gitconfig_src="$DOTFILES_DIR/git/.gitconfig.local"
  local local_gitconfig_dst="$HOME/.gitconfig.local"

  if [ -f "$local_gitconfig_src" ]; then
    backup_and_copy "$local_gitconfig_src" "$local_gitconfig_dst"
  else
    log "No .gitconfig.local found at $local_gitconfig_src, skipping copy"
  fi
}

install_brew() {
  log "Installing Homebrew packages (without upgrading existing ones)..."
  while read -r pkg; do
    if ! brew list "$pkg" &>/dev/null; then
      log "Installing $pkg via Homebrew"
      # brewが標準入力(このループのパッケージ一覧)を読んで消費しないようにする
      brew install "$pkg" </dev/null 2>&1 | tee -a "$LOG_FILE"
    else
      log "$pkg already installed, skipping"
    fi
  done <<EOF
aqua
autojump
cmake
curl
font-hack-nerd-font
fzf
gcc
git
git-delta
gh
go
lua
neovim
node
openjdk@21
pyenv
pyenv-virtualenv
ripgrep
sshs
terminal-notifier
tmux
tree
tree-sitter-cli
uv
EOF
}

install_openjdk_symlink() {
  local jdk_path="/Library/Java/JavaVirtualMachines/openjdk-21.jdk"
  local brew_jdk="/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk"

  if [ ! -L "$jdk_path" ]; then
    log "Creating symlink for OpenJDK 21..."
    sudo ln -sfn "$brew_jdk" "$jdk_path"
    log "Symlink created: $jdk_path → $brew_jdk"
  else
    log "Symlink already exists: $jdk_path"
  fi
}

install_aqua() {
  log "Installing tools via aqua (global config)..."
  aqua i -a
}

install_apm() {
  if command -v apm &>/dev/null; then
    log "apm already installed, skipping"
    return 0
  fi
  log "Installing apm (Agent Package Manager) via Homebrew..."
  brew install microsoft/apm/apm 2>&1 | tee -a "$LOG_FILE"
}

install_claude() {
  log "Setting up Claude config..."

  # .claude がディレクトリ丸ごとシンボリックリンクの場合は解除する
  if [ -L "$HOME/.claude" ]; then
    log "Removing directory-level symlink $HOME/.claude"
    rm "$HOME/.claude"
  fi

  mkdir -p "$HOME/.claude"

  backup_and_link "$HOME/.claude/CLAUDE.md" "$DOTFILES_DIR/claude/CLAUDE.md"
  backup_and_link "$HOME/.claude/settings.json" "$DOTFILES_DIR/claude/settings.json"
  backup_and_link "$HOME/.claude/statusline.sh" "$DOTFILES_DIR/claude/statusline.sh"

  mkdir -p "$HOME/.claude/hooks"
  backup_and_link "$HOME/.claude/hooks/block-protected-push.sh" \
    "$DOTFILES_DIR/claude/hooks/block-protected-push.sh"

  # Skills/Agentsは.apm/配下のソースからapmでデプロイする（symlinkでの共有から移行）
  # 旧方式(ディレクトリ丸ごとsymlink)が残っているとapmが正しくデプロイできないため先に解除する
  remove_symlink_if_exists "$HOME/.claude/skills"
  remove_symlink_if_exists "$HOME/.claude/commands"
  remove_symlink_if_exists "$HOME/.claude/agents"

  install_apm
  log "Deploying Claude skills/agents via apm..."
  (cd "$DOTFILES_DIR" && apm install --root "$HOME" --target claude)
}

install_gemini() {
  log "Setting up Gemini CLI config..."
  # Ensure the parent directory exists
  mkdir -p "$HOME/.gemini"

  backup_and_link "$HOME/.gemini/settings.json" "$DOTFILES_DIR/gemini/settings.json"
  backup_and_link "$HOME/.gemini/GEMINI.md" "$DOTFILES_DIR/gemini/GEMINI.md"

  # Skills/Agentsは.apm/配下のソースからapmでデプロイする（symlinkでの共有から移行）
  # 旧方式(ディレクトリ丸ごとsymlink)が残っているとapmが正しくデプロイできないため先に解除する
  # SkillはGemini CLI公式サポートの~/.agents/skills/エイリアスにデプロイされる
  remove_symlink_if_exists "$HOME/.gemini/skills"
  remove_symlink_if_exists "$HOME/.gemini/commands"
  remove_symlink_if_exists "$HOME/.gemini/agents"

  install_apm
  log "Deploying Gemini skills/agents via apm..."
  (cd "$DOTFILES_DIR" && apm install --root "$HOME" --target gemini)

  if [ -d "$DOTFILES_DIR/gemini/policies" ]; then
    log "Linking Gemini policies directory..."
    backup_and_link "$HOME/.gemini/policies" "$DOTFILES_DIR/gemini/policies"
  fi
}

install_antigravity() {
  log "Setting up Antigravity CLI config..."
  mkdir -p "$HOME/.gemini/antigravity-cli"

  backup_and_link "$HOME/.gemini/antigravity-cli/settings.json" "$DOTFILES_DIR/gemini/antigravity-cli/settings.json"
  backup_and_link "$HOME/.gemini/antigravity-cli/statusline.py" "$DOTFILES_DIR/gemini/antigravity-cli/statusline.py"

  if [ -d "$DOTFILES_DIR/gemini/antigravity-cli/skills" ]; then
    log "Linking Antigravity skills directory..."
    backup_and_link "$HOME/.gemini/antigravity-cli/skills" "$DOTFILES_DIR/gemini/antigravity-cli/skills"
  fi
}

install_codex() {
  log "Setting up Codex CLI config..."
  mkdir -p "$HOME/.codex"
  backup_and_link "$HOME/.codex/AGENT.md" "$DOTFILES_DIR/codex/AGENT.md"

  # config.tomlはアプリが書き込むマシン固有の設定なのでgit管理しない
  # 旧方式のsymlinkはリンク先が無くなるため解除する
  if [ -L "$HOME/.codex/config.toml" ]; then
    log "Removing old symlink $HOME/.codex/config.toml"
    rm "$HOME/.codex/config.toml"
  fi

  # Skills/Agentsは.apm/配下のソースからapmでデプロイする
  install_apm
  log "Deploying Codex skills/agents via apm..."
  (cd "$DOTFILES_DIR" && apm install --root "$HOME" --target codex)
}

install_intellij() {
  log "Setting up IntelliJ IDEA config..."
  backup_and_link "$HOME/.ideavimrc" "$DOTFILES_DIR/intellij/.ideavimrc"
}

install_npm_global() {
  log "Installing npm global packages..."
  while read -r pkg; do
    if ! npm list -g "$pkg" &>/dev/null; then
      log "Installing $pkg globally via npm"
      npm install -g "$pkg" 2>&1 | tee -a "$LOG_FILE"
    else
      log "$pkg already installed globally, skipping"
    fi
  done <"$DOTFILES_DIR/npm/packages.txt"
}

install_obsidian() {
  log "Setting up Obsidian vimrc config..."
  local obsidian_dir="$HOME/myobs"

  if [ ! -d "$obsidian_dir" ]; then
    log "Obsidian directory $obsidian_dir not found, skipping"
    return 0
  fi

  backup_and_link "$obsidian_dir/.obsidian.vimrc" "$DOTFILES_DIR/obsidian/.obsidian.vimrc"
}

install_vrapper() {
  log "Setting up Vrapper config..."
  backup_and_link "$HOME/.vrapperrc" "$DOTFILES_DIR/vrapper/.vrapperrc"
}

install_ghostty() {
  log "Setting up Ghostty config..."
  mkdir -p "$HOME/Library/Application Support/com.mitchellh.ghostty"
  backup_and_link "$HOME/Library/Application Support/com.mitchellh.ghostty/config" "$DOTFILES_DIR/ghostty/config"

  local ghostty_app_path="/Applications/Ghostty.app/Contents/MacOS/ghostty"
  local ghostty_bin_path="/usr/local/bin/ghostty"

  if [ -f "$ghostty_app_path" ]; then
    log "Creating symlink for Ghostty executable..."
    sudo ln -sf "$ghostty_app_path" "$ghostty_bin_path"
    log "Symlink created: $ghostty_bin_path -> $ghostty_app_path"
  else
    log "Ghostty application not found at $ghostty_app_path, skipping symlink creation."
  fi
}

main() {
  if [ $# -eq 0 ]; then
    echo "Usage: $0 [all|zsh|nvim|tmux|lazygit|brew|aqua|gitconfig|claude|gemini|antigravity-cli|codex|intellij|npm|obsidian|vrapper|ghostty]"
    exit 1
  fi

  for arg in "$@"; do
    case "$arg" in
    all)
      install_brew
      install_openjdk_symlink
      install_zsh
      install_tmux
      install_aqua
      install_npm_global
      install_gitconfig
      install_lazygit
      install_nvim
      install_claude
      install_gemini
      install_codex
      install_intellij
      install_obsidian
      install_vrapper
      install_ghostty
      ;;
    zsh) install_zsh ;;
    nvim) install_nvim ;;
    tmux) install_tmux ;;
    lazygit) install_lazygit ;;
    brew)
      install_brew
      install_openjdk_symlink
      ;;
    aqua) install_aqua ;;
    gitconfig) install_gitconfig ;;
    claude) install_claude ;;
    gemini) install_gemini ;;
    antigravity-cli) install_antigravity ;;
    codex) install_codex ;;
    intellij) install_intellij ;;
    npm) install_npm_global ;;
    obsidian) install_obsidian ;;
    vrapper) install_vrapper ;;
    ghostty) install_ghostty ;;
    *)
      echo "Unknown option: $arg"
      exit 1
      ;;
    esac
  done

  log "Setup completed."
}

main "$@"
