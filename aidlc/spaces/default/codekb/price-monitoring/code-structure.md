# Code Structure

アプリのソースは `volumes/` にあり、イメージ定義は `containers/`、開発の入口はルートの `docker-compose.yml` と `justfile` にある。文書の入口は `docs/index.md`。

## ディレクトリ

| パス | 役割 |
| --- | --- |
| `volumes/frontend/app` | Next.js の route |
| `volumes/frontend/features` | 機能ごとの UI と API クライアント |
| `volumes/frontend/lib` | HTTP クライアントと表示の補助 |
| `volumes/backend/app/controllers/api/v1` | JSON API |
| `volumes/backend/app/services/product_monitoring` | 商品計測の取得・保存・集計・通知 |
| `volumes/backend/app/services/crawl` | 従来のプラットフォーム別クロール |
| `volumes/backend/app/sidekiq` | ジョブの入口 |
| `volumes/backend/app/models` | Active Record |
| `volumes/auth-provider` | OIDC Provider |
| `volumes/nginx` | 開発用リバースプロキシ |

`features` 同士は読み込まない、という方針が `docs/frontend/index.md` にある。Backend は controller、service、model、sidekiq、serializer、finder を分けている。

## 分類

商品計測に限ると、次の対応になる。

| 分類 | 置き場所 |
| --- | --- |
| Model/Entity | `ProductCrawlResult`、`ProductCrawlSetting`、`ProductWatchSetting`、`ProductAggregationResult` |
| Controller/Handler | `Api::V1::ProductCrawlSettingsController`、`ProductCrawlResultsController`、`ProductWatchSettingsController`、`ProductAggregationResultsController` |
| Service/UseCase | `ProductMonitoring::Crawler`、`SyncCrawlResults`、`DetailCandidates`、`CleanseCrawlResults`、`WatchListings`、`LowestListings`、`CalculateAggregationResults` |
| Repository/DAO | Active Record を service から直接使う。専用 DAO は無い |
| Configuration | `config/routes.rb`、`config/schedule.yml`、`config/sidekiq/*.yml` |
| Test | `volumes/backend/spec/services/product_monitoring`、`spec/sidekiq/product_monitoring`、`volumes/frontend/tests/features/product-monitoring` |

サイトクラスは `ProductMonitoring::Sites` にある。`UrlRouter::SITES` の並びは Mercari、Iosys、Janpara、YahooFleamarket、YahooAuction、TreasureFactory。

## パターン

- サイト追加はサイトクラスと `UrlRouter::SITES` への登録（`docs/backend/product-monitoring-poc.md`）
- 個別確認ができるサイトだけが `self.fetch_detail` を定義する。呼び出し側は `respond_to?(:fetch_detail)` で選ぶ
- ジョブは薄く、本体は service に委譲する。`CrawlJob` は `SyncCrawlResults.call` を呼ぶだけである
- Frontend の `lib/http-client.ts` は JSON のキーを camelCase と snake_case で変換する
