# price-monitoring

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
    price_rails_mysql[(MySQL)]

    price_rails-->price_rails_mysql
  end

  subgraph hoge ["Backend (Hoge Domain)"]
    direction LR

    hoge_go[Go]
    hoge_go_mysql[(MySQL)]

    hoge_go-->hoge_go_mysql
  end
end

client-->frontend--GraphQL-->bff
bff--REST API-->price
bff--gRPC-->hoge
```

## ER

### Price Monitoring

```mermaid
erDiagram
  users {
    bigint id PK
    text name
  }
  products　{
    bigint id PK
    bigint user_id FK
    string name
    int price
  }
  crawl_settings {
    bigint id PK
    bigint product_id FK
    int interval "NOT_NULL"
    boolean enabled "default: false, NOT_NULL"
  }
  price_versions {
    bigint id PK
    bigint product_id FK "UNIQUE"
    bigint crawl_result_id FK "UNIQUE"
    int price "default: 0, NOT_NULL"
  }
  crawl_histories {
    bigint id PK
    bigint product_id FK
    jsonb json
  }

  users ||--o{ products : "1:N"
  products ||--|| crawl_settings : "1:1"
  products ||--o{ price_versions : "1:N"
  products ||--o{ crawl_histories : "1:N"
  price_versions ||--|| crawl_histories : "1:1"
```
