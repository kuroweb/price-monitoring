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

### Backend

- Rails

## Infra

### Development

- Docker Compose

### Production

- 自宅Kubernetes (Master Node x 1, Worker Node x 3構成)

## アーキテクチャ

```mermaid
flowchart LR
subgraph Kubernetest Node
  subgraph frontend [Frontend]
    direction LR

    Next.js
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

subgraph VPS
  proxy-1
end

client-->frontend--GraphQL-->bff
bff--REST API-->price
price--proxy-->VPS
```

## ER

### ヤフオク関連

```mermaid
erDiagram
  products {
    bigint id PK
    string name
  }
  yahoo_auction_crawl_settings {
    bigint id PK
    bigint product_id FK
    string keyword
    int category_id
    int min_price
    int max_price
    boolean enabled
  }
  yahoo_auction_crawl_setting_exclude_keywords {
    bigint id PK
    bigint yahoo_auction_crawl_setting_id FK
    string keyword
  }
  yahoo_auction_crawl_setting_required_keywords {
    bigint id PK
    bigint yahoo_auction_crawl_setting_id FK
    string keyword
  }
  yahoo_auction_products {
    bigint id PK
    string yahoo_auction_id
    string seller_id
    string name
    text thumbnail_url
    int price
    int buyout_price
    boolean published
    datetime bought_date
    datetime end_date
  }
  yahoo_fleamarket_products {
    bigint id PK
    string yahoo_fleamarket_id
    string seller_id
    string name
    text thumbnail_url
    int price
    boolean published
    datetime bought_date
  }
  yahoo_auction_daily_purchase_summaries {
    bigint id PK
    bigint product_id FK
    int average_purchase_price
    int purchase_count
    date date
  }
  yahoo_fleamarket_daily_purchase_summaries {
    bigint id PK
    bigint product_id FK
    int average_purchase_price
    int purchase_count
    date date
  }

  products ||--|| yahoo_auction_crawl_settings : "1:1"
  yahoo_auction_crawl_settings ||--o{ yahoo_auction_crawl_setting_exclude_keywords : "1:N"
  yahoo_auction_crawl_settings ||--o{ yahoo_auction_crawl_setting_required_keywords : "1:N"
  products ||--o{ yahoo_auction_products : "1:N"
  products ||--o{ yahoo_fleamarket_products : "1:N"
  products ||--o{ yahoo_auction_daily_purchase_summaries : "1:N"
  products ||--o{ yahoo_fleamarket_daily_purchase_summaries : "1:N"
```

### メルカリ関連

```mermaid
erDiagram
  products {
    bigint id PK
    string name
  }
  mercari_crawl_settings {
    bigint id PK
    bigint product_id FK
    string keyword
    int category_id
    int min_price
    int max_price
    boolean enabled
  }
  mercari_crawl_setting_exclude_keywords {
    bigint id PK
    bigint mercari_crawl_setting_id FK
    string keyword
  }
  mercari_crawl_setting_required_keywords {
    bigint id PK
    bigint mercari_crawl_setting_id FK
    string keyword
  }
  mercari_products {
    bigint id PK
    string mercari_id
    string seller_id
    string name
    text thumbnail_url
    int price
    boolean published
    datetime bought_date
  }
  mercari_daily_purchase_summaries {
    bigint id PK
    bigint product_id FK
    int average_purchase_price
    int purchase_count
    date date
  }

  products ||--|| mercari_crawl_settings : "1:1"
  mercari_crawl_settings ||--o{ mercari_crawl_setting_exclude_keywords : "1:N"
  mercari_crawl_settings ||--o{ mercari_crawl_setting_required_keywords : "1:N"
  products ||--o{ mercari_products : "1:N"
  products ||--o{ mercari_daily_purchase_summaries : "1:N"
```

### じゃんぱら

```mermaid
erDiagram
  products {
    bigint id PK
    string name
  }
  janpara_crawl_settings {
    bigint id PK
    bigint product_id FK
    string keyword
    int category_id
    int min_price
    int max_price
    boolean enabled
  }
  janpara_crawl_setting_exclude_keywords {
    bigint id PK
    bigint janpara_crawl_setting_id FK
    string keyword
  }
  janpara_crawl_setting_required_keywords {
    bigint id PK
    bigint janpara_crawl_setting_id FK
    string keyword
  }
  janpara_products {
    bigint id PK
    string external_id
    string name
    text thumbnail_url
    int price
    boolean published
    datetime bought_date
  }
  janpara_daily_purchase_summaries {
    bigint id PK
    bigint product_id FK
    int average_purchase_price
    int purchase_count
    date date
  }

  products ||--|| janpara_crawl_settings : "1:1"
  janpara_crawl_settings ||--o{ janpara_crawl_setting_exclude_keywords : "1:N"
  janpara_crawl_settings ||--o{ janpara_crawl_setting_required_keywords : "1:N"
  products ||--o{ janpara_products : "1:N"
  products ||--o{ janpara_daily_purchase_summaries : "1:N"
```

## 自動デプロイ

- ArgoCDによるGitOps
- [k8sマニフェスト](https://github.com/kuroweb/k8s)

```mermaid
sequenceDiagram
  participant repo_pm as Repository - price-monitoring
  participant repo_k8s as Repository - k8s
  participant deploy as GitHub Actions - Deployment
  participant vpn as 自宅サーバ - OpenVPN
  participant kp_registry as Kubernetes Pod - Docker Registry
  participant kp_argocd as Kubernetes Pod - ArgoCD
  participant kp_pm as Kubernetes Pod - price-monitoring

  repo_pm->>repo_pm : commit
  repo_pm->>deploy : execute
  activate deploy
  deploy->>deploy : docker build
  deploy->>vpn : connect vpn
  vpn-->>deploy :  
  deploy->>kp_registry : docker push
  kp_registry-->>deploy :  
  deploy->>repo_k8s : update manifest
  repo_k8s-->>deploy :  
  deploy-->>repo_pm :  
  deactivate deploy
  kp_argocd->>repo_k8s : Auto Sync
  activate kp_argocd
  repo_k8s-->>kp_argocd :  
  kp_argocd->>kp_pm : apply manifest
  kp_pm-->>kp_argocd :  
  deactivate kp_argocd
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
