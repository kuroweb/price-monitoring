# price-monitoring

[![CI/CD](https://github.com/kuroweb/price-monitoring/actions/workflows/cicd.yml/badge.svg)](https://github.com/kuroweb/price-monitoring/actions/workflows/cicd.yml)

- Web上にある商品の最安値を探したり、相場を把握するためのツール
- Rails, TypeScriptのキャッチアップが主な開発目的
- DatadogやBugSnagを導入して運用監視についてのキャッチアップも兼ねている

## 技術スタック

### Frontend

- Next.js
- TypeScript
- TailwindCSS

### Backend

- Rails
- OpenID Connect（実装中）

### 運用監視

- Datadog
- BugSnag

## インフラ構成

### Development

- Docker Compose

  ```mermaid
  flowchart LR
  subgraph Docker Compose
    subgraph proxy
      nginx_web[Nginx Web]
      nginx_auth[Nginx Auth]
    end

    subgraph Frontend
      direction LR

      Next.js
    end

    subgraph Backend API
      direction LR

      rails[Rails API]
    end

    subgraph Backend Batch
      direction LR

      sidekiq[Sidekiq]
      playwright[Playwright]
    end

    subgraph OpenID Provider
      rails_auth[Rails Web]
    end

    subgraph Databases
      mysql[(MySQL)]
      redis[(Redis)]
    end
  end

  subgraph VPS
    proxy-1
  end

  client-->nginx_web-->Next.js
  client-->nginx_auth-->rails_auth
  nginx_web--WebAPI-->rails
  sidekiq-->playwright-->VPS
  rails-->Databases
  rails_auth-->Databases
  sidekiq-->Databases
  ```

### Production

- 自宅Kubernetes (Master Node x 1, Worker Node x 3構成)

  ```mermaid
  flowchart LR
  subgraph Kubernetest Node
    subgraph Ingress Controller
      nginx_web[Nginx Web]
      nginx_auth[Nginx Auth]
    end

    subgraph Frontend
      direction LR

      Next.js
    end

    subgraph Backend API
      direction LR

      rails[Rails API]
    end

    subgraph Backend Batch
      direction LR

      sidekiq[Sidekiq]
      playwright[Playwright]
    end

    subgraph OpenID Provider
      rails_auth[Rails Web]
    end

    subgraph Databases
      mysql[(MySQL)]
      redis[(Redis)]
    end
  end

  subgraph VPS
    proxy-1
  end

  client-->nginx_web-->Next.js
  client-->nginx_auth-->rails_auth
  nginx_web--WebAPI-->rails
  sidekiq-->playwright-->VPS
  rails-->Databases
  rails_auth-->Databases
  sidekiq-->Databases
  ```

## セットアップ手順

- OpenID Provider(auth_providerコンテナ)の秘密鍵を作成

  - opensslをインストール（環境差異の大きなライブラリなので参考程度）

    ```bash
    $ brew install openssl
    ```

  - 秘密鍵を作成

    ```bash
    $ openssl genrsa -out volumes/auth_provider/certs/private.pem 2048
    ```

- nginx用の証明書発行
  - mkcertをインストール

    ```bash
    $ brew install mkcert
    $ mkcert -install
    ```

  - 証明書発行

    ```bash
    $ mkcert \
      -cert-file ./volumes/nginx/certs/web/fullchain.pem \
      -key-file ./volumes/nginx/certs/web/privkey.pem \
      dev.price-monitoring.com
    ```

    ```bash
    $ mkcert \
      -cert-file ./volumes/nginx/certs/auth/fullchain.pem \
      -key-file ./volumes/nginx/certs/auth/privkey.pem \
      dev.auth.price-monitoring.com
    ```

  - /etc/hosts に以下を記述

    ```bash
    127.0.0.1 dev.price-monitoring.com
    127.0.0.1 dev.auth.price-monitoring.com
    ```

- Dockerイメージビルド

  ```bash
  $ docker compose build
  ```

- コンテナ起動

  ```bash
  $ just up
  ```

- コンテナ停止

  ```bash
  $ just down
  ```

- ローカル環境
  - https://dev.price-monitoring.com/

## ER

### 計測対象管理

#### カテゴリ

```mermaid
erDiagram
  products {
    bigint id PK
    string name
  }
  product_category_map {
    bigint id PK
    bigint product_id FK
    bigint category_id FK
  }
  categories {
    bigint id PK
    string name
    int parent_id "closure_tree gemでの探索コスト削減カラム"
  }
  category_hierarchies {
    bigint id PK
    bigint ancestor_id FK "親カテゴリID (category_id)"
    bigint descendant_id FK "子カテゴリID (category_id)"
    int generations "親子関係のパスの深さ"
  }

  products ||--|| product_category_map : ""
  product_category_map }o--|| categories : ""
  categories ||--o{ category_hierarchies : "親カテゴリ"
  categories ||--o{ category_hierarchies : "子カテゴリ"
```

### クロール処理

#### ヤフオク

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
  yahoo_auction_crawl_setting_required_keywords {
    bigint id PK
    bigint yahoo_auction_crawl_setting_id FK
    string keyword
  }
  yahoo_auction_crawl_setting_exclude_keywords {
    bigint id PK
    bigint yahoo_auction_crawl_setting_id FK
    string keyword
  }
  yahoo_auction_crawl_setting_exclude_products {
    bigint id PK
    bigint yahoo_auction_crawl_setting_id FK
    string external_id
  }
  yahoo_auction_products {
    bigint id PK
    string external_id
    string seller_id
    string name
    text thumbnail_url
    int price
    int buyout_price
    boolean published
    datetime bought_date
    datetime end_date
  }

  products ||--|| yahoo_auction_crawl_settings : "1:1"
  yahoo_auction_crawl_settings ||--o{ yahoo_auction_crawl_setting_required_keywords : "1:N"
  yahoo_auction_crawl_settings ||--o{ yahoo_auction_crawl_setting_exclude_keywords : "1:N"
  yahoo_auction_crawl_settings ||--o{ yahoo_auction_crawl_setting_exclude_products : "1:N"
  products ||--o{ yahoo_auction_products : "1:N"
```

#### ヤフーフリマ

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
  yahoo_auction_crawl_setting_required_keywords {
    bigint id PK
    bigint yahoo_auction_crawl_setting_id FK
    string keyword
  }
  yahoo_auction_crawl_setting_exclude_keywords {
    bigint id PK
    bigint yahoo_auction_crawl_setting_id FK
    string keyword
  }
  yahoo_auction_crawl_setting_exclude_products {
    bigint id PK
    bigint yahoo_auction_crawl_setting_id FK
    string external_id
  }
  yahoo_fleamarket_products {
    bigint id PK
    string external_id
    string seller_id
    string name
    text thumbnail_url
    int price
    boolean published
    datetime bought_date
  }

  products ||--|| yahoo_auction_crawl_settings : "1:1"
  yahoo_auction_crawl_settings ||--o{ yahoo_auction_crawl_setting_required_keywords : "1:N"
  yahoo_auction_crawl_settings ||--o{ yahoo_auction_crawl_setting_exclude_keywords : "1:N"
  yahoo_auction_crawl_settings ||--o{ yahoo_auction_crawl_setting_exclude_products : "1:N"
  products ||--o{ yahoo_fleamarket_products : "1:N"

```

#### メルカリ

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
  mercari_crawl_setting_required_keywords {
    bigint id PK
    bigint mercari_crawl_setting_id FK
    string keyword
  }
  mercari_crawl_setting_exclude_keywords {
    bigint id PK
    bigint mercari_crawl_setting_id FK
    string keyword
  }
  mercari_crawl_setting_exclude_products {
    bigint id PK
    bigint mercari_crawl_setting_id FK
    string external_id
  }
  mercari_products {
    bigint id PK
    string external_id
    string seller_id
    string name
    text thumbnail_url
    int price
    boolean published
    datetime bought_date
  }

  products ||--|| mercari_crawl_settings : "1:1"
  mercari_crawl_settings ||--o{ mercari_crawl_setting_required_keywords : "1:N"
  mercari_crawl_settings ||--o{ mercari_crawl_setting_exclude_keywords : "1:N"
  mercari_crawl_settings ||--o{ mercari_crawl_setting_exclude_products : "1:N"
  products ||--o{ mercari_products : "1:N"
```

#### じゃんぱら

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
    int min_price
    int max_price
    boolean enabled
  }
  janpara_crawl_setting_required_keywords {
    bigint id PK
    bigint janpara_crawl_setting_id FK
    string keyword
  }
  janpara_crawl_setting_exclude_keywords {
    bigint id PK
    bigint janpara_crawl_setting_id FK
    string keyword
  }
  janpara_crawl_setting_exclude_products {
    bigint id PK
    bigint janpara_crawl_setting_id FK
    string external_id
  }
  janpara_products {
    bigint id PK
    string external_id
    string name
    text thumbnail_url
    int price
  }

  products ||--|| janpara_crawl_settings : "1:1"
  janpara_crawl_settings ||--o{ janpara_crawl_setting_required_keywords : "1:N"
  janpara_crawl_settings ||--o{ janpara_crawl_setting_exclude_keywords : "1:N"
  janpara_crawl_settings ||--o{ janpara_crawl_setting_exclude_products : "1:N"
  products ||--o{ janpara_products : "1:N"
```

#### イオシス

```mermaid
erDiagram
  products {
    bigint id PK
    string name
  }
  iosys_crawl_settings {
    bigint id PK
    bigint product_id FK
    string keyword
    int min_price
    int max_price
    boolean enabled
  }
  iosys_crawl_setting_required_keywords {
    bigint id PK
    bigint iosys_crawl_setting_id FK
    string keyword
  }
  iosys_crawl_setting_exclude_keywords {
    bigint id PK
    bigint iosys_crawl_setting_id FK
    string keyword
  }
  iosys_crawl_setting_exclude_products {
    bigint id PK
    bigint iosys_crawl_setting_id FK
    string external_id
  }
  iosys_products {
    bigint id PK
    string external_id
    string name
    text thumbnail_url
    int price
  }

  products ||--|| iosys_crawl_settings : "1:1"
  iosys_crawl_settings ||--o{ iosys_crawl_setting_required_keywords : "1:N"
  iosys_crawl_settings ||--o{ iosys_crawl_setting_exclude_keywords : "1:N"
  iosys_crawl_settings ||--o{ iosys_crawl_setting_exclude_products : "1:N"
  products ||--o{ iosys_products : "1:N"
```

#### パソコン工房

```mermaid
erDiagram
  products {
    bigint id PK
    string name
  }
  pc_koubou_crawl_settings {
    bigint id PK
    bigint product_id FK
    string keyword
    int min_price
    int max_price
    boolean enabled
  }
  pc_koubou_crawl_setting_required_keywords {
    bigint id PK
    bigint pc_koubou_crawl_setting_id FK
    string keyword
  }
  pc_koubou_crawl_setting_exclude_keywords {
    bigint id PK
    bigint pc_koubou_crawl_setting_id FK
    string keyword
  }
  pc_koubou_crawl_setting_exclude_products {
    bigint id PK
    bigint pc_koubou_crawl_setting_id FK
    string external_id
  }
  pc_koubou_products {
    bigint id PK
    string external_id
    string name
    text thumbnail_url
    int price
  }

  products ||--|| pc_koubou_crawl_settings : "1:1"
  pc_koubou_crawl_settings ||--o{ pc_koubou_crawl_setting_required_keywords : "1:N"
  pc_koubou_crawl_settings ||--o{ pc_koubou_crawl_setting_exclude_keywords : "1:N"
  pc_koubou_crawl_settings ||--o{ pc_koubou_crawl_setting_exclude_products : "1:N"
  products ||--o{ pc_koubou_products : "1:N"
```

#### リコレ

```mermaid
erDiagram
  products {
    bigint id PK
    string name
  }
  used_sofmap_crawl_settings {
    bigint id PK
    bigint product_id FK
    string keyword
    int min_price
    int max_price
    boolean enabled
  }
  used_sofmap_crawl_setting_required_keywords {
    bigint id PK
    bigint used_sofmap_crawl_setting_id FK
    string keyword
  }
  used_sofmap_crawl_setting_exclude_keywords {
    bigint id PK
    bigint used_sofmap_crawl_setting_id FK
    string keyword
  }
  used_sofmap_crawl_setting_exclude_products {
    bigint id PK
    bigint used_sofmap_crawl_setting_id FK
    string external_id
  }
  used_sofmap_products {
    bigint id PK
    string external_id
    string name
    text thumbnail_url
    int price
  }

  products ||--|| used_sofmap_crawl_settings : "1:1"
  used_sofmap_crawl_settings ||--o{ used_sofmap_crawl_setting_required_keywords : "1:N"
  used_sofmap_crawl_settings ||--o{ used_sofmap_crawl_setting_exclude_keywords : "1:N"
  used_sofmap_crawl_settings ||--o{ used_sofmap_crawl_setting_exclude_products : "1:N"
  products ||--o{ used_sofmap_products : "1:N"
```

### 相場集計

```mermaid
erDiagram
  products {
    bigint id PK
    string name
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
  mercari_daily_purchase_summaries {
    bigint id PK
    bigint product_id FK
    int average_purchase_price
    int purchase_count
    date date
  }

  products ||--o{ yahoo_auction_daily_purchase_summaries : "1:N"
  products ||--o{ yahoo_fleamarket_daily_purchase_summaries : "1:N"
  products ||--o{ mercari_daily_purchase_summaries : "1:N"
```

## 自動デプロイ

- ArgoCDによるGitOps
- [k8sマニフェスト](https://github.com/kuroweb/k8s)

```mermaid
sequenceDiagram
  participant repo_pm as Repository - price-monitoring
  participant repo_k8s as Repository - k8s
  participant deploy as GitHub Actions - CI/CD
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
