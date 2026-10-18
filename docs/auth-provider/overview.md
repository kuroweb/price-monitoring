# 認証基盤

認証基盤は price-monitoring と同じリポジトリ・Docker Compose で管理する。OIDC Provider と Client の境界は維持し、Rails アプリ・DB・Redis を分ける。Kubernetes では環境ごとに price-monitoring の namespace / Application にまとめる。

| 用途 | 配置 / Compose service |
| --- | --- |
| Client / BFF | `volumes/backend` / `backend` |
| Provider（Devise / Doorkeeper） | `volumes/auth-provider` / `auth-provider` |
| Provider の Dockerfile | `containers/auth-provider` |
| 共通の HTTPS proxy | `volumes/nginx` / `nginx`（ホスト名で BFF / Provider を振り分け） |
| Provider の MySQL / Redis | `auth-provider-db` / `auth-provider-redis` |

## 初回セットアップ

リポジトリルートで実行する。Docker Compose v2.24.0 以降が必要（任意の `env_file` を利用するため）。

```bash
openssl genrsa -out volumes/auth-provider/certs/private.pem 2048
mkcert \
  -cert-file volumes/nginx/certs/auth-provider/fullchain.pem \
  -key-file volumes/nginx/certs/auth-provider/privkey.pem \
  dev.auth-provider.com
```

`/etc/hosts` に以下を設定する。BFF 側の証明書・hosts もルート README に従って準備する。

```text
127.0.0.1 dev.price-monitoring.com dev.auth-provider.com
```

```bash
cp .env.example .env
docker compose build
docker compose run --rm auth-provider bundle exec rails db:prepare
just up
```

Provider 固有の環境変数が必要なら `volumes/auth-provider/.env` に置く。このファイルは任意で、BFF の `.env` と分けて読み込む。

https://dev.auth-provider.com/ でユーザー登録し、必要なユーザーに管理権限を付与する。

```bash
docker compose exec auth-provider bundle exec rails console
```

コンソールで対象ユーザーを明示して管理権限を付与する。

```ruby
User.find_by!(email: "自分のメールアドレス").update!(admin: true)
```

管理ユーザーで `/oauth/applications` を開き、クライアントを登録する。

- Redirect URI: `https://dev.price-monitoring.com/auth/auth_provider/callback`
- Scopes: `openid email profile`
- Confidential: 有効

発行された値をルート `.env` の `OIDC_CLIENT_ID` / `OIDC_CLIENT_SECRET` に設定し、`docker compose up -d backend` で環境変数を反映する。`OIDC_ISSUER` は `https://dev.auth-provider.com` を使う。

## 既存 auth-provider 環境の引き継ぎ

旧リポジトリで `just down` を実行してから、統合後の環境を起動する。旧環境と同時に起動すると DNS alias・永続データが競合する。`/etc/hosts` の `dev.auth-provider.com` は `127.0.0.2` から `127.0.0.1` へ変更する。ループバックエイリアスの追加は不要。

次のファイルを同じ内容で移す。新しい署名鍵を生成し直さない。

| 旧リポジトリ | このリポジトリ |
| --- | --- |
| `volumes/backend/certs/private.pem` | `volumes/auth-provider/certs/private.pem` |
| `volumes/backend/config/master.key`（存在する場合） | `volumes/auth-provider/config/master.key` |
| `volumes/nginx/certs/fullchain.pem` / `privkey.pem` | `volumes/nginx/certs/auth-provider/` |
| `.env` | `volumes/auth-provider/.env` |

これらの秘密情報は Git に登録しない。BFF の `.env` にある OIDC クライアント情報はそのまま使う。

Compose の永続ボリューム名は旧構成の `auth-provider_backend-db` / `auth-provider_backend-redis` を明示している。両方の既存ボリュームがあることを `docker volume ls` で確認し、ルート `.env` に `AUTH_PROVIDER_EXISTING_VOLUMES=true` を設定する。既存ボリュームを external として参照し、Compose による再作成を防ぐ。同じ Docker daemon 上では既存のユーザー・OAuth クライアント・トークンを引き継ぐ。セッションの継続には同じ `SECRET_KEY_BASE` も必要。旧環境で Compose project 名を変更していた場合は、実際のボリューム名に合わせてから起動する。

別の Docker daemon に移す場合は MySQL のバックアップ・リストアが必要。`docker compose down -v` は認証データも削除するため、引き継ぎに使わない。

## 検証・日常操作

```bash
just up
just ps
docker compose logs --tail=100 auth-provider nginx
docker compose run --rm -e RAILS_ENV=test auth-provider bundle exec rails db:prepare
docker compose run --rm -e RAILS_ENV=test auth-provider bundle exec rails tailwindcss:build
just rspec-auth-provider
just rspec-backend spec/requests/sessions_controller_spec.rb spec/requests/oidc_token_control_spec.rb
just down
```

https://dev.price-monitoring.com/auth/test からログインし、Provider での認証後に BFF へ戻ること、ログアウト後に BFF のログイン状態が解除されることを確認する。

## CI とデプロイ

Integration / Production workflow は Provider の変更を検出し、専用の RSpec job を実行する。

Kubernetes マニフェストは k8s リポジトリの `manifests/price-monitoring` に統合し、環境ごとに `price-monitoring-integration` / `price-monitoring-production` namespace を使う。認証用の DB・Redis・Secret は `auth-provider-*` として分離する。既存 PV の移行手順は k8s リポジトリの `docs/operations/auth-provider-namespace.md` を参照する。

このリポジトリからの Provider 用イメージのビルド・push・CD job の統合は別作業。実クラスタへの namespace 移行も、バックアップと手順確認後に実施する。

取り込み元: `kuroweb/auth-provider` の `870262c767aef54bab2ca00a03163f5152c312ff`。アプリのコードを取り込み、Git 履歴は統合していない。
