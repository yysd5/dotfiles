# データ形式（build.py に渡す JSON）

文字列のうち「HTML」と書いたものは HTML をそのまま書ける（`<code>`、`<strong>`、`<a href="#c5">` など）。
`<` をテキストとして出すときは `&lt;`。ページ内リンクは `#<id>` で、タブをまたいでも移動できる。

## トップレベル

```json
{
  "meta":   { ... },
  "learn":  { "minutes": 30, "sections": [ ... ] },
  "review": { "minutes": 40, ... }
}
```

## meta

| キー | 内容 |
| --- | --- |
| `title` | ページ名（タブ・一覧に出る）。例 `PROJ-123 レビュー補助` |
| `eyebrow` | 見出しの上の小さい文字。例 `feature/PROJ-123 → develop · レビュー補助` |
| `lead` | 見出しの下の説明（省略可、HTML） |
| `storageKey` | 「読んだ」状態の保存キー。ブランチごとに変える |
| `links` | `[{ "label": "仕様書", "url": "...", "text": "設計ページ v3" }, { "label": "行番号", "text": "HEAD <code>abc1234</code> 時点" }]` |

## learn.sections[]

```json
{
  "id": "b4", "tocLabel": "B-4 マスタ突合せ", "tocGroup": "B. リクエスト処理",
  "eyebrow": "B. リクエスト処理",
  "title": "B-4 商品IDをマスタと突き合わせる",
  "purpose": { "why": "HTML", "io": "入力 → 出力（HTML）", "rel": "今回との関係（HTML）" },
  "blocks": [ ... ]
}
```

- `tocGroup` は目次の小見出し。そのグループの最初の節にだけ付ける
- `id` は learn と review の全体で一意

### blocks[] の種類

| type | フィールド | 用途 |
| --- | --- | --- |
| `prose` | `paragraphs: [HTML]` | 段落 |
| `heading` | `text` | 小見出し（h3） |
| `caption` | `html` | 図や表の説明文 |
| `cards` | `items: [{label, html}]` | 要点のカード |
| `table` | `head: [HTML]`, `rows: [[HTML]]` または `[{cells, cls}]`, `caption`, `note`, `small` | 表。`small: true` でデータ例の小さい表（`table.dbt`）になる。行の `cls` は `new`（追加行の色）/ `dim` |
| `mermaid` | `src`, `caption`, `legend` | 全体の流れの図 |
| `code` | `title`, `file`, `line`, `lang`, `code` | 変更前のコード片。行頭 `!` でハイライト。`lang` は `java` / `xml` / `protobuf` など（highlight.js の言語名） |
| `html` | `html` | データの絵など自由な HTML（`references/content-guide.md` の CSS クラス） |
| `point` | `items: [HTML]` | 「押さえておくこと」 |
| `later` | `html`, `link` | 「レビュー本編タブでは」と本編へのリンク（`link` は change の id） |
| `glossary` | `groups: [{title, items: [[用語, 説明HTML]]}]` | 用語集 |
| `quiz` | `items: [{q, a}]` | セルフチェック（答えは折りたたみ） |
| `simulator` | 下記 | ケース別の挙動 |

`legend`: `[{ "color": "rgba(46,160,67,0.35)", "border": "#2ea043", "label": "新規" }, { "label": "色の無いところは従来どおり" }]`

### simulator

```json
{
  "type": "simulator",
  "axes": [
    { "legend": "1つ目の条件", "options": [{ "value": "ok", "label": "値あり", "note": "例: 123" }, ...] },
    { "legend": "2つ目の条件", "options": [ ... ] }
  ],
  "outputs": [{ "key": "log", "label": "ログの列" }, ...],
  "results": {
    "ok":      { "title": "通常の経路", "pill": { "cls": "p-url", "label": "1 通常" }, "fields": { "log": "HTML", ... }, "why": "HTML" },
    "null|ok": { ... }
  }
}
```

- 結果は `"<軸1>|<軸2>"` で引き、無ければ `"<軸1>"` で引く。`"<軸1>"` だけで決まる場合（2軸目が関係ない場合）は2軸目が無効表示になる
- `pill.cls`: `p-url` / `p-fqdn` / `p-none` / `p-bad` / `p-ok`（色の違い。名前は用途に合わせて流用してよい）

## review

```json
{
  "minutes": 40,
  "intro": "（省略可）作者の意図は推定である旨の説明。省略時は既定文",
  "summary": {
    "note": "HTML（例: 修正必須は無い。nits は規約を引用できるものが無いので出していない）",
    "testTitle": "（省略可）",
    "tests": [{ "label": "HTML", "result": "120 件成功" }],
    "testNote": "HTML（失敗・スキップの理由、実行していないもの）",
    "tips": ["HTML（時間の使い方）"]
  },
  "purposeNote": "HTML", "purpose": [{ "q": "何を達成するか", "a": "HTML", "src": "出典 HTML" }],
  "impactNote": "HTML", "impact": [{ "what": "HTML", "where": "HTML（件数と path:line）", "why": "HTML" }],
  "diagrams": [{ "id": "after-seq", "title": "変更後の処理順", "tocLabel": "...", "caption": "HTML", "legend": [...], "src": "mermaid" }],
  "trace": [{ "spec": "HTML", "change": "c5", "test": "HTML（空ならテストなし）" }],
  "parts": [ ... ]
}
```

### parts[]

```json
{
  "id": "p2", "eyebrow": "Part 2", "title": "中核ロジック", "intro": "HTML",
  "changes": [{
    "id": "c5", "title": "キャッシュに無いときの判定を変える", "focus": "hot",
    "ref": false,
    "file": "app/src/main/java/.../OrderServiceImpl.java", "line": 120,
    "lang": "java",
    "diff": "     if (...) {\n-    old\n+    new\n...",
    "cmds": ["（省略可）コピーできるコマンド"],
    "say": ["作者の意図（推定）の段落 HTML"],
    "look": ["作者が見てほしいと思われる点 HTML"],
    "ai": [ 指摘 ]
  }]
}
```

- `ref: true` は「既存コード・変更なし」（前提として載せるだけのコード）
- `diff` は行頭に `+` / `-` / 空白、`@@` 行、`...` 行（省略）を使える

### 指摘（ai[]）

```json
{
  "lv": "sug", "ev": "R4",
  "where": "OrderServiceImpl.java:130 / OrderLogWriter.java:71",
  "persp": "3-2 重複ロジック",
  "short": "ひとことで言うと（30〜60字）",
  "body": "HTML（常体）",
  "why": "なぜ人間の判断か（判断が要るもののみ）",
  "view": "AI の見解",
  "options": ["A. ...", "B. ..."],
  "resolve": "何を確認すれば決着するか（check のみ）",
  "draft": "PR コメントの雛形（丁寧な提案調、タグは書かない）",
  "code": "修正案のコード（任意）", "codeLang": "java", "codeNote": "前提や合わせて直すテスト（任意）"
}
```

レベルと根拠の基準は `references/triage.md`。
