# price-monitoring

[![Deployment](https://github.com/kuroweb/price-monitoring/actions/workflows/deployment.yml/badge.svg)](https://github.com/kuroweb/price-monitoring/actions/workflows/deployment.yml)

価格監視ツール

Web上にある欲しい物の価格監視を行うことができる

## 技術スタック

### Frontend

- Next.js
- TypeScript
- TailwindCSS

### BFF

- Go
- gqlgen

### Backend (Price Monitoring Domain)

- Rails

### 開発インフラ

- Docker Compose

### デプロイ

- 自宅Kubernetes (Master Node x 1, Worker Node x 2構成)
- ArgoCDで自動デプロイ

## アーキテクチャ

```mermaid
flowchart LR
subgraph Kubernetest Node
  subgraph frontend [Frontend]
    direction LR

    Nginx
    Next.js

    Nginx--proxy-->Next.js
  end

  subgraph bff [BFF]
    direction LR

    bff_go[Go]
  end

  subgraph price ["Backend (Price Monitoring Domain)"]
    direction LR

    price_rails[Rails]
    price_rails_batch[Sidekiq]
    price_rails_mysql[(MySQL)]

    price_rails-->price_rails_mysql
    price_rails_batch-->price_rails_mysql
  end
end

client-->frontend--GraphQL-->bff
bff--REST API-->price
```

## ER

### Price Monitoring

```mermaid
erDiagram
  products {
    bigint id PK
    bigint product_cateogory_id FK
    string name
  }
  product_categories {
    bigint id PK
    string name "NOT_NULL"
  }
  yahoo_auction_crawl_settings {
    bigint id PK
    bigint product_id FK
    boolean enabled "default: false"
  }
  mercari_crawl_settings {
    bigint id PK
    bigint product_id FK
    boolean enabled "default: false"
  }
  yahoo_auction_products {
    bigint id PK
    bigint yahoo_auction_id "NOT_NULL"
    string name "NOT_NULL"
    int price "NOT_NULL"
    boolean published "default: false"
  }
  mercari_products {
    bigint id PK
    bigint mercari_id "NOT_NULL"
    string name "NOT_NULL"
    int price "NOT_NULL"
    boolean published "default: false"
  }

  products ||--|| product_categories : "1:1"
  products ||--|| yahoo_auction_crawl_settings : "1:1"
  products ||--|| mercari_crawl_settings : "1:1"
  products ||--o{ yahoo_auction_products : "1:N"
  products ||--o{ mercari_products : "1:N"
```

## Docs

### seedファイル

すべてのSeedを投入する

```bash
rails db:seed -e {environment}
```

特定のSeedを投入する([rakeタスク拡張](/volumes/backend/lib/tasks/seed.rake))

```bash
rails db:seed:{seed_name} -e {environment}
```
