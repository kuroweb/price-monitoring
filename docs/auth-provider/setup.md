# 認証の初回セットアップ

新しい認証環境を準備する開発者向けの手順。Provider / Client の配置は [認証基盤](index.md) を参照する。

## 初回準備

共通の証明書・hosts・環境変数・イメージは [ローカル開発の初回セットアップ](../development/index.md#初回セットアップ) で準備する。
以下のシェル例はホストのリポジトリルートから実行する。署名鍵はホストで生成し、DB 準備は `auth-provider` コンテナで行う。
新規環境でのみ実行し、既存環境から移行する場合は [引き継ぎ](migration.md) に従う。

```bash
openssl genrsa -out volumes/auth-provider/certs/private.pem 2048
docker compose run --rm auth-provider bundle exec rails db:prepare
```

Provider 固有の環境変数が必要なら `volumes/auth-provider/.env` に置く。このファイルは任意で、BFF の `.env` と分けて読み込む。
準備後はローカル開発ガイドに戻って全サービスを起動する。

## OIDC クライアント登録

development の `db:prepare` は、DB を作成したときに [db/seeds.rb](../../volumes/auth-provider/db/seeds.rb) で次のデータを登録する。

- 管理ユーザー: `admin@example.com` / `password`
- BFF の OIDC クライアント: ルート `.env` の `OIDC_CLIENT_ID` / `OIDC_CLIENT_SECRET` / `OIDC_REDIRECT_URI` を使い、Scopes は `openid email profile`、Confidential は有効

`OIDC_CLIENT_ID` / `OIDC_CLIENT_SECRET` が空ならクライアントは登録しない。既存の DB に登録するときや `.env` の値を変えたときは、ホストのリポジトリルートから Seed を投入する。登録済みのユーザー・クライアントは変更しない。

```bash
docker compose run --rm auth-provider bundle exec rails db:seed
```

`.env` の値を変えたときは、ホストのリポジトリルートから BFF を再作成して環境変数を反映する。

```bash
docker compose up -d backend
```
