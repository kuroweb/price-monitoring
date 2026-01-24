# Project Structure

## Organization Philosophy

- 機能（Feature）ベースの構成
- フロントエンド・バックエンド・認証プロバイダーの分離
- volumes配下にアプリケーションコードを配置

## Directory Patterns

### Root Structure

- `volumes/`: 各サービスのソースコード
- `containers/`: Dockerfile定義
- `docs/`: ドキュメント・設計書

### Frontend (`volumes/frontend/`)

**Pattern**: Next.js App Router + Feature-based

主要ディレクトリ:

- `app/`: ページコンポーネント（App Router）
  - `admin/`: 管理画面
  - `products/`: 商品ページ
- `features/`: 機能別ロジック
  - 各機能配下に `components/`, `hooks/`, `lib/` を配置
- `lib/`: 共通ユーティリティ
  - `actions/`: Server Actions
  - `api/`: APIクライアント・型定義
- `components/`: 共通UIコンポーネント

### Backend (`volumes/backend/`)

**Pattern**: Rails標準 + サービスオブジェクトパターン

主要ディレクトリ:

- `app/controllers/`: コントローラー
  - `api/v1/`: REST API（APIバージョニング）
- `app/models/`: ActiveRecordモデル
- `app/services/`: ビジネスロジック
  - プラットフォーム別: `crawl/{platform}/`
  - 機能別: `products/`, `categories/`
- `app/sidekiq/`: ジョブ定義
- `app/serializers/`: JSONシリアライザー
- `app/finders/`: 検索クエリロジック
- `spec/`: RSpecテスト

### Auth Provider (`volumes/auth_provider/`)

**Pattern**: Rails + Devise + Doorkeeper

- OpenID Connect Provider
- ユーザー認証・セッション管理

## Naming Conventions

### Frontend

- **ファイル**: PascalCase（コンポーネント）、camelCase（hooks/lib）
- **コンポーネント**: `{Feature}{Component}.tsx`
- **フック**: `use{State/Action}.ts`
- **型定義**: `types.ts` にまとめる

### Backend

- **ファイル**: snake_case
- **クラス**: Rails標準（PascalCase）
- **モデル**: 単数形（`Product`, `Category`）
- **コントローラー**: 複数形（`ProductsController`）
- **サービス**: 動詞/名詞 + 機能（`Products::Creator`, `Crawl::Mercari::Crawler`）

## Import Organization

### Frontend

```typescript
// External dependencies
import { useState } from "react";

// Internal absolute imports
import { fetchProducts } from "@/lib/api/products";

// Relative imports
import { ProductCard } from "./ProductCard";
```

**Path Aliases**:

- `@/`: `volumes/frontend/` ルート

### Backend

```ruby
# Rails autoload handles imports
# Services follow namespace pattern
module Crawl
  module Mercari
    class Crawler
    end
  end
end
```

## Code Organization Principles

- 各プラットフォーム（ヤフオク、メルカリ等）は同一パターンで実装
- クロール設定の構造が統一されている（crawl_setting + required/exclude keywords + exclude products）
- APIはバージョニング（`/api/v1/`）
- フロントエンドは機能単位でカプセル化

---
_Document patterns, not file trees. New files following patterns shouldn't require updates_
