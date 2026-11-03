# 認証の初回セットアップ

認証環境を準備する開発者向けの手順。Provider / Client の配置は [認証基盤](index.md) を参照する。以下は対象チェックアウトのリポジトリルートで実行する。

## 初回準備

共通の証明書・hosts・環境変数・イメージは [ローカル開発の初回セットアップ](../development/index.md#初回セットアップ) で準備する。署名鍵が無い新規環境でだけ、ホストで鍵を生成する。worktree では、メインに鍵があれば setup がコピーする。コピーされた鍵は生成し直さない。

```bash
openssl genrsa -out volumes/auth-provider/certs/private.pem 2048
```

鍵を準備したら [開発環境の準備](../development/index.md#3-アプリの初期化と起動) の `just prepare` を使う。BFF DB、Provider DB と seed、サービス起動の順に処理する。worktree の DB はメインと別なので、鍵がコピー済みでも DB の準備は必要になる。

Provider 固有の環境変数は任意の `volumes/auth-provider/.env` に置く。Compose の `environment` に定義された DB 接続、`DOMAIN_NAME`、OIDC クライアント設定などは、このファイルの同名値より優先される。

## OIDC クライアント登録

ローカルのクライアント ID・secret・redirect URI・issuer は [Compose](../../docker-compose.yml) が正本で、`.env` には置かない。Compose の固定値は同名のシェル環境変数でも変わらない。batch には Web 用の OIDC 設定を渡さない。

development の [seed](../../volumes/auth-provider/db/seeds.rb) は管理ユーザー `admin@example.com` / `password` と、コンテナの環境変数にある OIDC クライアントを登録する。未設定・空・空白のときは、ユーザーやクライアントを作る前に項目名付きで失敗する。`db:prepare` は既存 DB では seed を実行しないため、`just prepare` は Provider で `db:seed` を続けて必須値を確認する。

**seed は既存の secret・redirect URI を更新しない。** 同じ ID が既にあれば不一致も残る。Compose の変更とコンテナ再作成だけでは DB は同期されない。設定を変えたら下の再作成を行う。

## ローカル Provider DB の再作成

ローカルの認証設定を変えた場合は DB を作り直す。既存登録の移行コードや自動同期は用意しない。

以下は **対象環境の Provider DB のデータを削除する操作**。管理ユーザー、クライアント、発行済みトークンを失う。Rails の開発用 `db:drop` は Provider の development / test DB が対象となり、BFF DB やメインの別 Compose project は対象にしない。test DB も消えるため、Provider の RSpec を実行する前に [テスト準備](verification.md) の `db:prepare` をやり直す。実行前に [対象環境の確認](../development/index.md#設定変更と制約) を行う。

```bash
docker compose stop auth-provider
docker compose run --rm -e RAILS_ENV=development auth-provider bundle exec rails db:drop db:prepare db:seed
just up
just ps
```

初回準備や日常の起動にこの削除操作は不要。`just prepare` / `just up` は DB を削除しない。Compose の環境変数を変えたら `just up` でコンテナを作り直す。`just restart` では反映されない。

### worktreeのポート変更

worktree の `.env` の `WORKTREE_HTTPS_PORT` を空き番号に変更し、上記の Provider DB 再作成と起動を行う。OIDC 用の値を `.env` に追加する必要はない。

ポート変更で Cookie 名も変わるため、再ログインが必要になる。新しい URL で [認証の検証](verification.md) を行う。frontend の API 接続先の設定は変えなくてよい。
