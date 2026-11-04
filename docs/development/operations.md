# 日常操作

セットアップ済みの環境を起動・確認・停止し、依存関係を更新する開発者向けの手順。以下はホストの、対象チェックアウトのリポジトリルートで実行する。メインと worktree のどちらを操作するかは、実行したディレクトリで決まる。

## 起動と状態確認

日常の起動は `just up`、状態確認は `just ps` を使う。`just up` は DB の準備や削除を行わない。ログ確認・再起動・停止も、Compose 全体または指定 service に対して行う。

```bash
just up
just ps
just url
just logs
just restart backend
just restart-all
just attach backend
just down
```

- `url` は、実行したディレクトリの環境の project 名と、メインアプリ・認証プロバイダーの URL を表示する。画面のタブのタイトルとヘッダーにも project 名が出るので、メインと worktree のどちらを開いているかを見分けられる。
- `logs` はログをフォローするので、終了は Ctrl-C で行う。
- `attach` はコンテナのメインプロセスに接続する。シェルを開く用途には使わない。

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
