# アソシエーション

機能文書がまだ無い領域について、BFF / batch のテーブル間関連を確認する開発者向けのリファレンス。Provider の DB は対象外。機能文書がある領域のテーブル間関連は、その機能の DB 文書を正本とする。
領域の分け方は [Database](index.md)、カラム・インデックスは [ER](er.md)、商品モニタリングのテーブル定義は [商品モニタリングの DB](../features/product-monitoring/database.md)、現在の定義は [schema.rb](../../volumes/backend/db/schema.rb) を参照する。

## 計測対象管理

### カテゴリ

```mermaid
erDiagram
  products {
    bigint id PK
  }
  categories {
    bigint id PK
  }
  category_hierarchies {
    integer ancestor_id FK
    integer descendant_id FK
    integer generations PK
  }
  product_category_maps {
    bigint id PK
    bigint product_id FK
    bigint category_id FK
  }
  products ||--o{ product_category_maps : ""
  categories ||--o{ product_category_maps : ""
  categories ||--o{ category_hierarchies : "ancestor"
  categories ||--o{ category_hierarchies : "descendant"
```

## クロール処理

### ヤフオク

```mermaid
erDiagram
  products {
    bigint id PK
  }
  yahoo_auction_crawl_settings {
    bigint id PK
    bigint product_id FK
  }
  yahoo_auction_crawl_setting_required_keywords {
    bigint id PK
    bigint yahoo_auction_crawl_setting_id FK
  }
  yahoo_auction_crawl_setting_exclude_keywords {
    bigint id PK
    bigint yahoo_auction_crawl_setting_id FK
  }
  yahoo_auction_crawl_setting_exclude_products {
    bigint id PK
    bigint yahoo_auction_crawl_setting_id FK
  }
  yahoo_auction_products {
    bigint id PK
    bigint product_id FK
  }
  products ||--o{ yahoo_auction_crawl_settings : ""
  yahoo_auction_crawl_settings ||--o{ yahoo_auction_crawl_setting_required_keywords : ""
  yahoo_auction_crawl_settings ||--o{ yahoo_auction_crawl_setting_exclude_keywords : ""
  yahoo_auction_crawl_settings ||--o{ yahoo_auction_crawl_setting_exclude_products : ""
  products ||--o{ yahoo_auction_products : ""
```

### ヤフーフリマ

```mermaid
erDiagram
  products {
    bigint id PK
  }
  yahoo_fleamarket_products {
    bigint id PK
    bigint product_id FK
  }
  products ||--o{ yahoo_fleamarket_products : ""
```

## 日次相場の集計

```mermaid
erDiagram
  products {
    bigint id PK
  }
  yahoo_auction_daily_purchase_summaries {
    bigint id PK
    bigint product_id FK
  }
  yahoo_fleamarket_daily_purchase_summaries {
    bigint id PK
    bigint product_id FK
  }
  products ||--o{ yahoo_auction_daily_purchase_summaries : ""
  products ||--o{ yahoo_fleamarket_daily_purchase_summaries : ""
```

## Backmarket監視

```mermaid
erDiagram
  backmarket_watch_targets {
    bigint id PK
  }
  backmarket_watch_results {
    bigint id PK
    bigint backmarket_watch_target_id FK
  }
  backmarket_watch_targets ||--o{ backmarket_watch_results : ""
```
