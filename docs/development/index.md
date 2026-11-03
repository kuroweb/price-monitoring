# ローカル開発

開発参加者向けの共通セットアップ・日常操作の正本。すべてのシェル例は、ホストのリポジトリルートから実行する。
アプリの言語ツールは Docker Compose / just 経由で対象コンテナ内で実行する。実行先の全一覧と AI 向けの制約は [AGENTS.md](../../AGENTS.md#コマンドの実行場所) を参照する。

## 初回セットアップ

### 1. ホストの準備

Docker Compose v2.24.4 以降（任意の `env_file` と、worktree 用の設定の `!override` を利用するため）、just、mkcert を準備する。macOS で mkcert を導入する場合は、ホストで次を実行する。

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

### 2. イメージの準備

ホストから Compose の開発用イメージをビルドする。

```bash
docker compose build
```

### 3. アプリの初期化と起動

Provider の署名鍵が無い場合は、先に [認証の初回準備](../auth-provider/setup.md#初回準備) で生成する。worktree では、メインに鍵があれば setup がコピーする。コピーされた鍵は生成し直さない。ホストから状態を確認し、開発環境を準備する。

```bash
just ps
just prepare
just ps
```

`just prepare` は BFF の `db:prepare`、Provider の `db:prepare db:seed`、全サービスの起動の順に実行する。既存 DB は削除しない。Provider の登録内容と、設定変更時の再作成は [OIDC クライアント登録](../auth-provider/setup.md#oidc-クライアント登録) を参照する。

| 接続先 | URL |
| --- | --- |
| メインアプリ | https://dev.price-monitoring.com/ |
| 認証プロバイダー | https://dev.auth-provider.com/ |

## 日常操作

日常の起動は `just up`、状態確認は `just ps` を使う。`just up` は DB の準備や削除を行わない。ログ確認・再起動・停止も、ホストから Compose 全体または指定 service に対して行う。

```bash
just up
just ps
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

## Orca の worktree

[orca.yaml](../../orca.yaml) の setup は、gitignore された環境変数・署名鍵・証明書をメインからコピーする。コピー先にあるファイルは上書きしない。setup はコピーした `.env` から `COMPOSE_PROJECT_NAME` と `COMPOSE_FILE` を消し、`COMPOSE_FILE=docker-compose.yml:docker-compose.worktree.yml` を書き込む。`COMPOSE_PROJECT_NAME` が残っていると、worktree の `just` がメインのコンテナを操作する。`orca.yaml` を初めて使うときと変更した後は、Orca の確認画面で setup の実行を許可する。

`WORKTREE_HTTPS_PORT` が無ければ 8443 から空きを割り当て、既存の値は維持する。setup が避けるのは他の worktree の `.env` にある番号だけで、他アプリが使っているポートは調べない。起動前に `docker compose config --quiet` がエラーなく終わることを確認する。`WORKTREE_HTTPS_PORT` が未設定ならここで失敗する。続けて `just ps` で、project 名が worktree のディレクトリ名になっていることを確認する。

公開 URL は `https://dev.price-monitoring.com:<port>/` と `https://dev.auth-provider.com:<port>/` になる。ポートは `just ps` で確認する。

### 新規 worktree の初期化

DB はコピーされない。コピーされた鍵は生成し直さず、[アプリの初期化と起動](#3-アプリの初期化と起動) を実行する。既存 DB の認証設定を変えるときは [Provider DB の再作成](../auth-provider/setup.md#ローカル-provider-db-の再作成) を使う。

### 設定変更と制約

複数の worktree を同時に作ると、setup が同じ `WORKTREE_HTTPS_PORT` を割り当てることがある。`just up` でポートが衝突したら、`.env` の `WORKTREE_HTTPS_PORT` を空き番号に変える。DB への反映は [ポート変更](../auth-provider/setup.md#worktreeのポート変更) に従う。

シェルで `export` した `COMPOSE_FILE` / `COMPOSE_PROJECT_NAME` / `WORKTREE_HTTPS_PORT` は `.env` より優先される。残っていると別の環境を操作するので、worktree で起動する前に `unset` する。`docker compose -p` も付けない。認証設定の詳細は [OIDC クライアント登録](../auth-provider/setup.md#oidc-クライアント登録) を参照する。

## API の接続経路

ブラウザからの API リクエストは、`NEXT_PUBLIC_API_URL` が未設定ならページと同じ origin に送る。worktree ではポート付きになる。別 origin の API を使う環境だけ `NEXT_PUBLIC_API_URL` を設定する。

Next.js サーバーは `NEXT_PRIVATE_API_URL` で Compose 内の `backend` に直接接続する。公開ポートを変えても、frontend のこの設定は変えなくてよい。development の CORS は `localhost:8080` を許可しないので、画面は nginx の URL から開く。

## 関連手順

- [Seed データの投入](../backend/operations/seeds.md)
- [認証基盤の準備・検証](../auth-provider/index.md)
- [CI/CD と自動レビュー](../cicd/index.md)
