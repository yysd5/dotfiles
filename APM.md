# apm (Agent Package Manager) 管理ガイド

Claude Code / Gemini CLIのSkill・Command・Agentを、
[microsoft/apm](https://github.com/microsoft/apm) を使って
`.apm/` 配下に一元管理している。

このドキュメントでは、アーキテクチャと日常的な追加・削除フローを説明する。

## なぜapmを使っているか

以前は `claude/skills` と `gemini/skills` のように、
ツールごとにSkill・Commandを手作業で二重管理していた。

その結果、内容や命名にドリフトが発生していた
(例: 同じCommandなのにclaude側とgemini側で名前が違う、
片方だけ更新されていて内容が古い、など)。

apmを導入し、`.apm/` 配下を単一のソースとして、
`apm install` で各ツールのネイティブ形式に自動変換・配布するようにした。

## 対象ツールと対象外

- 対象: Claude Code, Gemini CLI
- 対象外(今後の課題):
    - Antigravity CLI, Codex
        - 動作未検証のため、現状は`gemini/antigravity-cli/`,
          `codex/`配下で従来通り手動管理
    - 引数(`$ARGUMENTS`)を使うCommand 6個
        - 詳細は[既知の制約](#既知の制約)を参照

## アーキテクチャ

### ソースの配置

```
dotfiles/
  apm.yml                       # マニフェスト
  .apm/
    skills/<name>/SKILL.md      # Skill
    prompts/<name>.prompt.md    # Command
    agents/<name>.agent.md      # Agent
```

`apm.yml` の `targets:` にデプロイ先(`claude`, `gemini`)を宣言している。

### デプロイ先(apm installで自動生成される)

| 種類 | Claude Code | Gemini CLI |
| --- | --- | --- |
| Skill | `~/.claude/skills/<name>/SKILL.md` | `~/.agents/skills/<name>/SKILL.md`(公式エイリアス) |
| Command | `~/.claude/commands/<name>.md` | `~/.gemini/commands/<name>.toml` |
| Agent | `~/.claude/agents/<name>.md` | (今回は未使用) |

`~/.agents/skills/` はGemini CLI公式サポートのエイリアスで、
`~/.gemini/skills/` より優先される。

### setup.shとの関係

`setup.sh` の `install_claude` / `install_gemini` から、
dotfilesリポジトリのルートで以下を実行している。

```bash
apm install --root "$HOME" --target claude   # install_claude内
apm install --root "$HOME" --target gemini   # install_gemini内
```

`--root "$HOME"` により、ソース(`apm.yml`, `.apm/`)はdotfilesリポジトリから読み、
デプロイ先だけを `$HOME` (実際の `~/.claude`, `~/.gemini` 等) に向けている。

`apm install -g` は別物(`~/.apm/`配下のグローバルプロジェクト向け)なので使わない。

## 初回インストール

`make claude` または `make gemini` (`make all`にも含まれる) を実行すると、
`setup.sh`が自動で `brew install microsoft/apm/apm` を行う。

手動で確認する場合は以下。

```bash
apm --version
```

## Skillを追加する

1. `.apm/skills/<name>/SKILL.md` を作成する

    ```markdown
    ---
    name: <name>
    description: いつ使うスキルかを1行で
    user-invocable: false
    ---

    (本文)
    ```

2. Claude Code / Gemini CLIどちらの用語にも依存しない書き方にする

    「Editツール」「Readツール」のようなツール固有の名前ではなく、
    「ファイル編集ツール」「ファイル読み込みツール」のように汎用化する。

3. dotfilesリポジトリのルートで反映を確認する

    ```bash
    apm install --root "$HOME" --target claude,gemini
    ```

4. `~/.claude/skills/<name>/`, `~/.agents/skills/<name>/` に
   配置されたことを確認してcommit・PRを作成する

## Skillを削除する

1. `.apm/skills/<name>/` ディレクトリを削除する
2. 再度 `apm install --root "$HOME" --target claude,gemini` を実行する

    ソースが無くなったファイルは `stale files` として自動的に削除される。

3. `~/.claude/skills/`, `~/.agents/skills/` から消えたことを確認してcommit・PRを作成する

## Commandを追加する

1. 引数を使わないCommandであることを確認する

    引数付きCommandは現状apm管理の対象外([既知の制約](#既知の制約)を参照)。

2. `.apm/prompts/<name>.prompt.md` を作成する

    ```markdown
    ---
    description: コマンドピッカーに表示される説明(必須)
    ---
    (プロンプト本文)
    ```

3. サブディレクトリには置かない

    `.apm/prompts/git/foo.prompt.md` のようなネストは
    apmにデプロイされず無視されるため、フラットな構成にする。

4. 反映を確認してcommit・PRを作成する

    ```bash
    apm install --root "$HOME" --target claude,gemini
    ```

## Commandを削除する

1. `.apm/prompts/<name>.prompt.md` を削除する
2. 再度 `apm install --root "$HOME" --target claude,gemini` を実行する
   (stale filesとして自動削除される)

## 既知の制約

### 引数付きCommandはapm管理の対象外

apm 0.23.1のGemini向けプロンプト変換にバグがある。

`input:` で名前付き引数を宣言した場合、
Claude向けは正しく `$name` に変換されるが、
Gemini向けは `${input:name}` のまま出力される。

Gemini CLIのカスタムコマンドは `{{args}}` のみサポートのため、
このまま配布すると実行時に引数が置換されず壊れる。

そのため、以下の6つの引数付きCommandは今回のapm移行対象から除外し、
`claude/commands/*.md`, `gemini/commands/*.toml` に手動管理のまま残している。

- `code-review` / `code-review-current-branch-local`
- `complete-work-day`
- `explain-current-branch-local`
- `review-docs`
- `start-develop-project`
- `start-task`

これらを追加・削除・修正する場合は、
`claude/commands/` と `gemini/commands/` の両方を直接編集する
(従来通りの手動二重管理)。

apmがこのバグを修正したら、apm管理への統合を再検討する。

### Antigravity CLI / Codex

`gemini/antigravity-cli/skills/*` は `.apm/skills/*` を参照するsymlinkに
更新済みだが、Command・Agentの移行やapmでのデプロイ自体は未対応。

`codex/` 配下も引き続き手動管理。

## トラブルシューティング

- 変更が反映されない場合は、まず `apm install --root "$HOME" --target claude,gemini`
  を再実行する
- `~/apm.lock.yaml`, `~/apm_modules/`, `~/.gitignore`への追記は
  apmが管理用に生成する正常な副産物
