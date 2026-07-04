.PHONY: all help brew zsh tmux aqua gitconfig lazygit iterm2 nvim claude gemini antigravity-cli codex intellij npm obsidian amazonq rovodev vrapper ghostty

TIMESTAMP := $(shell date +%Y%m%d-%H%M%S)

## Run all setup tasks
all: brew zsh nvim tmux lazygit aqua npm gitconfig obsidian ghostty

brew: ## Install CLI tools via Homebrew
	LOG_TIMESTAMP=$(TIMESTAMP) ./setup.sh brew

zsh: ## Install .zshrc
	LOG_TIMESTAMP=$(TIMESTAMP) ./setup.sh zsh

tmux: ## Install .tmux.conf
	LOG_TIMESTAMP=$(TIMESTAMP) ./setup.sh tmux

aqua: zsh ## Install CLI tools via aqua (requires .zshrc)
	LOG_TIMESTAMP=$(TIMESTAMP) ./setup.sh aqua

gitconfig: ## Configure git
	LOG_TIMESTAMP=$(TIMESTAMP) ./setup.sh gitconfig

lazygit: ## Install lazygit config
	LOG_TIMESTAMP=$(TIMESTAMP) ./setup.sh lazygit

iterm2: ## Install iTerm2 config
	LOG_TIMESTAMP=$(TIMESTAMP) ./setup.sh iterm2

nvim: zsh ## Setup Neovim config (~/.config/nvim)
	LOG_TIMESTAMP=$(TIMESTAMP) ./setup.sh nvim

claude: ## Setup Claude config (~/.claude)
	LOG_TIMESTAMP=$(TIMESTAMP) ./setup.sh claude

gemini: ## Setup Gemini CLI config (~/.gemini)
	LOG_TIMESTAMP=$(TIMESTAMP) ./setup.sh gemini

antigravity-cli: ## Setup Antigravity CLI config (~/.gemini/antigravity-cli)
	LOG_TIMESTAMP=$(TIMESTAMP) ./setup.sh antigravity-cli

codex: ## Setup Codex CLI config (~/.codex)
	LOG_TIMESTAMP=$(TIMESTAMP) ./setup.sh codex

intellij: ## Setup IntelliJ IDEA config (.ideavimrc)
	LOG_TIMESTAMP=$(TIMESTAMP) ./setup.sh intellij

npm: ## Install npm global packages
	LOG_TIMESTAMP=$(TIMESTAMP) ./setup.sh npm

obsidian: ## Setup Obsidian vimrc config
	LOG_TIMESTAMP=$(TIMESTAMP) ./setup.sh obsidian

amazonq: ## Setup Amazon Q config
	LOG_TIMESTAMP=$(TIMESTAMP) ./setup.sh amazonq

rovodev: ## Setup Rovodev CLI config (~/.rovodev/.agent.md)
	LOG_TIMESTAMP=$(TIMESTAMP) ./setup.sh rovodev

vrapper: ## Setup Vrapper config (~/.vrapperrc)
	LOG_TIMESTAMP=$(TIMESTAMP) ./setup.sh vrapper

ghostty: ## Setup Ghostty config
	LOG_TIMESTAMP=$(TIMESTAMP) ./setup.sh ghostty

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-18s\033[0m %s\n", $1, $2}'


