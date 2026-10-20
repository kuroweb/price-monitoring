# Seed データの投入

BFF / batch の開発者向けの投入手順。共通セットアップと起動は [ローカル開発](../../development/index.md) を済ませる。
以下はホストのリポジトリルートから実行し、処理は起動中の `backend` コンテナで行う。

## 全 Seed の投入

開発環境の DB に全 Seed を投入する。

```bash
docker compose exec backend bundle exec rails db:seed -e development
```

## 特定の Seed の投入

`<seed_name>` は `volumes/backend/db/seeds/` にある対象ファイルの拡張子を除く名前に置き換える。現在このディレクトリは `.keep` のみで、投入データはない。Seed ファイルを追加すると対応するタスクが定義される。

```bash
docker compose exec backend bundle exec rails db:seed:<seed_name> -e development
```

全投入の入口は [db/seeds.rb](../../../volumes/backend/db/seeds.rb)、個別投入は [seed.rake](../../../volumes/backend/lib/tasks/seed.rake) に定義している。
対象ファイルの処理と投入先を確認して実行する。これらはローカル開発向けの例で、本番データへの投入手順ではない。
