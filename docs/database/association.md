# アソシエーション

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

### メルカリ

```mermaid
erDiagram
  products {
    bigint id PK
  }
  mercari_crawl_settings {
    bigint id PK
    bigint product_id FK
  }
  mercari_crawl_setting_required_keywords {
    bigint id PK
    bigint mercari_crawl_setting_id FK
  }
  mercari_crawl_setting_exclude_keywords {
    bigint id PK
    bigint mercari_crawl_setting_id FK
  }
  mercari_crawl_setting_exclude_products {
    bigint id PK
    bigint mercari_crawl_setting_id FK
  }
  mercari_products {
    bigint id PK
    bigint product_id FK
  }
  products ||--o{ mercari_crawl_settings : ""
  mercari_crawl_settings ||--o{ mercari_crawl_setting_required_keywords : ""
  mercari_crawl_settings ||--o{ mercari_crawl_setting_exclude_keywords : ""
  mercari_crawl_settings ||--o{ mercari_crawl_setting_exclude_products : ""
  products ||--o{ mercari_products : ""
```

### じゃんぱら

```mermaid
erDiagram
  products {
    bigint id PK
  }
  janpara_crawl_settings {
    bigint id PK
    bigint product_id FK
  }
  janpara_crawl_setting_required_keywords {
    bigint id PK
    bigint janpara_crawl_setting_id FK
  }
  janpara_crawl_setting_exclude_keywords {
    bigint id PK
    bigint janpara_crawl_setting_id FK
  }
  janpara_crawl_setting_exclude_products {
    bigint id PK
    bigint janpara_crawl_setting_id FK
  }
  janpara_products {
    bigint id PK
    bigint product_id FK
  }
  products ||--o{ janpara_crawl_settings : ""
  janpara_crawl_settings ||--o{ janpara_crawl_setting_required_keywords : ""
  janpara_crawl_settings ||--o{ janpara_crawl_setting_exclude_keywords : ""
  janpara_crawl_settings ||--o{ janpara_crawl_setting_exclude_products : ""
  products ||--o{ janpara_products : ""
```

### イオシス

```mermaid
erDiagram
  products {
    bigint id PK
  }
  iosys_crawl_settings {
    bigint id PK
    bigint product_id FK
  }
  iosys_crawl_setting_required_keywords {
    bigint id PK
    bigint iosys_crawl_setting_id FK
  }
  iosys_crawl_setting_exclude_keywords {
    bigint id PK
    bigint iosys_crawl_setting_id FK
  }
  iosys_crawl_setting_exclude_products {
    bigint id PK
    bigint iosys_crawl_setting_id FK
  }
  iosys_products {
    bigint id PK
    bigint product_id FK
  }
  products ||--o{ iosys_crawl_settings : ""
  iosys_crawl_settings ||--o{ iosys_crawl_setting_required_keywords : ""
  iosys_crawl_settings ||--o{ iosys_crawl_setting_exclude_keywords : ""
  iosys_crawl_settings ||--o{ iosys_crawl_setting_exclude_products : ""
  products ||--o{ iosys_products : ""
```

### パソコン工房

```mermaid
erDiagram
  products {
    bigint id PK
  }
  pc_koubou_crawl_settings {
    bigint id PK
    bigint product_id FK
  }
  pc_koubou_crawl_setting_required_keywords {
    bigint id PK
    bigint pc_koubou_crawl_setting_id FK
  }
  pc_koubou_crawl_setting_exclude_keywords {
    bigint id PK
    bigint pc_koubou_crawl_setting_id FK
  }
  pc_koubou_crawl_setting_exclude_products {
    bigint id PK
    bigint pc_koubou_crawl_setting_id FK
  }
  pc_koubou_products {
    bigint id PK
    bigint product_id FK
  }
  products ||--o{ pc_koubou_crawl_settings : ""
  pc_koubou_crawl_settings ||--o{ pc_koubou_crawl_setting_required_keywords : ""
  pc_koubou_crawl_settings ||--o{ pc_koubou_crawl_setting_exclude_keywords : ""
  pc_koubou_crawl_settings ||--o{ pc_koubou_crawl_setting_exclude_products : ""
  products ||--o{ pc_koubou_products : ""
```

### リコレ

```mermaid
erDiagram
  products {
    bigint id PK
  }
  used_sofmap_crawl_settings {
    bigint id PK
    bigint product_id FK
  }
  used_sofmap_crawl_setting_required_keywords {
    bigint id PK
    bigint used_sofmap_crawl_setting_id FK
  }
  used_sofmap_crawl_setting_exclude_keywords {
    bigint id PK
    bigint used_sofmap_crawl_setting_id FK
  }
  used_sofmap_crawl_setting_exclude_products {
    bigint id PK
    bigint used_sofmap_crawl_setting_id FK
  }
  used_sofmap_products {
    bigint id PK
    bigint product_id FK
  }
  products ||--o{ used_sofmap_crawl_settings : ""
  used_sofmap_crawl_settings ||--o{ used_sofmap_crawl_setting_required_keywords : ""
  used_sofmap_crawl_settings ||--o{ used_sofmap_crawl_setting_exclude_keywords : ""
  used_sofmap_crawl_settings ||--o{ used_sofmap_crawl_setting_exclude_products : ""
  products ||--o{ used_sofmap_products : ""
```

## 相場集計

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
  mercari_daily_purchase_summaries {
    bigint id PK
    bigint product_id FK
  }
  products ||--o{ yahoo_auction_daily_purchase_summaries : ""
  products ||--o{ yahoo_fleamarket_daily_purchase_summaries : ""
  products ||--o{ mercari_daily_purchase_summaries : ""
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
