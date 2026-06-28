# ER

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

## categories

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| name | string |  |  |
| parent_id | integer |  |  |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| index_categories_on_name | name | unique |

## category_hierarchies

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| ancestor_id | integer | NOT NULL |  |
| descendant_id | integer | NOT NULL |  |
| generations | integer | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| category_anc_desc_idx | ancestor_id, descendant_id, generations | unique |
| category_desc_idx | descendant_id |  |

## iosys_crawl_setting_exclude_keywords

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| iosys_crawl_setting_id | bigint |  | FK |
| keyword | string | NOT NULL |  |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| idx_on_iosys_crawl_setting_id_keyword_2429715633 | iosys_crawl_setting_id, keyword | unique |
| idx_on_iosys_crawl_setting_id_889c2c2e88 | iosys_crawl_setting_id |  |

## iosys_crawl_setting_exclude_products

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| iosys_crawl_setting_id | bigint |  | FK |
| external_id | string | NOT NULL |  |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| idx_on_iosys_crawl_setting_id_external_id_b0528c956e | iosys_crawl_setting_id, external_id | unique |
| idx_on_iosys_crawl_setting_id_180f55a37c | iosys_crawl_setting_id |  |

## iosys_crawl_setting_required_keywords

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| iosys_crawl_setting_id | bigint |  | FK |
| keyword | string | NOT NULL |  |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| idx_on_iosys_crawl_setting_id_keyword_5beae71d90 | iosys_crawl_setting_id, keyword | unique |
| idx_on_iosys_crawl_setting_id_abd2c33544 | iosys_crawl_setting_id |  |

## iosys_crawl_settings

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| product_id | bigint |  | FK |
| keyword | string | NOT NULL |  |
| min_price | integer | NOT NULL | default: 0 |
| max_price | integer | NOT NULL | default: 0 |
| enabled | boolean | NOT NULL | default: false |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| index_iosys_crawl_settings_on_product_id | product_id |  |

## iosys_products

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| product_id | bigint |  | FK |
| external_id | string | NOT NULL |  |
| name | string | NOT NULL |  |
| thumbnail_url | text |  |  |
| price | integer | NOT NULL | default: 0 |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| index_iosys_products_on_external_id | external_id | unique |
| index_iosys_products_on_product_id_and_external_id | product_id, external_id | unique |
| index_iosys_products_on_product_id | product_id |  |

## janpara_crawl_setting_exclude_keywords

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| janpara_crawl_setting_id | bigint |  | FK |
| keyword | string | NOT NULL |  |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| idx_on_janpara_crawl_setting_id_keyword_7074a129f7 | janpara_crawl_setting_id, keyword | unique |
| idx_on_janpara_crawl_setting_id_e7210a8e11 | janpara_crawl_setting_id |  |

## janpara_crawl_setting_exclude_products

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| janpara_crawl_setting_id | bigint |  | FK |
| external_id | string | NOT NULL |  |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| idx_on_janpara_crawl_setting_id_external_id_102eeb7612 | janpara_crawl_setting_id, external_id | unique |
| idx_on_janpara_crawl_setting_id_3d622eaffd | janpara_crawl_setting_id |  |

## janpara_crawl_setting_required_keywords

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| janpara_crawl_setting_id | bigint |  | FK |
| keyword | string | NOT NULL |  |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| idx_on_janpara_crawl_setting_id_keyword_198f4d9655 | janpara_crawl_setting_id, keyword | unique |
| idx_on_janpara_crawl_setting_id_e721383245 | janpara_crawl_setting_id |  |

## janpara_crawl_settings

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| product_id | bigint |  | FK |
| keyword | string | NOT NULL |  |
| min_price | integer | NOT NULL | default: 0 |
| max_price | integer | NOT NULL | default: 0 |
| enabled | boolean | NOT NULL | default: false |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| index_janpara_crawl_settings_on_product_id | product_id |  |

## janpara_products

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| product_id | bigint |  | FK |
| external_id | string | NOT NULL |  |
| name | string | NOT NULL |  |
| thumbnail_url | text |  |  |
| price | integer | NOT NULL | default: 0 |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| index_janpara_products_on_external_id | external_id | unique |
| index_janpara_products_on_product_id_and_external_id | product_id, external_id | unique |
| index_janpara_products_on_product_id | product_id |  |

## mercari_crawl_setting_exclude_keywords

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| mercari_crawl_setting_id | bigint |  | FK |
| keyword | string | NOT NULL |  |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| idx_on_mercari_crawl_setting_id_keyword_4e4cc0381b | mercari_crawl_setting_id, keyword | unique |
| idx_on_mercari_crawl_setting_id_f56a952474 | mercari_crawl_setting_id |  |

## mercari_crawl_setting_exclude_products

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| mercari_crawl_setting_id | bigint |  | FK |
| external_id | string | NOT NULL |  |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| idx_on_mercari_crawl_setting_id_external_id_34002464be | mercari_crawl_setting_id, external_id | unique |
| idx_on_mercari_crawl_setting_id_22de934ea6 | mercari_crawl_setting_id |  |

## mercari_crawl_setting_required_keywords

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| mercari_crawl_setting_id | bigint |  | FK |
| keyword | string | NOT NULL |  |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| idx_on_mercari_crawl_setting_id_keyword_cc21910aea | mercari_crawl_setting_id, keyword | unique |
| idx_on_mercari_crawl_setting_id_4659f97e15 | mercari_crawl_setting_id |  |

## mercari_crawl_settings

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| product_id | bigint |  | FK |
| keyword | string | NOT NULL |  |
| category_id | integer |  |  |
| min_price | integer | NOT NULL | default: 0 |
| max_price | integer | NOT NULL | default: 0 |
| enabled | boolean | NOT NULL | default: false |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| index_mercari_crawl_settings_on_product_id | product_id |  |

## mercari_daily_purchase_summaries

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| product_id | bigint |  | FK |
| average_purchase_price | integer |  |  |
| purchase_count | integer |  | default: 0 |
| date | date | NOT NULL |  |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| index_mercari_daily_purchase_summaries_on_product_id_and_date | product_id, date | unique |
| index_mercari_daily_purchase_summaries_on_product_id | product_id |  |

## mercari_products

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| product_id | bigint |  | FK |
| external_id | string | NOT NULL |  |
| name | string | NOT NULL |  |
| thumbnail_url | text |  |  |
| price | integer | NOT NULL | default: 0 |
| published | boolean | NOT NULL | default: false |
| bought_date | datetime |  |  |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| index_mercari_products_on_product_id_and_external_id | product_id, external_id | unique |
| index_mercari_products_on_product_id | product_id |  |

## pc_koubou_crawl_setting_exclude_keywords

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| pc_koubou_crawl_setting_id | bigint |  | FK |
| keyword | string | NOT NULL |  |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| idx_on_pc_koubou_crawl_setting_id_keyword_8c3917f08a | pc_koubou_crawl_setting_id, keyword | unique |
| idx_on_pc_koubou_crawl_setting_id_f8f5317000 | pc_koubou_crawl_setting_id |  |

## pc_koubou_crawl_setting_exclude_products

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| pc_koubou_crawl_setting_id | bigint |  | FK |
| external_id | string | NOT NULL |  |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| idx_on_pc_koubou_crawl_setting_id_external_id_96823e00f8 | pc_koubou_crawl_setting_id, external_id | unique |
| idx_on_pc_koubou_crawl_setting_id_8b1b1a24af | pc_koubou_crawl_setting_id |  |

## pc_koubou_crawl_setting_required_keywords

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| pc_koubou_crawl_setting_id | bigint |  | FK |
| keyword | string | NOT NULL |  |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| idx_on_pc_koubou_crawl_setting_id_keyword_8e3b9acc35 | pc_koubou_crawl_setting_id, keyword | unique |
| idx_on_pc_koubou_crawl_setting_id_d2ecc2a271 | pc_koubou_crawl_setting_id |  |

## pc_koubou_crawl_settings

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| product_id | bigint |  | FK |
| keyword | string | NOT NULL |  |
| min_price | integer | NOT NULL | default: 0 |
| max_price | integer | NOT NULL | default: 0 |
| enabled | boolean | NOT NULL | default: false |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| index_pc_koubou_crawl_settings_on_product_id | product_id |  |

## pc_koubou_products

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| product_id | bigint |  | FK |
| external_id | string | NOT NULL |  |
| name | string | NOT NULL |  |
| thumbnail_url | text |  |  |
| price | integer | NOT NULL | default: 0 |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| index_pc_koubou_products_on_external_id | external_id | unique |
| index_pc_koubou_products_on_product_id_and_external_id | product_id, external_id | unique |
| index_pc_koubou_products_on_product_id | product_id |  |

## product_category_maps

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| product_id | bigint | NOT NULL | FK |
| category_id | bigint | NOT NULL | FK |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| index_product_category_maps_on_category_id | category_id |  |
| index_product_category_maps_on_product_id_and_category_id | product_id, category_id | unique |
| index_product_category_maps_on_product_id | product_id |  |

## products

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| name | string |  |  |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

なし

## used_sofmap_crawl_setting_exclude_keywords

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| used_sofmap_crawl_setting_id | bigint |  | FK |
| keyword | string | NOT NULL |  |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| idx_on_used_sofmap_crawl_setting_id_keyword_7475198f68 | used_sofmap_crawl_setting_id, keyword | unique |
| idx_on_used_sofmap_crawl_setting_id_7f42917bfe | used_sofmap_crawl_setting_id |  |

## used_sofmap_crawl_setting_exclude_products

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| used_sofmap_crawl_setting_id | bigint |  | FK |
| external_id | string | NOT NULL |  |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| idx_on_used_sofmap_crawl_setting_id_external_id_d8c3f14b71 | used_sofmap_crawl_setting_id, external_id | unique |
| idx_on_used_sofmap_crawl_setting_id_516fe376cb | used_sofmap_crawl_setting_id |  |

## used_sofmap_crawl_setting_required_keywords

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| used_sofmap_crawl_setting_id | bigint |  | FK |
| keyword | string | NOT NULL |  |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| idx_on_used_sofmap_crawl_setting_id_keyword_7296d7cbc9 | used_sofmap_crawl_setting_id, keyword | unique |
| idx_on_used_sofmap_crawl_setting_id_57a4411deb | used_sofmap_crawl_setting_id |  |

## used_sofmap_crawl_settings

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| product_id | bigint |  | FK |
| keyword | string | NOT NULL |  |
| min_price | integer | NOT NULL | default: 0 |
| max_price | integer | NOT NULL | default: 0 |
| enabled | boolean | NOT NULL | default: false |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| index_used_sofmap_crawl_settings_on_product_id | product_id |  |

## used_sofmap_products

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| product_id | bigint |  | FK |
| external_id | string | NOT NULL |  |
| name | string | NOT NULL |  |
| thumbnail_url | text |  |  |
| price | integer | NOT NULL | default: 0 |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| index_used_sofmap_products_on_external_id | external_id | unique |
| index_used_sofmap_products_on_product_id_and_external_id | product_id, external_id | unique |
| index_used_sofmap_products_on_product_id | product_id |  |

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

## yahoo_auction_crawl_setting_exclude_keywords

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| yahoo_auction_crawl_setting_id | bigint |  | FK |
| keyword | string |  |  |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| idx_on_yahoo_auction_crawl_setting_id_keyword_9341e10548 | yahoo_auction_crawl_setting_id, keyword | unique |
| idx_on_yahoo_auction_crawl_setting_id_fb93459e66 | yahoo_auction_crawl_setting_id |  |

## yahoo_auction_crawl_setting_exclude_products

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| yahoo_auction_crawl_setting_id | bigint |  | FK |
| external_id | string | NOT NULL |  |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| idx_on_yahoo_auction_crawl_setting_id_external_id_c904750663 | yahoo_auction_crawl_setting_id, external_id | unique |
| idx_on_yahoo_auction_crawl_setting_id_b30a20343c | yahoo_auction_crawl_setting_id |  |

## yahoo_auction_crawl_setting_required_keywords

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| yahoo_auction_crawl_setting_id | bigint |  | FK |
| keyword | string | NOT NULL |  |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| idx_on_yahoo_auction_crawl_setting_id_keyword_daee6cea4b | yahoo_auction_crawl_setting_id, keyword | unique |
| idx_on_yahoo_auction_crawl_setting_id_49589afeb2 | yahoo_auction_crawl_setting_id |  |

## yahoo_auction_crawl_settings

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| product_id | bigint |  | FK |
| category_id | integer |  | default: 0 |
| min_price | integer | NOT NULL | default: 0 |
| max_price | integer | NOT NULL | default: 0 |
| enabled | boolean | NOT NULL | default: false |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |
| keyword | string | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| index_yahoo_auction_crawl_settings_on_product_id | product_id |  |

## yahoo_auction_daily_purchase_summaries

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| product_id | bigint |  | FK |
| average_purchase_price | integer |  |  |
| purchase_count | integer |  | default: 0 |
| date | date | NOT NULL |  |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| idx_on_product_id_date_d63712c38b | product_id, date | unique |
| index_yahoo_auction_daily_purchase_summaries_on_product_id | product_id |  |

## yahoo_auction_products

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| product_id | bigint |  | FK |
| external_id | string | NOT NULL |  |
| seller_id | string | NOT NULL |  |
| name | string | NOT NULL |  |
| thumbnail_url | text |  |  |
| price | integer | NOT NULL | default: 0 |
| buyout_price | integer |  |  |
| published | boolean | NOT NULL | default: false |
| bought_date | datetime |  |  |
| end_date | datetime |  |  |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| index_yahoo_auction_products_on_product_id_and_external_id | product_id, external_id | unique |
| index_yahoo_auction_products_on_product_id | product_id |  |

## yahoo_fleamarket_daily_purchase_summaries

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| product_id | bigint |  | FK |
| average_purchase_price | integer |  |  |
| purchase_count | integer |  | default: 0 |
| date | date | NOT NULL |  |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| idx_on_product_id_date_bd09f0e249 | product_id, date | unique |
| index_yahoo_fleamarket_daily_purchase_summaries_on_product_id | product_id |  |

## yahoo_fleamarket_products

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| product_id | bigint |  | FK |
| external_id | string | NOT NULL |  |
| seller_id | string | NOT NULL |  |
| name | string | NOT NULL |  |
| thumbnail_url | text |  |  |
| price | integer | NOT NULL | default: 0 |
| published | boolean | NOT NULL | default: false |
| bought_date | datetime |  |  |
| created_at | datetime | NOT NULL |  |
| updated_at | datetime | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| index_yahoo_fleamarket_products_on_product_id_and_external_id | product_id, external_id | unique |
| index_yahoo_fleamarket_products_on_product_id | product_id |  |
