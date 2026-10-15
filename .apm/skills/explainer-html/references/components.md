# テンプレートの部品

`assets/template.html` の部品の使い方。どの部品も、読み手が自分で確かめる手間を減らすためにある。

## 目次

- 章と印
- ラベル（事実と推測）
- 囲み
- コード片
- 比較表
- 確認事項カード
- 出典
- 引用

## 章と印

```html
<section class="ch">
  <h2 id="prereq" data-mark="chapter">前提知識</h2>
  <h3 id="prereq-terms" data-mark="chapter">用語と管理単位</h3>
  ...
  <h3 id="prereq-diff" data-mark="chapter">似た概念の違い</h3>
  ...
</section>
<section class="ch">
  <h2 id="main-topic" data-mark="chapter">本題</h2>
  ...
</section>
```

- `id` を付けた `h2` / `h3` が目次になる。`h3` は直前の `h2` の下に入る
- 印は目次の一番下の単位に付く。上の例では「用語と管理単位」「似た概念の違い」「本題」の3つ
  - 印付きの `h3` を持つ `h2`（上の「前提知識」）にはボタンが付かない。目次と見出しに子の集計が出る
  - 進捗の分母も一番下の単位の数になる
  - 印のためだけに `h3` を作らない。内容の区切りが無い章は `h2` のままでよい
- `data-mark="chapter"`: 「読んだ」「理解した」。「理解した」で完了と数える
- `data-mark="todo"`: 「実施済み」「回答済み」。どちらでも完了と数える
- 印が不要な見出し（参照一覧など）には `data-mark` を付けない
- `id` は変えない。変えると読み手が付けた印が外れる。章名を変えても `id` はそのまま残す

## ラベル（事実と推測）

```html
<span class="tag fact">確認済み</span>
<span class="tag untested">未検証</span>
<span class="tag guess">推測</span>
```

- 主張の直後に置く。`確認済み` には、確認日とどこを見たかを添える
- ラベルの無い文は、出典が付いた事実として読まれる。推測を混ぜない

## 囲み

```html
<div class="box tldr"><div class="box-t">結論</div><p>…</p></div>
<div class="box gap"><div class="box-t">仕様と実態のずれ</div><p>…</p></div>
<div class="box note"><div class="box-t">補足</div><p>…</p></div>
```

- `tldr`: 章の結論。章の冒頭に置く
- `gap`: 仕様と実データのずれ、ドキュメントとコードの食い違い。判断に効くので必ずこれで目立たせる
- `note`: 補足、更新履歴の1行（「10/15 更新: Q2 の回答を反映」など）

## コード片

```html
<figure class="code" data-start="120" data-hl="2,4-5">
  <figcaption>src/main/java/Foo.java:120-125</figcaption>
<pre>void load() {
    var rows = dao.findAll();
    ...</pre>
  <span class="note">121: 全件を毎回読む。123-124: キャッシュと索引を両方更新する</span>
</figure>
```

- `data-start`: 片の1行目の実際の行番号。行番号は自動で振られる
- `data-hl`: 注目行。片の中の相対行（1始まり）で書く。`2,4-5` なら 121, 123-124 行目
- `<pre>` の中身は HTML エスケープする（`<` → `&lt;`、`&` → `&amp;`）。`<pre>` の行頭はインデントしない
- `figcaption` には `パス:開始-終了` を書く。基準コミットは資料冒頭に1回書けばよい
- 要点だけに絞る。10行を超えるなら、省略記号（`// ...`）で間を詰めるか、パスと行番号だけにする
- GitHub などで行へのリンクが作れる場合は、`figcaption` をリンクにする（コミットハッシュ固定の URL）

## 比較表

似た概念が複数あるときに使う。行を概念、列を観点にする。

```html
<table>
  <tr><th>概念</th><th>何を表すか</th><th>管理単位</th><th>誰が設定するか</th><th>情報元</th></tr>
  <tr><td>A</td><td>…</td><td>アカウント</td><td>…</td><td><a class="cite" href="#ref-3">[3]</a></td></tr>
</table>
```

- 違いが出る観点だけを列にする。全部同じ値になる列は消す
- 各行に情報元の列を置く

## 確認事項カード

```html
<div class="ask">
  <div class="ask-head">
    <h3 id="ask-1" data-mark="todo" style="margin:0;font-size:15px">Q1. 〇〇フラグの用途</h3>
    <span class="to">宛先: 〇〇チーム</span>
    <button class="icon-btn copy" type="button">文面をコピー</button>
  </div>
  <div class="ask-body"><dl>
    <dt>経緯</dt><dd>…</dd>
    <dt>関係する仕組み</dt><dd>…</dd>
    <dt>今の状態</dt><dd>…</dd>
    <dt>確認したいこと</dt><dd>…</dd>
  </dl></div>
</div>
```

- 4項目はすべて埋める。この1枚だけを相手に貼っても通じるように書く
- 「確認したいこと」は、相手が Yes/No か短い答えで返せる形にする。選択肢があれば並べる
- コピーボタンは `dt` と `dd` を「【経緯】…」の形でクリップボードに入れる
- 回答が来たら、カードの末尾に回答（引用と出典）を足し、本文の該当章も更新する

## 出典

本文側:

```html
…デフォルトは無効になっている<a class="cite" href="#ref-2">[2]</a>。
…<a class="cite" href="#ref-4-1">[4-1]</a>
```

参照一覧側:

```html
<ol class="refs">
  <li id="ref-1"><span class="rid">[1]</span><span>
    <a href="https://…/src/Foo.java#L120-L125">Foo.java:120-125</a> — コード（main @ a1b2c3d）</span></li>
  <li id="ref-2"><span class="rid">[2]</span><span>
    <a href="https://…/archives/C123/p1700000000123456">#channel の返信</a>
    — Slack、2026-10-14 15:02、発言者 〇〇</span></li>
  <li id="ref-3"><span class="rid">[3]</span><span>
    DB: <code>SELECT flag, COUNT(*) FROM db.table GROUP BY flag</code>
    — 2026-10-15 実行、接続先 本番参照用</span></li>
  <li id="ref-4-1"><span class="rid">[4-1]</span><span>
    <a href="https://…">ライブラリ名 x.y.z の Bar.java:88</a> — ライブラリのソース</span></li>
</ol>
```

- 番号は出現順。同じ情報元の別箇所は `[4-1]`、`[4-2]` のように枝番にする
- 参照一覧の各行には、種別（コード、Slack、チケット、Wiki、DB、ライブラリ）と、日時・場所・発言者を書く
- チャットは、スレッドの親ではなく該当する返信のリンクにする
- コードのリンクはブランチ名ではなくコミットハッシュで固定する。行番号がずれないようにするため
- リンクが作れない情報元（社内のローカルファイルなど）は、1回の検索でたどれる語（ファイル名、チケット番号）を書く
- テンプレートは、参照一覧の各行に本文の最初の引用へ戻る「↩ 本文」リンクを自動で付ける

## 引用

重要な発言や仕様書の一文は、要約せずに原文を引用する。

```html
<blockquote>原文そのまま
  <span class="by">— 〇〇、#channel、2026-10-14 15:02 <a class="cite" href="#ref-2">[2]</a></span></blockquote>
```
