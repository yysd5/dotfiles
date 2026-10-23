# dotfiles

このリポジトリでの作業ルール。全プロジェクト共通の設定は `claude/CLAUDE.md`(`~/.claude/CLAUDE.md`)にある。

## Neovimのマニュアル

- `nvim/manual/index.html` はnvim設定のマニュアル(nvimでは `<leader>H` か `:NvimManual` で開く)
- `nvim/` のキーマップ・プラグイン・言語ツールを変えたら、同じPRでマニュアルも更新する
- マニュアルを更新したら、Claude Artifact(https://claude.ai/artifact/PnHDKnAKCa9HUsZ7882tjb)にも公開し直す
  - Artifact側で骨組みが付くため、`<!doctype html>` / `<html lang="ja">` / `<head>` /
    `<meta charset>` / `<meta name="viewport">` / `</head>` / `<body>` / `</body>` / `</html>` の行を除いたものを公開する
  - 別の会話から更新するときは、上のURLを指定して同じArtifactを更新する(新しいArtifactを作らない)
