# テーブル定義

BFF / batch のテーブルのカラム・インデックス・外部キーを確認する開発者向けのリファレンス。Provider の DB は対象外。
テーブル間の関連の意味と ER 図は各機能の文書（商品モニタリングは [商品モニタリングの DB](../../features/product-monitoring/database.md)）に置く。現在の定義は [schema.rb](../../../volumes/backend/db/schema.rb) を参照する。

## backmarket_watch_results

### カラム

| カラム | 型 | NULL | 備考 |
| --- | --- | --- | --- |
| id | bigint | NOT NULL | PK |
| backmarket_watch_target_id | bigint | NOT NULL | FK → `backmarket_watch_targets.id` |
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
| --- | --- | --- |
| idx_on_backmarket_watch_target_id_crawled_at_47ae23aa26 | backmarket_watch_target_id, crawled_at |  |
| index_backmarket_watch_results_on_backmarket_watch_target_id | backmarket_watch_target_id |  |

## backmarket_watch_targets

### カラム

| カラム | 型 | NULL | 備考 |
| --- | --- | --- | --- |
| id | bigint | NOT NULL | PK |
| name | string | NOT NULL |  |
| url | string | NOT NULL |  |
| enabled | boolean | NOT NULL | default `true` |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

なし

## product_monitoring_crawl_results

### カラム

| カラム | 型 | NULL | 備考 |
| --- | --- | --- | --- |
| id | bigint | NOT NULL | PK |
| crawl_setting_id | bigint | NOT NULL | FK → `product_monitoring_crawl_settings.id` |
| platform | string | NOT NULL |  |
| external_id | string | NOT NULL |  |
| name | string | NOT NULL |  |
| product_url | text | NOT NULL |  |
| thumbnail_url | text |  |  |
| price | integer | NOT NULL | default `0` |
| buyout_price | integer |  |  |
| sold | boolean |  | NULL を許す |
| sold_at | datetime |  |  |
| ends_at | datetime |  |  |
| excluded_at | datetime |  | NULL を許す |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |
| recency_at | datetime |  | NULL を許す |
| seller_id | string |  | NULL を許す。照合順序 `utf8mb4_bin` |

### インデックス

| 名前 | カラム | 備考 |
| --- | --- | --- |
| idx_on_crawl_setting_id_external_id_a6fd3476b8 | crawl_setting_id, external_id | unique |
| index_product_monitoring_crawl_results_on_crawl_setting_id | crawl_setting_id |  |
| index_product_monitoring_crawl_results_on_created_at | created_at |  |
| index_product_monitoring_crawl_results_on_external_id | external_id |  |
| idx_on_platform_seller_id_014862945a | platform, seller_id |  |
| idx_product_monitoring_crawl_results_price_id_desc | price, id | 降順 |
| index_product_monitoring_crawl_results_on_price_and_id | price, id | id 降順 |
| index_product_monitoring_crawl_results_on_recency_at_and_id | recency_at, id | 降順 |
| index_product_monitoring_crawl_results_on_recency_at | recency_at |  |
| idx_monitoring_crawl_results_lowest_price | sold, excluded_at, price, id |  |

## product_monitoring_crawl_settings

### カラム

| カラム | 型 | NULL | 備考 |
| --- | --- | --- | --- |
| id | bigint | NOT NULL | PK |
| name | string | NOT NULL |  |
| enabled | boolean | NOT NULL | default `false` |
| search_keyword | string |  |  |
| platforms | json | NOT NULL | default `[]` |
| search_urls | json | NOT NULL | default `[]` |
| required_keywords | json | NOT NULL | default `[]` |
| negative_keywords | json | NOT NULL | default `[]` |
| min_price | integer |  |  |
| max_price | integer |  |  |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

なし

## product_monitoring_daily_market_prices

### カラム

| カラム | 型 | NULL | 備考 |
| --- | --- | --- | --- |
| id | bigint | NOT NULL | PK |
| date | date | NOT NULL |  |
| average_transaction_price | integer |  | NULL を許す |
| transaction_count | integer | NOT NULL | default `0` |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |
| monitor_id | bigint | NOT NULL | FK → `product_monitoring_monitors.id` |

### インデックス

| 名前 | カラム | 備考 |
| --- | --- | --- |
| idx_on_monitor_id_date_df939332ac | monitor_id, date | unique |
| index_product_monitoring_daily_market_prices_on_monitor_id | monitor_id |  |

## product_monitoring_excluded_sellers

### カラム

| カラム | 型 | NULL | 備考 |
| --- | --- | --- | --- |
| id | bigint | NOT NULL | PK |
| platform | string | NOT NULL |  |
| seller_id | string | NOT NULL | 照合順序 `utf8mb4_bin` |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
| --- | --- | --- |
| idx_on_platform_seller_id_cb8d72eaac | platform, seller_id | unique |

## product_monitoring_monitors

### カラム

| カラム | 型 | NULL | 備考 |
| --- | --- | --- | --- |
| id | bigint | NOT NULL | PK |
| name | string | NOT NULL |  |
| enabled | boolean | NOT NULL | default `false` |
| discord_enabled | boolean | NOT NULL | default `false` |
| required_keywords | json | NOT NULL | default `[]` |
| negative_keywords | json | NOT NULL | default `[]` |
| min_price | integer |  |  |
| max_price | integer |  |  |
| last_lowest_signature | string |  |  |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |
| newest_notification_enabled | boolean | NOT NULL | default `false` |
| newest_notified_until | datetime |  |  |

### インデックス

なし

## users

### カラム

| カラム | 型 | NULL | 備考 |
| --- | --- | --- | --- |
| id | bigint | NOT NULL | PK |
| name | text |  |  |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |
| email | string | NOT NULL | default `""` |
| provider_name | string | NOT NULL | default `""` |
| provider_uid | string | NOT NULL | default `""` |

### インデックス

| 名前 | カラム | 備考 |
| --- | --- | --- |
| index_users_on_email | email |  |
| index_users_on_provider_name_and_provider_uid | provider_name, provider_uid | unique |
