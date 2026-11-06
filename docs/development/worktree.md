# Orca の worktree

Orca の worktree で、メインと並行して別の開発環境を動かす開発者向けの手順。以下は worktree のリポジトリルートで実行する。

## setup の動作

[orca.yaml](../../orca.yaml) の setup は、Orca が worktree を作るときに実行され、次を行う。

- gitignore された環境変数・署名鍵・証明書と frontend の `node_modules` をメインからコピーする。worktree にすでにあるものは上書きしない。
- コピーした `.env` から `COMPOSE_PROJECT_NAME` と `COMPOSE_FILE` を消し、`COMPOSE_FILE=docker-compose.yml:docker-compose.worktree.yml` を書き込む。`COMPOSE_PROJECT_NAME` が残っていると、worktree の `just` がメインのコンテナを操作する。
- `.env` に `WORKTREE_HTTPS_PORT` が無ければ 8443 から空きを割り当て、既存の値は維持する。避けるのは他の worktree の `.env` にある番号だけで、他アプリが使っているポートは調べない。

setup が使うのは、作った worktree にある `orca.yaml`、つまり作成元のブランチにコミットされた内容になる。`orca.yaml` の変更は、作成元のブランチにコミットするまで新しい worktree に反映されない。`orca.yaml` を初めて使うときと変更した後は、Orca の確認画面で setup の実行を許可する。

公開 URL は `https://dev.price-monitoring.com:<port>/` と `https://dev.auth-provider.com:<port>/` になる。worktree で `just url` を実行すると、ポートを埋めた URL を表示する。

## 対象環境の確認

シェルで `export` した `COMPOSE_FILE` / `COMPOSE_PROJECT_NAME` / `WORKTREE_HTTPS_PORT` は `.env` より優先される。残っていると別の環境を操作するので、worktree で Docker Compose / just を実行する前に `unset` する。`docker compose -p` も付けない。認証設定の詳細は [OIDC クライアント登録](../auth-provider/setup.md#oidc-クライアント登録) を参照する。

## 新規 worktree の初期化

[対象環境の確認](#対象環境の確認) を済ませてから、起動前に次を確認する。

```bash
docker compose config --quiet
just ps
```

`docker compose config --quiet` は `WORKTREE_HTTPS_PORT` が未設定なら失敗する。`just ps` では、project 名が worktree のディレクトリ名になっていることを確認する。

DB はコピーされないので、[アプリの初期化と起動](setup.md#アプリの初期化と起動) の `just prepare` を実行する。コピーされた署名鍵は生成し直さない。既存 DB の認証設定を変えるときは [Provider DB の再作成](../auth-provider/setup.md#ローカル-provider-db-の再作成) を使う。

frontend はソースを `/app` にマウントしてイメージ内の `node_modules` を隠すので、setup がメインの `node_modules` をコピーする。ブランチの `package-lock.json` がメインと異なるときは、起動前に `docker compose run --rm frontend npm ci` を実行する。

## ポートの衝突

複数の worktree を同時に作ると、setup が同じ `WORKTREE_HTTPS_PORT` を割り当てることがある。`just up` でポートが衝突したら、`.env` の `WORKTREE_HTTPS_PORT` を空き番号に変える。DB への反映は [ポート変更](../auth-provider/setup.md#worktreeのポート変更) に従う。
