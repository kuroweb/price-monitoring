# Component Inventory

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

BFF 用 MySQL 8.0 と Redis、Provider 用 MySQL 8.0 と Redis。Compose サービスは `backend-db`、`backend-redis`、`auth-provider-db`、`auth-provider-redis`。商品計測の `sold` は BFF 用 MySQL の `product_crawl_results.sold`。

## Batch Browsers

Playwright サーバー（イメージ `mcr.microsoft.com/playwright:v1.62.0-jammy`、ポート 8888）と Camoufox サーバー（Python 3.12、Camoufox 0.5.8、ポート 8890）。Sidekiq が WebSocket で使う。商品計測の一覧取得は Playwright 側の `Crawl::Client` と `Crawl::DynamicProxy` を通る。

## Product Monitoring

`volumes/backend/app/services/product_monitoring` と `app/sidekiq/product_monitoring`。Backend のプロセス内コンポーネント。

- `UrlRouter` が検索 URL とサイトクラスを対応させる
- `Sites::Janpara` は一覧だけを解析し、`sold: false` を返す。`fetch_detail` は無い
- `Sites::Mercari` と `Sites::YahooFleamarket` だけが `fetch_detail` を持つ
- `SyncCrawlResults` が結果を保存し、`DetailCandidates` が個別確認を積む
- `CrawlDetailJob` が詳細の `sold` を同じ外部 ID の行へ書く
- `LowestListings` と `WatchListings` が `sold: false` を販売中として読む
- `LowestPriceNotifier` が最安の変化を Discord へ送る。Webhook が未設定なら送らない

依存先は Datastores、Batch Browsers、外部サイト、任意の Discord Webhook。
