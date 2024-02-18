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

- 自宅Kubernetes (Master Node x 1, Worker Node x 2構成)

## アーキテクチャ

```mermaid
flowchart LR
subgraph Kubernetest Node
  subgraph frontend [Frontend]
    direction LR

    Nginx["Nginx(未実装)"]
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

```mermaid
erDiagram
  products {
    bigint id PK
    string name
  }
  yahoo_auction_crawl_settings {
    bigint id PK
    bigint product_id FK
    string keyword "NOT_NULL"
    int category_id "default: null"
    int min_price "default: 0"
    int max_price "default: 0"
    boolean enabled "default: false"
  }
  yahoo_auction_crawl_setting_exclude_conditions {
    bigint id PK
    bigint yahoo_auction_crawl_setting_id FK
    string yahoo_auction_id
    string keyword
    string seller_id
  }
  yahoo_auction_products {
    bigint id PK
    string yahoo_auction_id "NOT_NULL"
    string name "NOT_NULL"
    int price "NOT_NULL"
    boolean published "default: false"
    datetime bought_date
  }
  calculate_daily_yahoo_auction_products {
    bigint id PK
    bigint product_id FK
    int price "default: null"
    date target_date "NOT_NULL"
  }

  products ||--|| yahoo_auction_crawl_settings : "1:1"
  yahoo_auction_crawl_settings ||--o{ yahoo_auction_crawl_setting_exclude_conditions : "1:N"
  products ||--o{ yahoo_auction_products : "1:N"
  products ||--o{ calculate_daily_yahoo_auction_products : "1:N"
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
