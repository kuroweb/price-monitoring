# price-monitoring

価格監視ツール

Web上にある欲しい物の価格監視を行うことができる (予定)

## 技術スタック (予定)

### フロントエンド

- Next.js
- TypeScript
- TailwindCSS

### バックエンド

- Rails7

### GraphQLサーバ

- Go
- gqlgen

### 開発インフラ

- Docker Compose

### デプロイ

- 自宅Kubernetes (Master Node x 1, Worker Node x 2構成)

## アーキテクチャ (予定)

```mermaid
flowchart
subgraph Architecture
  direction LR

  subgraph frontend
    Next.js
  end

  subgraph backend
    Rails7
  end

  subgraph graphql
    direction TB

    Go
    GraphQL[(GraphQL)]

    Go-->GraphQL
  end

  frontend-->backend-->graphql
end
```

## 備考

- プロキシサーバの構成（自分用ならそもそも不要だが、学習用としてNginxを挟むのが良いかも）
