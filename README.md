# price-monitoring

価格監視ツール

Web上にある欲しい物の価格監視を行うことができる (予定)

## 技術スタック (予定)

### Frontend

- Next.js
- TypeScript
- TailwindCSS

### Backend

- Rails7

### GraphQL Server

- Go
- gqlgen

### 開発インフラ

- Docker Compose

### デプロイ

- 自宅Kubernetes (Master Node x 1, Worker Node x 2構成)

## アーキテクチャ (予定)

```mermaid
flowchart LR
subgraph Kubernetest Node
  subgraph Frontend
    direction LR

    Nginx
    Next.js

    Nginx--proxy-->Next.js
  end

  subgraph Backend
    Rails7
  end

  subgraph GraphQL Server
    direction LR

    Go
    GraphQL[(GraphQL)]

    Go-->GraphQL
  end

  Next.js-->Rails7-->Go
end

client-->Nginx
```

## 備考

- プロキシサーバの構成（自分用ならそもそも不要だが、学習用としてNginxを挟むのが良いかも）
