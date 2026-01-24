# Technology Stack

## Architecture

- Frontend/Backend分離アーキテクチャ
- バックエンドがBFFとして機能
- 非同期バッチ処理（Sidekiq）によるクロール
- OpenID Connect認証（自前の認証プロバイダー）

## Core Technologies

### Frontend

- **Framework**: Next.js 14（App Router）
- **Language**: TypeScript 5
- **Styling**: TailwindCSS + daisyUI
- **Runtime**: Node.js

### Backend

- **Framework**: Rails 7.1
- **Language**: Ruby 3.2.2
- **Database**: MySQL 8.0
- **Cache/Queue**: Redis

### Auth Provider

- **Framework**: Rails（Doorkeeper OAuth Provider）
- **認証**: Devise + OpenID Connect

## Key Libraries

### Frontend

- axios: HTTP クライアント
- react-hook-form: フォーム管理
- nuqs: URL クエリ状態管理
- recharts: チャート描画
- react-toastify: 通知

### Backend

- sidekiq / sidekiq-cron: ジョブ処理
- playwright-ruby-client: Webスクレイピング
- omniauth_openid_connect: OIDC認証
- closure_tree: 階層構造カテゴリ
- ddtrace / bugsnag: 監視・エラートラッキング

## Development Standards

### Type Safety

- TypeScript: Next.js推奨設定準拠
- Ruby: 静的型なし（RubyGems依存）

### Code Quality

- Frontend: ESLint + Prettier + eslint-plugin-tailwindcss
- Backend: RuboCop（rubocop-rails, rubocop-rspec, rubocop-performance）

### Testing

- Frontend: （テスト未構築）
- Backend: RSpec + FactoryBot + Shoulda-Matchers

## Development Environment

### Required Tools

- Docker Compose
- just（タスクランナー）
- mkcert（ローカル証明書）
- openssl（秘密鍵生成）

### Common Commands

```bash
# 起動
just up

# 停止
just down

# ログ確認
just logs

# テスト実行
just rspec

# アタッチ
just attach {container-name}
```

### Local URLs

- メインアプリ: https://dev.price-monitoring.com/
- 認証プロバイダー: https://dev.auth.price-monitoring.com/

## Key Technical Decisions

- Docker Compose for development, Kubernetes for production
- GitOpsデプロイ（ArgoCD）
- VPS上のプロキシ経由でスクレイピング
- Playwright（Chromiumベース）によるブラウザ自動化

---
_Document standards and patterns, not every dependency_
