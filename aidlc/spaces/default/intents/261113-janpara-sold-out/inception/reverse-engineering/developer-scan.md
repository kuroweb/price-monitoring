# Developer Code Scan

## Developer Code Scan Results

リポジトリ全体を対象に、人が書いたソースと文書を読んだ。商品計測の販売状態は、`ProductMonitoring` の取得・保存・個別確認・表示までをコードで追った。

### Scan Coverage

- **Analyzed deeply**:
  - `README.md`
  - `AGENTS.md`（AI-DLC 管理ブロックの外）
  - `docs/index.md`
  - `docs/backend/index.md`
  - `docs/backend/product-monitoring-poc.md`
  - `docs/frontend/index.md`
  - `docs/database/index.md`
  - `docs/cicd/index.md`
  - `docs/auth-provider/index.md`
  - `docker-compose.yml`
  - `justfile`
  - `Makefile`（イメージ名とビルドの入口）
  - `containers/backend/Dockerfile`
  - `containers/frontend/Dockerfile`
  - `containers/backend_playwright/Dockerfile`
  - `containers/backend_camoufox/Dockerfile`
  - `volumes/nginx/templates/default.conf.template`
  - `volumes/backend/Gemfile` と `Gemfile.lock` の版
  - `volumes/backend/config/routes.rb`
  - `volumes/backend/config/schedule.yml`
  - `volumes/backend/db/schema.rb` の `product_crawl_results`
  - `volumes/backend/app/services/product_monitoring/`
  - `volumes/backend/app/sidekiq/product_monitoring/`
  - `volumes/backend/app/models/product_crawl_result.rb`
  - `volumes/backend/app/controllers/api/`
  - `volumes/backend/spec/services/product_monitoring/sites/janpara_spec.rb`
  - `volumes/frontend/package.json`
  - `volumes/frontend/app/`
  - `volumes/frontend/features/product-monitoring/`
  - `volumes/frontend/lib/http-client.ts`
  - `volumes/auth-provider/Gemfile` と `Gemfile.lock` の版
  - `volumes/auth-provider/config/routes.rb`
- **Skimmed only**:
  - `volumes/backend/app/services/crawl/`
  - `volumes/backend/app/models/`（`ProductCrawlResult` 以外）
  - `volumes/backend/app/sidekiq/crawl/`
  - `volumes/frontend/features/products/`
  - `volumes/frontend/features/categories/`
  - `volumes/frontend/features/backmarket/`
  - `volumes/frontend/features/auth/`
  - `volumes/auth-provider/app/`
  - `docs/development/`
  - `.github/workflows/`
  - `volumes/backend/.rubocop.yml`
  - `volumes/frontend/vitest.config.mts`
- **Left out**:
  - `node_modules/`
  - `vendor/`
  - `tmp/`
  - `log/`
  - `coverage/`
  - `.next/`
  - `dist/`
  - `bin/`
  - `obj/`
  - `.claude/`
  - `.codex/`
  - `.cursor/`
  - `aidlc/`
  - `.env`、証明書、鍵
  - `AGENTS.md` と `.gitignore` の AI-DLC 管理ブロック

### Packages Found

- `volumes/backend` — application — Ruby — BFF と Sidekiq のバッチ。商品計測を含む
- `volumes/frontend` — application — TypeScript — Next.js の画面
- `volumes/auth-provider` — application — Ruby — OIDC Provider
- `containers/backend_playwright` — service — Node.js — Playwright サーバー
- `containers/backend_camoufox` — service — Python — Camoufox サーバー
- `volumes/nginx` — configuration — Nginx — 開発用の HTTPS 振り分け

### Build System

- **Type**: Docker Compose（`docker-compose.yml`、`justfile`）と、本番イメージ用の `Makefile`
- **Config Files**: `docker-compose.yml`、`docker-compose.worktree.yml`、`justfile`、`Makefile`、`volumes/backend/Gemfile`、`volumes/auth-provider/Gemfile`、`volumes/frontend/package.json`、`containers/*/Dockerfile`
- **Build Dependencies**: Frontend は BFF の `/api` を呼ぶ。BFF と Sidekiq は同じ `volumes/backend` イメージ。Sidekiq は Playwright と Camoufox へ WebSocket で接続する。CD はイメージをレジストリへ送り、別リポジトリ `k8s` の `manifests/price-monitoring` のタグを更新する

### APIs Discovered

- HTTP JSON — `volumes/backend/config/routes.rb` の `/api/v1` — リソース 11 系統（商品、カテゴリ、Backmarket、商品価格、商品計測、商品モニタリング、集計）
- OIDC — `volumes/auth-provider/config/routes.rb` — Doorkeeper と Doorkeeper OpenID Connect
- ブラウザ操作 — Playwright `ws://backend-playwright:8888/ws`、Camoufox `ws://backend-camoufox:8890/ws`

### Frameworks & Libraries

- Rails — 8.1.4.1 — BFF と Auth Provider
- Next.js — 16.4.5 — 画面
- React — 19.3.1 — UI
- Sidekiq — 8.1.7 — 定期取得と集計
- Playwright — 1.62.0 — 一覧と詳細の HTML 取得
- Camoufox — 0.5.8 — 別系統のブラウザ取得
- Devise — 5.0.4 — Provider の利用者
- Doorkeeper — 5.9.9 — OAuth / OIDC
- MySQL — イメージ `mysql/mysql-server:8.0` — BFF 用と Provider 用で分離

### Test Coverage

- **Test Directories**: `volumes/backend/spec`、`volumes/frontend/tests`。Auth Provider は `rspec-rails` と CI の RSpec ジョブがある
- **Test Frameworks**: RSpec 8.0.4（backend lock）、Vitest 5.1.0
- **Coverage Config**: Frontend は `volumes/frontend/vitest.config.mts` に v8 coverage がある。Backend に SimpleCov の設定は見当たらない

### Code Quality Indicators

- **Linting**: Backend と Auth Provider は RuboCop 1.92.2（`volumes/backend/.rubocop.yml` は `.rubocop_todo.yml` を継承）。Frontend は ESLint 10.14.0 と `typescript` 5.9.3 の `tsc --noEmit`
- **CI/CD**: `.github/workflows/ci-pr.yml`、`cicd-integration.yml`、`cicd-production.yml`、`reusable-cd.yml`。Integration は `develop`、Production は `master`
- **Documentation**: ルート `README.md` と `docs/` が入口。商品計測の操作と制約は `docs/backend/product-monitoring-poc.md`。`docs/database/index.md` は従来の `products` と `*_products` が中心で、`product_crawl_results` には触れていない

### Technical Debt Signals

- `ProductMonitoring::Sites::Janpara` は一覧の各出品を `sold: false` で返す。`fetch_detail` が無いので、検索結果から消えた行は `DetailCandidates` の候補に入らない
- イオシスとトレファクも `fetch_detail` が無く、保存する出品の `sold` は `false`。トレファクは売り切れ表示の DOM を一覧から外す
- `Api::ApplicationController` は `require_login` を呼ばない。`docs/auth-provider/index.md` も、管理 API に会員ごとの権限分離はないと書いている
- `config/routes.rb` に、本番 Sidekiq 画面へ Basic 認証をかける TODO がある
- 従来の `Crawl::*` と `ProductMonitoring::Sites` が並存する。従来の `Crawl::Janpara` に `sold` はない

## Handoff Summary

- **Intent-relevant finding**: じゃんぱらの商品計測結果は、一覧にいるあいだ `sold: false` で保存され、一覧から消えても `sold: false` のまま残る。`ProductMonitoring::Sites::Janpara.listing` は常に `sold: false` を返す（`volumes/backend/app/services/product_monitoring/sites/janpara.rb` 67–69 行）。`janpara_spec.rb` もその値を期待する。`SyncCrawlResults#update_sold` は、今回の結果に含まれる ID だけを更新する（`sync_crawl_results.rb` 85–90 行）。`sold: false` の既存行を false のままにする処理は、`sold` が `nil` の行に限る。重複時の `upsert_all` は `sold` 列を代入しない（56–66 行）。`DetailCandidates#detail_sites` は `fetch_detail` を持つサイトだけを選ぶ（`detail_candidates.rb` 31–32 行）。`UrlRouter::SITES` でそれを実装しているのは `Sites::Mercari` と `Sites::YahooFleamarket`。`UrlRouter.detail_site` が無いプラットフォームでは `CrawlDetailJob` は即 return する（`crawl_detail_job.rb` 14–16 行）。商品モニタリングの販売中は `ProductCrawlResult.not_excluded.where(sold: false)` である（`lowest_listings.rb` 23 行）。`sold: nil` はこの条件に入らない。
- **Risks / follow-up**: 販売中（`sold: false`）の行を、検索結果に無いことだけを理由に売り切れへ変える処理は、いまのコードには無い。ヤフオクは落札相場の一覧だけを `sold: true` にする。メルカリと Yahoo!フリマは一覧の売り切れ表示に加え、`fetch_detail` の結果で `sold` を上書きする。イオシスとトレファクはじゃんぱらと同じく `fetch_detail` が無い。
