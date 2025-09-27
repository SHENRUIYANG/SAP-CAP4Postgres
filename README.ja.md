# ORBAI Core — CAP + PostgreSQL サービス

バージョン: 1.0.1
日付: 2025-09-27
作者: ORBAICODER
すべての内容は AI が生成したものです。利用時は十分ご注意ください。
---

本プロジェクトは SAP CAP (Cloud Application Programming Model) と PostgreSQL を基盤とし、プロジェクト、出張エントリ、請求書、仕訳ルールなどのドメインを含む出張・請求管理向け OData V4 サービスを提供します。ワンコマンド起動スクリプトでローカル環境をすばやく立ち上げて検証できます。

- ベース URL (ローカル例): http://localhost:4004
- サービス: /travel (出張ドメイン)、/trbooking (仕訳ルールドメイン)
- API 詳細: リポジトリ直下の API_Documentation.md を参照

## 目次
- 技術スタック
- リポジトリ構成
- クイックスタート
- 起動 & 便利なスクリプト
- 環境変数 & セキュリティ
- API & テスト
- デプロイ推奨事項
- FAQ
- ライセンス & メンテナー

## 技術スタック
- Node.js >= 18
- SAP CAP (@sap/cds 9.x)
- PostgreSQL (@cap-js/postgres ドライバー)
- Express + CORS (server.js に統合)

## リポジトリ構成 (抜粋)
- /db/schema.cds: ドメインモデル (既存の PostgreSQL 物理テーブルにマッピング)
- /srv/*.cds, /srv/*.js: サービス定義と実装
- /server.js: CAP ブートストラップ (.env ロード、CORS など)
- /start.sh: ワンコマンド起動 (start/watch、profile、port に対応。起動時に有効ポートを表示)
- /API_Documentation.md: OData API 説明
- /test_case.txt: 検証済みの Action/Function 呼び出しとサンプル
- /.cdsrc.json: CAP ランタイム設定 (requires/db、認証など)
- /.env.example: 環境変数テンプレート (コピーして .env に実値を入力)

## クイックスタート
1) 環境準備
- Node.js 18+ と npm をインストール
- 接続可能な PostgreSQL データベースを用意 (例: ORBAICORE)

2) 依存関係のインストール
- npm ci または npm install

3) 環境変数の設定
- .env.example を .env にコピーし、データベース情報 (PGHOST/PGPORT/PGUSER/PGPASSWORD/PGDATABASE) を入力
- 本番環境では BASIC_ADMIN_PASSWORD と BASIC_VIEWER_PASSWORD を設定 (server.js の Basic 認証用)

4) サービス起動 (いずれかを選択)
- スクリプト: ./start.sh start --profile development --port 4004
- 開発/watch: ./start.sh watch --profile development --port 4004

> ヒント: start.sh は .env を自動で読み込みます。ポートは変更可能。未指定の場合は 4004 が使用され、起動ログに表示されます。

## 起動 & 便利なスクリプト
- ワンコマンドスクリプト
  - ./start.sh start --profile production --port 4004
  - ./start.sh watch --profile development --port 4004
- npm スクリプト
  - npm run start (node server.js)
  - npm run serve (cds serve)
  - npm run build (cds build)
  - npm run deploy (cds deploy)
  - npm run dev (cds watch --with-mocks --in-memory)

### ポートを変更する 3 つの方法
- CLI パラメータ: ./start.sh start --port 5000 または ./start.sh watch --port 5000
- 環境変数: .env もしくは CI で PORT=5000 を設定
- cds 設定: .cdsrc.json の "server" などでポートを定義 (有効化している場合)

## 環境変数 & セキュリティ
- .env をコミットしない (.gitignore で .env と機密/生成ファイルを除外済み)
- 推奨: .env または CI/CD のシークレットで DB・認証情報を注入
- .cdsrc.json 内の平文シークレットは環境変数へ移行することを検討 (必要なら Issue で相談可)

## API & テスト
- API ドキュメント: API_Documentation.md を参照 (エンティティ、アクション、関数、curl サンプル)
- 検証済みテストケース: test_case.txt (成功した ActionImports/FunctionImports の記録)
- メタデータ: /travel/$metadata, /trbooking/$metadata

例 (ローカル既定ポート 4004):
- GET http://localhost:4004/travel/invoices
- POST http://localhost:4004/travel/createInvoice
- GET http://localhost:4004/trbooking/getbookingrule()

## デプロイ推奨事項
- 本番: ./start.sh start --profile production を使用し、本番 DB を設定
- Basic 認証 (またはより強固な認証基盤) を利用し、環境変数経由でパスワードを注入
- GitHub でブランチ保護、PR レビュー、必須ステータスチェックを有効化

## FAQ
- DB 接続失敗: .env の PGHOST/PGPORT/PGUSER/PGPASSWORD/PGDATABASE を確認し、DB の到達性をチェック
- 401/403 エラー: 本番プロファイルでは BASIC_ADMIN_PASSWORD/BASIC_VIEWER_PASSWORD を設定するか、開発プロファイル (モック認証) を利用
- ポート競合: --port (例: 5886) で別ポートを指定

## ライセンス & メンテナー
- ライセンス: ISC (package.json を参照)
- メンテナー: ORBAICODER

---

## 手順ごとのセットアップガイド

1) 前提条件
- Node.js ≥ 18 & npm (nvm 推奨)
- PostgreSQL (≥ 13) と psql クライアント、または Docker
- API テスト用に curl/Postman もしくは VSCode REST Client

2) データベース準備
- オプション A: ローカル PostgreSQL (psql)
  - データベースとアプリユーザーを作成 (プレースホルダーを置き換え、パスワードをリポジトリに残さない)
    - CREATE DATABASE ORBAICORE;
    - CREATE USER app_user WITH PASSWORD '<DB_パスワード>';
    - GRANT ALL PRIVILEGES ON DATABASE ORBAICORE TO app_user;
- オプション B: Docker クイックスタート (例)
  - docker run --name orbaicore-postgres -e POSTGRES_PASSWORD=<DB_パスワード> -e POSTGRES_DB=ORBAICORE -p 8579:5432 -d postgres:16
  - 注意: ポート 8579→5432 は一例。必要に応じて調整し、パスワードをリポジトリにハードコードしないでください。

3) 環境変数
- .env.example を .env にコピーし、以下を参考に実際の値を設定 (自分の環境に合わせて置換)
  - PGHOST=localhost
  - PGPORT=8579
  - PGUSER=app_user
  - PGPASSWORD=<DB_パスワード>
  - PGDATABASE=ORBAICORE
  - PORT=4004
  - BASIC_ADMIN_PASSWORD=<本番で設定>
  - BASIC_VIEWER_PASSWORD=<本番で設定>
- 開発プロファイルはモック認証 (.cdsrc.json) を使用。本番では環境変数経由の Basic 認証を推奨。

4) 依存関係のインストール
- npm ci (推奨) または npm install

5) 構造とサンプルデータの初期化 (任意)
- オプション A: CAP デプロイ (新規 DB/試作向け)
  - npm run deploy (または cds deploy)
- オプション B: リポジトリの CSV サンプルを取り込む (プロジェクト、仕訳ルール、出張エントリ、請求書のデモ)
  - psql インポート例 (ローカルの CSV パスを確認。Windows の場合はパス/引用符に注意):
    - \COPY public.a_tr_cn_t_project(projectid,customerid,description) FROM 'backups/postgres/2025-09-27/a_tr_cn_t_project.csv' WITH (FORMAT csv, HEADER true)
    - \COPY public.a_tr_cn_c_bookingrule(code,description,textelementapp,textelementid) FROM 'backups/postgres/2025-09-27/a_tr_cn_c_bookingrule.csv' WITH (FORMAT csv, HEADER true)
    - \COPY public.a_tr_cn_t_travelentry(travelid,userid,fromdate,todate,destination,projectid) FROM 'backups/postgres/2025-09-27/a_tr_cn_t_travelentry.csv' WITH (FORMAT csv, HEADER true)
    - \COPY public.a_tr_cn_t_invoices(invoiceno,travelid,userid,invoicedate,totalnetamount,taxamount,grossamount,bookingcode) FROM 'backups/postgres/2025-09-27/a_tr_cn_t_invoices.csv' WITH (FORMAT csv, HEADER true)

6) サービス起動
- スクリプト (推奨):
  - ./start.sh start --profile development --port 4004
  - ./start.sh watch --profile development --port 4004
- npm から実行:
  - npm run start (node server.js)
  - npm run serve (cds serve)

7) 検証 & テスト
- メタデータ:
  - GET http://localhost:4004/travel/$metadata
  - GET http://localhost:4004/trbooking/$metadata
- 読み取り/書き込み例:
  - GET http://localhost:4004/travel/invoices?$top=3
  - POST http://localhost:4004/travel/createInvoice (リクエスト例は API_Documentation.md)
  - GET http://localhost:4004/trbooking/getbookingrule()
- 推奨: API_Documentation.md のサンプルを使い、Postman/VSCode REST Client あるいは curl で実行。

8) トラブルシューティング
- DB 接続: .env の PGHOST/PGPORT/PGUSER/PGPASSWORD/PGDATABASE を確認し、DB とファイアウォールの到達性をチェック
- 401/403: 開発ではモック認証、本番では BASIC_ADMIN_PASSWORD/BASIC_VIEWER_PASSWORD を設定するか、より強力な認証に切り替え
- ポート競合: --port または PORT で変更。起動時のログに有効ポートが表示されます。

9) 本番運用メモ
- ./start.sh start --profile production を使用し、本番向け DB と認証を用意
- シークレットは環境変数またはシークレットマネージャーに保存し、設定ファイルへの平文記載は避ける
- GitHub でブランチ保護、PR レビュー、必須チェックを設定

10) 参考
- API ドキュメント: ルートの API_Documentation.md
- サンプルバックアップ: backups/postgres/2025-09-27/ (4 テーブル分の CSV)
