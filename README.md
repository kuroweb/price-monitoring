# price-monitoring

価格監視ツール

Web上にある欲しい物の価格監視を行うことができる (予定)

## 技術スタック (予定)

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

## アーキテクチャ (予定)

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
