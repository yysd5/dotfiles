# apm (Agent Package Manager) 管理ガイド

Claude Code / Gemini CLI / Antigravity CLI / Codex CLIのSkill・Agentを、
[microsoft/apm](https://github.com/microsoft/apm) を使って
`.apm/` 配下に一元管理している。
MCPサーバーはapm管理の対象外([MCPサーバーの管理方針](#mcpサーバーの管理方針)を参照)。

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

- 対象: Claude Code, Gemini CLI, Antigravity CLI, Codex CLI
    - Antigravity CLI・Codex CLIの詳細は[Antigravity CLI / Codex CLI](#antigravity-cli--codex-cli)を参照
- Commandは使わない
    - スラッシュで呼びたいものもSkillとして作る([Commandを使わない理由](#commandを使わない理由)を参照)

## アーキテクチャ

### ソースの配置

```
dotfiles/
  apm.yml                       # マニフェスト
  .apm/
    skills/<name>/SKILL.md      # Skill
    agents/<name>.agent.md      # Agent
```

`apm.yml` の `targets:` にデプロイ先(`claude`, `gemini`)を宣言している。
`codex` は`apm.yml`の`targets:`には含めず、setup.shから`--target codex`を
明示的に渡してデプロイしている。`antigravity`はapm組み込みターゲットとして
使っていない(詳細は[Antigravity CLI / Codex CLI](#antigravity-cli--codex-cli)を参照)。

### デプロイ先(apm installで自動生成される)

| 種類    | Claude Code                        | Gemini CLI                                         | Codex CLI                          |
| ------- | ---------------------------------- | -------------------------------------------------- | ---------------------------------- |
| Skill   | `~/.claude/skills/<name>/SKILL.md` | `~/.agents/skills/<name>/SKILL.md`(公式エイリアス) | `~/.agents/skills/<name>/SKILL.md` |
| Agent   | `~/.claude/agents/<name>.md`       | (今回は未使用)                                     | `~/.codex/agents/<name>.md`        |

`~/.agents/skills/` はGemini CLI公式サポートのエイリアスで、
`~/.gemini/skills/` より優先される。

Antigravity CLIはapm組み込みターゲットの対象外で、symlinkで共有している
([Antigravity CLI / Codex CLI](#antigravity-cli--codex-cli)参照)。

### setup.shとの関係

`setup.sh` の `install_claude` / `install_gemini` / `install_codex` から、
dotfilesリポジトリのルートで以下を実行している。

```bash
apm install --root "$HOME" --target claude   # install_claude内
apm install --root "$HOME" --target gemini   # install_gemini内
apm install --root "$HOME" --target codex    # install_codex内
```

`--root "$HOME"` により、ソース(`apm.yml`, `.apm/`)はdotfilesリポジトリから読み、
デプロイ先だけを `$HOME` (実際の `~/.claude`, `~/.gemini`, `~/.codex` 等) に向けている。

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

    スラッシュで呼べるようにしたいSkillは `user-invocable: false` を書かない。

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

## Commandを使わない理由

以前はCommand(`.apm/prompts/`, `claude/commands/`, `gemini/commands/`)も
管理していたが、2026-10に全廃した。

- Skillもスラッシュで呼べるため、Commandでしかできないことが無い
- Skillは依頼文から自動で発動でき、Antigravity CLIへもsymlinkで共有できる
- 引数付きCommandはapmのGemini向け変換にバグがあり、
  Claude用・Gemini用の手動二重管理が残っていた

## MCPサーバーの管理方針

MCPサーバーは**apm管理の対象外**とし、各マシンのローカル設定
(git管理外)で管理する。

### 検討の経緯(2026-07-05)

`apm.yml`の`dependencies.mcp:`への一元化を実装・実機検証したが、
以下の理由で採用を見送った。

1. マシン間で共有管理したいMCPサーバーが今のところなく
   MCPサーバ追加する頻度も高くないため使用したいツールで手動で追加する管理のほうがシンプル
2. apmはデプロイ時に`${VAR}`参照を生のシークレット値に解決して
   git管理下の`gemini/settings.json`(symlink先)へ書き込むため、
   commit前の差分確認・書き戻しという運用負担が常に残る
3. apm 0.23.1のMCP対応に制約が多い
    - Claude Code向けは通常インストールだと`$HOME/.mcp.json`
      (プロジェクトスコープ)に書かれ、ユーザースコープ
      (`~/.claude.json`)には`-g`+`~/.apm/apm.yml`が必要
    - `--mcp`フラグと`--root`の併用に不具合がある
    - `timeout`等のツール固有キーやGemini固有の`oauth`ブロックを
      表現できない

apmのMCP対応が成熟し、マシン間で共有したいMCPサーバーが
出てきたら再検討する。

### 現在の管理方法

| ツール      | 置き場所(いずれもgit管理外)                                         |
| ----------- | ------------------------------------------------------------------- |
| Claude Code | `~/.claude.json` (`claude mcp add -s user`で追加)                   |
| Gemini CLI  | `~/.gemini/settings.local.json`                                     |
| Codex CLI   | `codex/config.toml`に手書き(従来どおり。シークレット無しのもののみ) |

- Gemini CLIは`~/.zshrc.local`で
  `export GEMINI_CLI_SYSTEM_SETTINGS_PATH="$HOME/.gemini/settings.local.json"`
  を定義し、システム設定レイヤーとして読み込ませている
  (`mcpServers`はレイヤー間でマージされ、tracked側の
  `gemini/settings.json`にはMCP設定を置かない)
- シークレット(APIキー等)は`~/.zshrc.local`に`export`し、
  設定ファイル側は`${VAR}`参照にする
  (Claude Code / Gemini CLIとも起動時に環境変数を解決する)
- git管理下のファイル(`gemini/settings.json`, `codex/config.toml`等)に
  生のシークレット値を書かないこと(コミット禁止ルール)

### slack-mcpのClaude Code接続について

SlackのMCPサーバー(mcp.slack.com)はDynamic Client Registration
非対応で、事前登録したOAuthクライアントが必須。さらにSlackアプリの
リダイレクトURLはhttps必須のため、Claude Codeのコールバック
(`http://localhost:<port>/callback`、パス・スキーム固定)は登録できず、
Claude CodeのOAuthフローは使えない。

代わりにGemini CLIのOAuthで取得済みのユーザートークン
(xoxp-、長期有効)を`~/.zshrc.local`の`SLACK_MCP_USER_TOKEN`に置き、
Bearerヘッダー直指定で接続している。

```bash
claude mcp add -s user --transport http slack-mcp \
  https://mcp.slack.com/mcp \
  --header 'Authorization: Bearer ${SLACK_MCP_USER_TOKEN}'
```

トークンが失効した場合はGemini CLI側で再認証し、
`~/.gemini/mcp-oauth-tokens.json`から新しいトークンを取り出して
`SLACK_MCP_USER_TOKEN`を更新する。

### 新しいマシンでのセットアップ

MCPサーバーが必要な場合のみ、以下を手で用意する(全てgit管理外)。

1. `~/.zshrc.local`: シークレットと
   `GEMINI_CLI_SYSTEM_SETTINGS_PATH`のexport
2. `~/.gemini/settings.local.json`: Gemini CLI用のMCPサーバー定義
3. `claude mcp add -s user ...`: Claude Code用のMCPサーバー追加

## Antigravity CLI / Codex CLI

### Antigravity CLI

Antigravity CLIが実際にSkillを読み込むのは `~/.gemini/antigravity-cli/skills/`
(稼働中のcache・history.jsonl等で確認済み)。apm組み込みの`--target antigravity`は
`~/.agents/skills/`にしかデプロイせず実態と合わないため、**apmのantigravity
ターゲットは使わない**。

代わりに `gemini/antigravity-cli/skills/<name>` を `.apm/skills/<name>` への
symlinkにしている。Skillを追加・削除したら、このsymlinkも合わせて追加・削除する。

### Codex CLI

このMacには未インストールのため実機での動作は未検証。

`setup.sh`の`install_codex()`から`apm install --root "$HOME" --target codex`を
実行し、Skill(`~/.agents/skills/`)とAgent(`~/.codex/agents/`)をデプロイする。

検証時の注意: `--root`と`--target codex`の組み合わせで、同一プロジェクト
ディレクトリ内で他の`apm install`呼び出し(特に`--root`無しの実行)を挟むと、
生成された`apm.lock.yaml`により以降の`apm install`が
`No changes -- install state already up to date`として何もデプロイしない
現象を確認した。実際にCodexを使い始めて反映されない場合は、
`~/apm.lock.yaml`を確認するか、dotfilesリポジトリのルートで
`--root`を付けずに`apm install --target codex`を試す。

## トラブルシューティング

- 変更が反映されない場合は、まず `apm install --root "$HOME" --target claude,gemini`
  (またはcodexなら`--target codex`)を再実行する
- `~/apm.lock.yaml`, `~/apm_modules/`, `~/.gitignore`への追記は
  apmが管理用に生成する正常な副産物
- `No changes -- install state already up to date` と表示されて何も
  デプロイされない場合は、`~/apm.lock.yaml`の内容が実態と食い違っている
  可能性がある。詳細は[Codex CLI](#codex-cli)の節を参照
