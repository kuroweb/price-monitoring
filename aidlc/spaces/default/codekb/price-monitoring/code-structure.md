# Code Structure
 
2026-11-15 の重点再調査で確認した範囲は reverse-engineering-timestamp.md を参照。それ以外の記述は以前の調査記録であり、今回の深い検証対象外。

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
| Service/UseCase | 商品計測は `ProductMonitoring::Crawling` のサイトごとの `Listing::Crawler`・`Listing::Syncer`・`Detail::Crawler`、共通の `CrawlResultCleaner`・`UrlRouter`。商品モニタリングは `ProductMonitoring::Watching` の `WatchListings`、`LowestListings`、`LowestPriceNotifier`、`AggregationPurchases`、`CalculateAggregationResults`。設定の検証・保存は `ProductMonitoring::CrawlSettings::Writer`・`ProductMonitoring::WatchSettings::Writer` |
| Utility/Helper | 商品計測の `Crawling::Client`・`Crawling::Proxy`・`Crawling::RequestBlocklist`。条件の判定は `CrawlSettings::Matcher`・`WatchSettings::Matcher` |
| Repository/DAO | Active Record を service から直接使う。専用 DAO は無い |
| Configuration | `config/routes.rb`、`config/schedule.yml`、`config/sidekiq/*.yml` |
| Test | `volumes/backend/spec/services/product_monitoring`、`spec/sidekiq/product_monitoring`、`volumes/frontend/tests/features/product-monitoring` |

サイトごとのクラスは `ProductMonitoring::Crawling::<Site>::Listing`（`SearchUrl`・`Crawler`・`Syncer`）と `<Site>::Detail`（`Crawler`・`Syncer`。メルカリと Yahoo!フリマだけ）にあり、ジョブは `app/sidekiq/product_monitoring/crawling/<site>/{listing,detail}/sync_job.rb` にある。`UrlRouter::PLATFORMS` の並びは Mercari、Iosys、Janpara、YahooFleamarket、YahooAuction、TreasureFactory。

## 商品計測の spec の対応

| spec | 対象 |
| --- | --- |
| `spec/services/product_monitoring/crawling/janpara/listing/crawler_spec.rb` | `Janpara::Listing::Crawler` の一覧解析、価格、空結果、ページ送り |
| `spec/services/product_monitoring/crawling/<site>/listing/syncer_spec.rb` | サイトごとの保存、販売状態の更新、個別確認ジョブの投入 |
| `spec/services/product_monitoring/crawling/<site>/{listing,detail}/crawler_spec.rb` | サイトごとの一覧・個別確認の取得と解析、ページ送り、失敗時のログ |
| `spec/sidekiq/product_monitoring/crawling/enqueue_sync_job_spec.rb` | 有効な設定ごとの、サイトごとの一覧ジョブの投入 |
| `spec/sidekiq/product_monitoring/queues_spec.rb` | ジョブごとのキュー名と、Sidekiq のプロセスがそのキューを処理すること |

## パターン

- サイト追加はそのサイトの `Listing` 一式とジョブの追加、`UrlRouter::PLATFORMS` への登録、`config/sidekiq` へのキューの追加（`docs/features/product-monitoring/index.md`）
- 個別確認ができるサイトだけが `<Site>::Detail::Crawler` と `<Site>::Detail::SyncJob` を持つ。その `Listing::Syncer` が詳細確認の候補を選んで詳細ジョブを積む
- クローラーは外部に `call` だけを公開し、取得と解析はインスタンスの private メソッドに置く
- 出品ハッシュの `sold` はクローラーが付け、保存側の `update_sold` が使う。イオシスとじゃんぱらは `Listing::Syncer` が、検索結果と取得の完全性に基づき別途調整する
- ジョブは薄く、本体は service に委譲する。`Crawling::EnqueueSyncJob` はサイトごとの一覧ジョブを投入するだけで、一覧ジョブはそのサイトの `Listing::Syncer.call` を呼ぶだけである
- コメントは日本語で、変更の理由を書く
- Frontend の `lib/http-client.ts` は JSON のキーを camelCase と snake_case で変換する
