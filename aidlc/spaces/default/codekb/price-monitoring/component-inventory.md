# Component Inventory
 
2026-11-15 の重点再調査で確認した範囲は reverse-engineering-timestamp.md を参照。それ以外の記述は以前の調査記録であり、今回の深い検証対象外。

構成要素はデプロイと責務の単位で挙げる。ファイル一覧は `code-structure.md`、HTTP の一覧は `api-documentation.md` にある。

## Frontend

Next.js の画面。`volumes/frontend`。商品計測と商品モニタリングの route は `app/product-crawl-results` と `app/product-monitoring`。販売状態の表示は `features/product-monitoring`。BFF へは `lib/http-client.ts` で依存する。

## Backend

Rails の BFF。`volumes/backend`。セッション、従来の商品・カテゴリ・Backmarket、商品計測 API を持つ。MySQL と Redis に依存する。取得の実処理は Product Monitoring へ委譲する。

## Auth Provider

別 Rails。`volumes/auth-provider`。Devise と Doorkeeper OpenID Connect。BFF とはモデルも DB も共有しない。自分の MySQL と Redis に依存する。

## Nginx

開発用の TLS 終端。`volumes/nginx`。`dev.price-monitoring.com` を Frontend と Backend へ、`dev.auth-provider.com` を Auth Provider へ振り分ける。

## Datastores

BFF 用 MySQL 8.0 と Redis、Provider 用 MySQL 8.0 と Redis。Compose サービスは `backend-db`、`backend-redis`、`auth-provider-db`、`auth-provider-redis`。商品計測の `sold` は BFF 用 MySQL の `product_crawl_results.sold`（nullable boolean）。同じ表の `price` は `null: false, default: 0`。

## Batch Browsers

Playwright サーバー（イメージ `mcr.microsoft.com/playwright:v1.62.0-jammy`、ポート 8888）と Camoufox サーバー（Python 3.12、Camoufox 0.5.8、ポート 8890）。Sidekiq が WebSocket で使う。商品計測の一覧取得は Playwright 側の `Crawl::Client` と `Crawl::DynamicProxy` を通る。

## Product Monitoring

`volumes/backend/app/services/product_monitoring` と `app/sidekiq/product_monitoring` に配置。

- `UrlRouter` は URL を検証しサイトを選択する。`Crawler` はページ取得、取得元の成否、重複排除、フィルタ結果をまとめる。
- `Sites::Janpara` は一覧の売り切れ表示を解析し、`Sites::Iosys` は一覧を販売中として扱う。メルカリと Yahoo!フリマは詳細取得にも対応。
- `SyncCrawlResults` は保存、イオシスとじゃんぱらの販売状態更新、条件外削除を行う。`DetailCandidates` が詳細確認候補を選び、`CrawlDetailJob` が同一 platform・external_id の各行を更新する。
- `Filter` は価格・キーワード・除外 ID を判定する。`AggregationPurchases` は売却日時のある出品をフィルタし、external_id で重複排除する。
- 表示は `LowestListings` と `WatchListings`、通知は `LowestPriceNotifier` が担当する。

依存先は Datastores、Batch Browsers、外部サイト、任意の Discord Webhook。
