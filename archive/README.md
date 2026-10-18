# archive

Configs for tools that are no longer in use.
They are kept here just for reference and are not installed by `setup.sh`.

- `iterm2/`: iTerm2 config and color schemes
- `vscode/`: VS Code profile
- `wezterm/`: WezTerm config

## iTerm2

To use the iTerm2 config again, create a symlink and enable the following setting in iTerm2:

```bash
mkdir -p ~/Documents/ConfigFiles
ln -s ~/dotfiles/archive/iterm2/config ~/Documents/ConfigFiles/iTerm2
```

1. Open **iTerm2 → Preferences → General → Settings**
2. Enable: ✅ **Load settings from a custom folder or URL**
3. Set the folder path to: ~/Documents/ConfigFiles/iTerm2
