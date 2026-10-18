# Database Overview

このプロジェクトの database docs は、テーブル一覧を読むためのものではなく、どの単位でデータを分けているかを判断するための入口です。
詳細な定義は `er.md` と `association.md` に分離し、このページでは領域の切り方だけを扱います。

## 判断基準

- 商品を表す中心は `products` で、各プラットフォーム固有の収集結果は別テーブルに分ける
- クロール条件は `*_crawl_settings` と、その配下の required / exclude 系テーブルに分ける
- カテゴリや関連付けのような横断的な概念は、プラットフォーム固有テーブルへ閉じ込めず共通テーブルで管理する
- 日次集計のような派生データは、元データと別テーブルに分けて保存する

## テーブル群の見方

### 計測対象管理

- `products` が計測対象の中心
- `categories` `category_hierarchies` `product_category_maps` が分類の責務を持つ
- 管理対象が増えても、商品そのものと分類情報を同じテーブルに混ぜない

### クロール設定と収集結果

- 多くのプラットフォームは `*_crawl_settings` で検索条件を持ち、`required` / `exclude` 系テーブルに詳細を分離する
- `*_products` は収集済み商品データを持つ
- クロール条件とクロール結果はライフサイクルが違うので、同じテーブルに置かない
- Yahoo フリマ（`yahoo_fleamarket_*`）は `*_crawl_settings` を持たず、`yahoo_fleamarket_products` と日次集計だけを持つ

### Backmarket 監視

- `backmarket_watch_targets` が監視対象、`backmarket_watch_results` が取得結果を持つ
- 他プラットフォームの `*_crawl_settings` / `*_products` とは別パターンとして扱う

### 認証

- `users` は OpenID Connect 連携用の identity を持つ（商品・クロール領域とは分離する）

### 集計データ

- `*_daily_purchase_summaries` は相場把握のための派生データ
- 元データの更新と集計の更新を分離したいので、集計結果は別テーブルにする

## 避けること

- プラットフォーム固有の属性を `products` に直接足し続けない
- required / exclude のような繰り返し条件を 1 カラムへ押し込まない
- 集計済みの値で元データを上書きしない

## 関連 docs

- [`er.md`](./er.md)
- [`association.md`](./association.md)
- [`../README.md`](../README.md)

## 代表コード

- [`volumes/backend/db/schema.rb`](../../volumes/backend/db/schema.rb)
- [`volumes/backend/app/services/products/creator/create_product.rb`](../../volumes/backend/app/services/products/creator/create_product.rb)
- [`volumes/backend/app/controllers/api/v1/products_controller.rb`](../../volumes/backend/app/controllers/api/v1/products_controller.rb)

## 更新時に確認する source of truth

- [`volumes/backend/db/schema.rb`](../../volumes/backend/db/schema.rb)
- `volumes/backend/db/migrate/`
