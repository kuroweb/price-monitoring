# Seed データの投入

BFF / batch の開発者向けの投入手順。共通セットアップと起動は [初回セットアップ](../../development/setup.md) を済ませる。
以下はホストのリポジトリルートから実行し、処理は起動中の `backend` コンテナで行う。

## 全 Seed の投入

開発環境の DB に全 Seed を投入する。

```bash
docker compose exec backend bundle exec env RAILS_ENV=development rails db:seed
```

## 特定の Seed の投入

`<seed_name>` は `volumes/backend/db/seeds/` にある対象ファイルの拡張子を除く名前に置き換える。`product_monitoring` は development だけで、画面確認用の収集設定とモニタリング設定を入れる。本番の起動では呼ばない。入れると、標準エラーにモニタリング設定の詳細のパスが出る。

```bash
docker compose exec backend bundle exec env RAILS_ENV=development rails db:seed:<seed_name>
```

全投入の入口は [db/seeds.rb](../../../volumes/backend/db/seeds.rb)、個別投入は [seed.rake](../../../volumes/backend/lib/tasks/seed.rake) に定義している。
対象ファイルの処理と投入先を確認して実行する。これらはローカル開発向けの例で、本番データへの投入手順ではない。
