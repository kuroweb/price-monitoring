# 依存関係の更新・調査

アプリの依存関係を更新・調査する開発者向けの手順。以下はホストのリポジトリルートから、対象の Docker Compose コンテナで実行する。

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

Rails 自体の更新は [Rails バージョンアップ](../../backend/operations/rails-upgrade.md) を参照する。
