# ER

BFF / batch のテーブル定義を確認する開発者向けのリファレンス。Provider の DB は対象外。
領域の分け方は [Database](index.md)、機能文書がまだ無い領域の関連は [アソシエーション](association.md)、商品モニタリングのテーブル定義と関連は [商品モニタリングの DB](../features/product-monitoring/database.md)、現在の定義は [schema.rb](../../volumes/backend/db/schema.rb) を参照する。

## backmarket_watch_results

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| backmarket_watch_target_id | bigint | NOT NULL | FK |
| name | string | NOT NULL |  |
| price | integer |  |  |
| condition | string |  |  |
| memory | string |  |  |
| storage | string |  |  |
| cpu | string |  |  |
| stock_status | string | NOT NULL |  |
| crawled_at | datetime | NOT NULL |  |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| idx_on_backmarket_watch_target_id_crawled_at_47ae23aa26 | backmarket_watch_target_id, crawled_at |  |
| index_backmarket_watch_results_on_backmarket_watch_target_id | backmarket_watch_target_id |  |

## backmarket_watch_targets

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| name | string | NOT NULL |  |
| url | string | NOT NULL |  |
| enabled | boolean | NOT NULL | default: true |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

なし

## product_monitoring_daily_market_prices

定義は [商品モニタリングの DB](../features/product-monitoring/database.md#product_monitoring_daily_market_prices) を参照する。

## product_monitoring_monitors

定義は [商品モニタリングの DB](../features/product-monitoring/database.md#product_monitoring_monitors) を参照する。

## product_monitoring_crawl_results

定義は [商品モニタリングの DB](../features/product-monitoring/database.md#product_monitoring_crawl_results) を参照する。

## product_monitoring_crawl_settings

定義は [商品モニタリングの DB](../features/product-monitoring/database.md#product_monitoring_crawl_settings) を参照する。

## users

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| name | text |  |  |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |
| email | string | NOT NULL | default: "" |
| provider_name | string | NOT NULL | default: "" |
| provider_uid | string | NOT NULL | default: "" |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| index_users_on_email | email |  |
| index_users_on_provider_name_and_provider_uid | provider_name, provider_uid | unique |
