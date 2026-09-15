# プロジェクト（セキュリティ）

price-monitoring 固有の攻撃面と既知の境界。handbook と実装の両方を根拠にする。

## システム構成と攻撃面

| レイヤー | 主な攻撃面 |
| --- | --- |
| Frontend (Next.js) | search params、Server/Client 境界、env 変数、BFF 呼び出し |
| Backend BFF (Rails API) | `Api::V1::*` エンドポイント、params、serializer 出力 |
| Session / OIDC | OmniAuth callback、`SessionsController`、`OidcTokenControl`、Redis session |
| Batch (Sidekiq + Playwright) | job 引数、外部サイト crawl、queue 操作 |
| Infra | Sidekiq Web、Redis / MySQL、K8s / Docker、GitHub Actions secrets |

根拠 handbook:

- [docs/backend/overview.md](../../../../docs/backend/overview.md)
- [docs/frontend/overview.md](../../../../docs/frontend/overview.md)

## 既知の境界・注意点

レビュー時に「現状の意図」と「今回の変更で悪化していないか」を分けて見る。

- [ ] **API 認証** — `Api::ApplicationController` 配下は OIDC session とは別系統。認証追加・スキップの意図が明確か
- [ ] **OIDC session** — `session[:access_token]` / `refresh_token` が Redis session に載る。漏洩経路（ログ、エラー、serialize）がないか
- [ ] **CSRF** — `SessionsController#create` は callback のため CSRF 検証を skip。他の state-changing 操作に影響していないか
- [ ] **Sidekiq Web** — `/sidekiq` は本番 Basic 認証 TODO あり。公開・認可の変更が意図どおりか
- [ ] **開発専用設定** — OIDC / Faraday の `ssl verify: false` が development のみに閉じているか
- [ ] **Frontend ↔ BFF** — `NEXT_PUBLIC_*` に秘密情報を載せていない。server-only は `NEXT_PRIVATE_*`

## 責務境界（セキュリティ）

- [ ] 認可・session 操作が controller / concern に閉じ、service / job に散らばっていない
- [ ] frontend が backend 内部 URL や管理 endpoint を直接叩いていない（`lib/api` 経由）
- [ ] Batch が frontend 経由の入力を信頼せず、job 引数・DB から再取得している

## 運用・監視

- [ ] セキュリティイベント（認証失敗、token refresh 失敗、異常 crawl）がログに残る（秘密情報なし）
- [ ] BugSnag / Datadog に token・cookie・Authorization header が載らない
- [ ] CI / デプロイで secrets が plaintext になっていない（GitHub Actions、`make`、manifest）

## データ

- [ ] ユーザー情報（email、provider uid）の保存・表示・ログ出力が最小限
- [ ] crawl 結果・商品データに XSS 可能な文字列が frontend でエスケープなく描画されない
