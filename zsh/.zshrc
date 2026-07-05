
# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"
#ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git autojump web-search python fzf zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias vi="nvim"
alias vim="nvim"
alias view="nvim -R"
alias zshconfig="nvim $HOME/.zshrc"
alias ohmyzsh="nvim $HOME/.oh-my-zsh"

### my original config ###
PROMPT='%F{green}%D%f %F{green}%T%f %F{green}%~%f %F{blue}$%f '

alias ls="ls -GF"
alias ll="ls -laGh"

export LSCOLORS=Exfxcxdxbxegedabagacad
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
autoload -U colors ; colors ; zstyle ':completion:*' list-colors "${LS_COLORS}"

setopt no_beep
setopt auto_pushd
setopt pushd_ignore_dups
#setopt auto_cd
setopt hist_ignore_dups
setopt share_history
setopt inc_append_history

export HISTFILE=$HOME/.zsh_history
export HISTSIZE=100000
export SAVEHIST=100000

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f "$HOME/.p10k.zsh" ]] || source "$HOME/.p10k.zsh"

# -------------------- homebrew --------------------
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/bin/sbin:$PATH"

# -------------------- node --------------------
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

export PATH="$HOME/.npm-global/bin:$PATH"

# -------------------- Python --------------------
# pyenv
# https://github.com/pyenv/pyenv/blob/master/README.md#set-up-your-shell-environment-for-pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Created by `pipx` on 2023-12-22 16:34:10
export PATH="$PATH:$HOME/.local/bin"
# START: Added by Updated Airflow Breeze autocomplete setup
source "$HOME/Projects/airflow/dev/breeze/autocomplete/breeze-complete-zsh.sh"
# END: Added by Updated Airflow Breeze autocomplete setup

# uv
eval "$(uv generate-shell-completion zsh)"

# -------------------- Conda --------------------
# To prevent the base environment from being activated automatically,
# execute the following after installing conda (this will be written to ~/.condarc):
# `conda config --set auto_activate_base false`

# Moved the conda settings written in .bash_profile to .zshrc
# (replaced `shell.bash` with `shell.zsh`)

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# -------------------- Go --------------------
export PATH=${PATH}:$(go env GOPATH)/bin

# -------------------- Google Cloud --------------------
# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

# -------------------- Java --------------------
# export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"
#export JAVA_HOME=$(/usr/libexec/java_home -v21)
#export JAVA_HOME=$(/usr/libexec/java_home -v24)
export JAVA_HOME=$(/usr/libexec/java_home -v25)
export PATH="$JAVA_HOME/bin:$PATH"

alias use_java14='export JAVA_HOME=$(/usr/libexec/java_home -v14); export PATH="$JAVA_HOME/bin:$PATH"'
alias use_java21='export JAVA_HOME=$(/usr/libexec/java_home -v21); export PATH="$JAVA_HOME/bin:$PATH"'
alias use_java24='export JAVA_HOME=$(/usr/libexec/java_home -v24); export PATH="$JAVA_HOME/bin:$PATH"'
alias use_java25='export JAVA_HOME=$(/usr/libexec/java_home -v25); export PATH="$JAVA_HOME/bin:$PATH"'

# MAVEN_OPTS(プロキシ認証情報を含む)は~/.zshrc.localで定義する

# -------------------- aqua --------------------
export PATH="${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua}/bin:$PATH"
if command -v aqua &> /dev/null; then
    source <(aqua completion zsh)
fi
# https://aquaproj.github.io/docs/tutorial/global-config/
export AQUA_GLOBAL_CONFIG="$HOME/dotfiles/aqua/aqua.yaml"

# https://aquaproj.github.io/docs/guides/uninstall-packages/
# Always remove the package from bin directory when uninstalling
export AQUA_REMOVE_MODE=pl

# -------------------- fzf --------------------
export FZF_BASE="$HOME/.local/share/aquaproj-aqua/bin"
alias ahelp='alias | fzf'      # Interactive search for aliases
alias fhelp='declare -f | fzf' # Interactive search for shell functions
alias chelp='compgen -c | fzf' # Interactive search for all available commands (bash-compatible)

# --------------------- general settings --------------------
export VISUAL=nvim
export EDITOR=nvim

alias sshconfig="vim ~/.ssh/config"

# --------------------- git --------------------
alias ga='git add'

alias gb='git branch'
alias gbd='git branch --delete'

alias gck='git checkout'
alias gckb='git checkout -b'
alias gck-='git checkout -'
alias gckd='git checkout $(git_develop_branch)'
alias gckm='git checkout $(git_main_branch)'

alias gcmsg='git commit --message'
alias gc='git commit --verbose'
alias gc!='git commit --verbose --amend'

alias gd='git diff'
alias gds='git diff --staged'
alias gdsc='git diff --staged | cat'
alias gdsnp='git --no-pager diff --staged'

alias glo='git log --oneline --decorate'
alias glog='git log --oneline --decorate --graph'

alias gpl='git pull'

alias ggpush='git push origin "$(git_current_branch)"'
alias ggpushf='git push --force-with-lease origin "$(git_current_branch)"'

# alias grbd='git rebase $(git_develop_branch)'
# alias grbi='git rebase --interactive'

# alias grhs='git reset --soft'

alias gsh='git show'

alias gsta='git stash'
alias gstp='git stash pop'

alias gst='git status'

# マシン固有のシークレット等(git管理外)を読み込む
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"
