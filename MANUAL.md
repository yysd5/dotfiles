# 新Mac TODO

## Mac設定

- ✅️ログインパスワード変更
- ✅️ダークモードにする
- ✅️capslockをctrlにする（USキーボード）
- ✅️バッテリー%表示
  - 設定のコントロールセンターから可能
- ✅️ステージマネージャON
  - 設定のコントロールセンターでメニューバーに表示させそこから有効化可能
- ✅️Dockから要らないものを削除
- ✅️スクリーンショットの保存先をデフォルトのデスクトップから専用の場所に変更しておく
  - ［Command］＋［Shift］＋［5］キーを押し、スクリーンショットメニューの［オプション］をクリックして、表示されるメニュー上部の［保存先］セクションで好きなフォルダを選択すると変更できる

## 通知

通知方法は「通知パネル」にしておく（手動で消すまで画面に出たまま）

- ✅️カレンダーの通知が来るようにする
- ✅️Slackの通知が来るようにする

## Bluetooth接続しておく

- ✅️Keyboard
- ✅️Trackpad
- ✅️airpods

## ファイル移行

- ✅️iOSメモ移行
  - [Mac純正メモアプリのデータを別端末（Mac）に移行させる方法 - MiFFlog](https://www.leo-m-aquarius97.com/mac_memo_app/)
- ✅️最近作業していてクラウド上にも無いファイル群などをコピーしてくる

## 必要アプリケーションインストール

- ✅️Slack
- ✅️Zoom
- ✅️drawio
- ✅️Evernote
- ✅️Google日本語入力
  - インストール後に再起動が必要
  - https://www.radical-dreamer.com/pc/google_ime_on_mac/
- ✅️Google Meetアプリインストール
  - http://jicoo.com/magazine/blog/google-meet-app
- ✅️bettertouchtools
  - ライセンスインポート
  - 設定インポート
    - 自分のgmail検索するとライセンスファイルのメールある
- ✅️Raycast
  - インストールしたらアプリ上でログインしCloud Syncをオンにする
  - Cmd + Spaceを起動ショートカットにする
    - Cmd + SpaceはデフォルトではMac標準のSpotlightが開くので、オフする
      - キーボード→キーボードショートカット→Spotlightでオフ可能
  - my-snippetsをcloneしておく
  - カレンダーを連携しておく（会議に参加しやすくするため）
    - https://qiita.com/nagauta/items/4286a45d96be6aafb32e

## 開発

- ✅️iTerm2インストール
- ✅️コマンドラインツールのインストール（XCode）
  - ターミナルでgitコマンドを実行すると無いのでコマンドラインツールをインストールするか聞かれる
- ✅️dotfilesインストール
- ✅️sshキーをコピー
  - ~/.ssh配下をもっていけばOK
- ✅️Docker Desktop入れる
  - docker composeも一緒に使えるようになる
- ✅️VSCodeインストール
  - (同期使っていない場合)プロファイル移行 https://qiita.com/The-town/items/dcb29a138908ac79a2ea
  - AIが使える確認

### Python
(- pyenvインストール)
- ✅️pythonインストール
  - https://www.python.org/downloads/ から最新のPythonを入れておく
  - `sudo ln -sf /Library/Frameworks/Python.framework/Versions/3.13/bin/python3 /usr/local/bin/python`のようにして`python3`ではなく`python`コマンドで使えるようにしておく
- ✅️uvインストール
  - https://docs.astral.sh/uv/getting-started/installation/
- ✅️ruffインストール
  - `uv tool install ruff@latest`
    - https://docs.astral.sh/ruff/installation/

### Go

- ✅️goインストール
  - `brew install go`

## Chrome（Googleアカウントによる同期が使えない場合）
- ✅️ブックマークと開いているタブのインポート
	- 開いているタブはブックマークとしてエクスポートできる
		- https://detail.chiebukuro.yahoo.co.jp/qa/question_detail/q10275424330
 
### 拡張機能

- ✅️ProxySwitchyOmega3(ZeroOmega)
  - 旧Macで設定をエクスポートし新Macでインポート
- ✅️Evernote WebClipper
- ✅️Authenticator
  - 旧Macでバックアップファイルをエクスポートし新Macでインポート
    - https://mp-faq.gmo-pg.com/s/article/F00064
- ✅️テキストエンコーディング
- ✅️DeepL

# 旧Mac クリーンアップTODO

## アンインストール

- ✅️Evernote
- ✅️Raycast
- ✅️bettertouchtool

## ログアウト

- ✅️Google
- ✅️GitHub
- ✅️connpass
- ✅️Qiita
- ✅️OpenAI

# 脆弱性対応

各Macで手作業が要る対応の記録。`setup.sh`は入っているパッケージを更新しないので、
既存のMacではここの手順を手で実施する。

## HTTP2Shell(CVE-2026-111497、2026-10)

Brotliデコーダ(1.0.3〜1.2.0)の範囲外書き込み。`Content-Encoding: br`を展開する
Node.js・Bun・Python(PyPIの`brotli`/`brotlicffi`)などが影響を受ける。

- ✅️(個人Mac)Homebrewの`brotli`を1.2.1以上にする
  - `HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1 brew upgrade brotli`
  - Homebrewの`node`と`curl`は`brotli`を動的リンクしているので、これで直る
    - `/opt/homebrew/bin/node -p process.versions.brotli`が`1.2.1`になれば良い
  - 環境変数を付けないと、依存する`node`もメジャーバージョンが上がることがある
- ✅️(個人Mac)nvmのnodeを修正版(26.12.1/24.22.1/22.23.4以上)にする
  - `nvm install 24.22.1 && nvm alias default 24.22.1`
  - 20.x以前と25.xはEOLで修正版が無いので`nvm uninstall`する
  - グローバルnpmパッケージはバージョンごとなので、`npm/packages.txt`を見て入れ直す
  - nvmのnodeは`process.versions.brotli`が`1.2.0`のままなので、`node -v`で判断する
- ✅️(個人Mac)PyPIの`brotli`/`brotlicffi`が1.2.1未満で入っていないか確認する
  - `pip show brotli brotlicffi`(uvのtoolや各venvでも確認する)
- Bunを使っているなら1.4.4以上にする(`bun --version`)
- 会社Macでも同じ確認をする
