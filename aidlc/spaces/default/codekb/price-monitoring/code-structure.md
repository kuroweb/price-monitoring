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
| Utility/Helper | `ProductMonitoring::Filter`、`Input`、`Sites::BrowserPage`、`Sites::Pagination`。サイトクラスの `Crawler.listing_nodes` と `Crawler.parse_price` も共通の補助 |
| Repository/DAO | Active Record を service から直接使う。専用 DAO は無い |
| Configuration | `config/routes.rb`、`config/schedule.yml`、`config/sidekiq/*.yml` |
| Test | `volumes/backend/spec/services/product_monitoring`、`spec/sidekiq/product_monitoring`、`volumes/frontend/tests/features/product-monitoring` |

サイトクラスは `ProductMonitoring::Sites` にある（`mercari.rb`、`mercari_detail.rb`、`iosys.rb`、`janpara.rb`、`yahoo_fleamarket.rb`、`yahoo_auction.rb`、`treasure_factory.rb`、共通の `browser_page.rb`、`pagination.rb`）。`UrlRouter::SITES` の並びは Mercari、Iosys、Janpara、YahooFleamarket、YahooAuction、TreasureFactory。

## 商品計測の spec の対応

| spec | 対象 |
| --- | --- |
| `spec/services/product_monitoring/sites/janpara_spec.rb` | `Sites::Janpara` の一覧解析、価格、空結果、`fetch_page` の検証 |
| `spec/services/product_monitoring/url_router_janpara_spec.rb` | じゃんぱらの URL 振り分けと `detail_site("janpara")` が nil |
| `spec/services/product_monitoring/sync_crawl_results_spec.rb` | 保存、`update_sold`、個別確認ジョブの投入、`describe "じゃんぱらの売り切れ"` |
| `spec/services/product_monitoring/crawler_spec.rb` | ページ上限、重複除去、フィルター、source の状態 |
| `spec/services/product_monitoring/sites/*_spec.rb` | サイトごとの一覧解析。じゃんぱら以外は `janpara` を含まない |

## パターン

- サイト追加はサイトクラスと `UrlRouter::SITES` への登録（`docs/backend/product-monitoring-poc.md`）
- 個別確認ができるサイトだけが `self.fetch_detail` を定義する。呼び出し側は `respond_to?(:fetch_detail)` で選ぶ
- サイトクラスは全て class method の集まりで、状態を持たない。`fetch(uri)` は `[records, next_uri]` を返す
- 出品ハッシュの `sold` はサイトクラスが付け、保存側の `update_sold` が使う。じゃんぱらは例外で、保存側の `sync_janpara_sold` が別に調整する
- ジョブは薄く、本体は service に委譲する。`CrawlJob` は `SyncCrawlResults.call` を呼ぶだけである
- コメントは日本語で、変更の理由を書く
- Frontend の `lib/http-client.ts` は JSON のキーを camelCase と snake_case で変換する
