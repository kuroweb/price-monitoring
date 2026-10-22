# ローカル開発

開発参加者向けの共通セットアップ・日常操作の正本。すべてのシェル例は、ホストのリポジトリルートから実行する。
アプリの言語ツールは Docker Compose / just 経由で対象コンテナ内で実行する。実行先の全一覧と AI 向けの制約は [AGENTS.md](../../AGENTS.md#コマンドの実行場所) を参照する。

## 初回セットアップ

### 1. ホストの準備

Docker Compose v2.24.0 以降（任意の `env_file` を利用するため）、just、mkcert を準備する。macOS で mkcert を導入する場合は、ホストで次を実行する。

```bash
brew install mkcert
mkcert -install
```

共通の Nginx が使う BFF / Provider 両方の開発用証明書をホストで作成する。

```bash
mkdir -p volumes/nginx/certs/auth-provider
mkcert \
  -cert-file volumes/nginx/certs/fullchain.pem \
  -key-file volumes/nginx/certs/privkey.pem \
  dev.price-monitoring.com
mkcert \
  -cert-file volumes/nginx/certs/auth-provider/fullchain.pem \
  -key-file volumes/nginx/certs/auth-provider/privkey.pem \
  dev.auth-provider.com
```

ホストの `/etc/hosts` に以下を設定する。

```text
127.0.0.1 dev.price-monitoring.com dev.auth-provider.com
```

新規環境ではルートの環境変数ファイルを準備する。既存の `.env` は上書きしない。

```bash
cp .env.example .env
```

旧 auth-provider 環境から移行する場合は、以降の新規準備の前に [既存環境の引き継ぎ](../auth-provider/migration.md) を行う。

### 2. イメージの準備

ホストから Compose の開発用イメージをビルドする。

```bash
docker compose build
```

### 3. アプリの初期化

BFF の DB を `backend` コンテナで準備する。関連 DB / Redis は Compose が起動する。
Provider の署名鍵・DB の準備と OIDC クライアント登録は、このコマンドの前提ではない。先に BFF の DB を準備し、続いて Provider の初回準備を行う。

```bash
docker compose run --rm backend bundle exec rails db:prepare
```

Provider の新規環境では [認証固有の初回準備](../auth-provider/setup.md#初回準備) で署名鍵と DB を準備する。既存環境の引き継ぎでは署名鍵を作り直さない。

### 4. 起動と認証クライアント登録

ホストから全サービスをバックグラウンド起動し、状態を確認する。

```bash
just up
just ps
```

新規環境では起動後に [OIDC クライアント登録](../auth-provider/setup.md#oidc-クライアント登録) を行う。

| 接続先 | URL |
| --- | --- |
| メインアプリ | https://dev.price-monitoring.com/ |
| 認証プロバイダー | https://dev.auth-provider.com/ |

## 日常操作

起動と状態確認は上の手順を使う。ログ確認・再起動・停止も、ホストから Compose 全体または指定 service に対して行う。

```bash
just logs
just restart backend
just restart-all
just attach backend
just down
```

`logs` はログをフォローするため、終了時は Ctrl-C を使う。`attach` はコンテナのメインプロセスに接続する。シェルを開く用途には使わない。
全コマンドと引数の定義は [justfile](../../justfile) を参照する。

## 依存関係の更新・調査

frontend の npm 依存関係は `frontend` コンテナで追加・更新する。

```bash
docker compose run --rm frontend npm i
```

Ruby の依存関係は対象アプリのコンテナで扱う。BFF / batch は `backend`、Provider は `auth-provider` を使う。読み取り目的の調査も同じ実行先を使う。

```bash
docker compose run --rm backend bundle install
docker compose run --rm auth-provider bundle install
docker compose exec auth-provider bundle show doorkeeper
```

Rails 自体の更新は [Rails バージョンアップ](../backend/operations/rails-upgrade.md) を参照する。

## テスト

初回セットアップ後、対象 service が起動していることを確認する。以下はホストから実行し、just が起動中の `backend` / `auth-provider` コンテナ内で RSpec を実行する。
Provider のテスト DB・アセットは先に [認証の検証準備](../auth-provider/verification.md) を行う。

```bash
just rspec-backend
just rspec-auth-provider
```

対象ファイル・行・RSpec オプションを指定できる。以下の `<target>` と行番号は対象に置き換える。

```bash
just rspec-backend spec/models/<target>_spec.rb
just rspec-backend spec/models/<target>_spec.rb:42
```

失敗したら対象 spec を単体で再実行し、必要に応じて日常操作のログで依存サービスの状態を確認する。

frontend の静的検証は `frontend` コンテナで実行する。

```bash
docker compose exec frontend npm run lint
docker compose exec frontend npm run typecheck
```

frontend の単体・コンポーネントテストは Vitest と React Testing Library を使う。初回導入時や依存関係更新後は、起動中の `frontend` コンテナで `docker compose exec frontend npm ci` を実行する。BFF や認証の接続は不要。

```bash
just test-frontend
just test-frontend-watch
just test-frontend-coverage
```

通常実行は一度で終了し、watch は変更時に再実行する。カバレッジはターミナルと `volumes/frontend/coverage/` に出力する。未テストの実装も集計するが、導入時点ではカバレッジの下限を設けない。

対象ファイルやテスト名を絞る場合は引数を渡す。角括弧を含むパスはシェルの展開を避けるため引用する。

```bash
just test-frontend CategoryNavigation.test.tsx
just test-frontend 'tests/features/products/[id]/lib/makePlatformMask.test.ts'
just test-frontend -t '最初のページ'
```

テストの配置と対象範囲は [Frontend のテスト方針](../frontend/index.md#テスト方針)を参照する。PR では [Frontend CI](../cicd/index.md#pull-request-の自動テスト) が lint・型検査・テストを実行する。

## 関連手順

- [Seed データの投入](../backend/operations/seeds.md)
- [認証基盤の準備・引き継ぎ・検証](../auth-provider/index.md)
- [CI/CD と自動レビュー](../cicd/index.md)
