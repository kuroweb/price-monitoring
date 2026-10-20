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

起動後、https://dev.auth-provider.com/ でユーザー登録し、必要なユーザーに管理権限を付与する。
ホストのリポジトリルートから `auth-provider` コンテナの Rails コンソールを開く。

```bash
docker compose exec auth-provider bundle exec rails console
```

このコンソール内で対象ユーザーを明示して管理権限を付与する。

```ruby
User.find_by!(email: "自分のメールアドレス").update!(admin: true)
```

管理ユーザーで `/oauth/applications` を開き、クライアントを登録する。

- Redirect URI: `https://dev.price-monitoring.com/auth/auth_provider/callback`
- Scopes: `openid email profile`
- Confidential: 有効

発行された値をルート `.env` の `OIDC_CLIENT_ID` / `OIDC_CLIENT_SECRET` に設定する。`OIDC_ISSUER` は `https://dev.auth-provider.com` を使う。
ホストのリポジトリルートから BFF を再作成して環境変数を反映する。

```bash
docker compose up -d backend
```
