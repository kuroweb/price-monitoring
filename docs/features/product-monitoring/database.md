# 商品モニタリングの DB

商品モニタリングのテーブル間の関連を確認する開発者向けに、ER 図で示す。カラム・インデックス・外部キーは [テーブル定義](../../development/database/tables.md)、画面から見える規則は [外部仕様](external-spec.md)、保存の仕方は [内部仕様](internal-spec.md) を参照する。

## アソシエーション

```mermaid
erDiagram
  product_monitoring_crawl_settings {
    bigint id PK
  }
  product_monitoring_crawl_results {
    bigint id PK
    bigint crawl_setting_id FK
    string platform
    string external_id
    string seller_id
  }
  product_monitoring_excluded_sellers {
    bigint id PK
    string platform
    string seller_id
  }
  product_monitoring_monitors {
    bigint id PK
  }
  product_monitoring_daily_market_prices {
    bigint id PK
    bigint monitor_id FK
  }
  product_monitoring_crawl_settings ||--o{ product_monitoring_crawl_results : "1 対 0..多"
  product_monitoring_monitors ||--o{ product_monitoring_daily_market_prices : "1 対 0..多"
  product_monitoring_monitors }o..o{ product_monitoring_crawl_results : "外部キーのない条件抽出"
  product_monitoring_excluded_sellers }o..o{ product_monitoring_crawl_results : "外部キーのない platform と seller_id の照合"
```
