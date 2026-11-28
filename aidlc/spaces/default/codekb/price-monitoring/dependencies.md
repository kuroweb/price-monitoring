# Dependencies
 
2026-11-15 の重点再調査で確認した範囲は reverse-engineering-timestamp.md を参照。それ以外の記述は以前の調査記録であり、今回の深い検証対象外。

版の表は `technology-stack.md`。ここは依存の向きだけを書く。

## 外部

- Frontend の実行依存は `package.json` の `dependencies`（Next.js、React、react-hook-form、nuqs、camelcase-keys、snakecase-keys、react-toastify）。チャートの recharts は `devDependencies` にある
- BFF の実行依存は `volumes/backend/Gemfile`（Rails、Sidekiq、mysql2、Redis セッション、Playwright クライアント、OmniAuth OpenID Connect、Bugsnag、Datadog、rack-cors）
- Auth Provider の実行依存は Devise、Doorkeeper、doorkeeper-openid_connect、mysql2、Redis、Tailwind
- 取得先のサイトは実行時の外部依存。商品計測が名前を持つのはメルカリ、イオシス、じゃんぱら、Yahoo!フリマ、ヤフオク、トレファク
- じゃんぱらは WAF が古い User-Agent を拒否するため、じゃんぱらの `Crawler` が持つ新しい User-Agent で `Client` を開く。取得は非 2xx のとき最大 5 回やり直す
- プロキシは `Crawling::Proxy`（`DYNAMIC_PROXY_LIST_URL` の一覧を1日キャッシュ）。一覧が取れないときは接続しない、と PoC 文書にある
- Discord は `PRODUCT_MONITORING_DISCORD_WEBHOOK_URL` があるときだけ通知に使う。値は読んでいない
- 本番レジストリは `Makefile` の `docker-registry.kuroweb.net`。CD は GitHub Actions から別リポジトリ `k8s` を更新する
- Dependabot は `volumes/backend`、`volumes/auth-provider`、`volumes/frontend`、GitHub Actions を週次で見る（`docs/development/cicd/README.md`）。Playwright のメジャー・マイナーはサーバーと揃えるため除外、とある

## 内部

- Frontend → Backend の `/api/v1`。開発ブラウザからは Nginx の `/api`
- Backend のログイン → Auth Provider の OIDC。戻りは Nginx 経由
- Sidekiq（`backend-batch-1` が `crawl_process.yml`、`backend-batch-2` が `general_process.yml`、`backend-batch-3` が `crawl_process_2.yml`）→ 同じ Backend コードと Backend の MySQL / Redis
- Product Monitoring → `Crawling::Client` / `Crawling::Proxy` → Playwright。従来の `Crawl::*` には依存しない
- Product Monitoring のサイトの `Listing` → `UrlRouter::PLATFORMS`。個別確認の有無と一覧からの販売状態の反映は、サイトごとの `Listing::Syncer` に書く
- 従来の `Crawl::*` は `*_products` テーブルへ書き、`product_crawl_results` とは別経路
- Auth Provider は Backend のテーブルを参照しない

## Product Monitoring の呼び出し関係（2026-11-15 focused scan）

`Crawling::EnqueueSyncJob → <Site>::Listing::SyncJob → <Site>::Listing::Syncer → <Site>::Listing::Crawler`。保存中は `CrawlResultCleaner → CrawlSettings::Matcher`、保存後は `<Site>::Detail::SyncJob → <Site>::Detail::Syncer → <Site>::Detail::Crawler`。相場は `Watching::CalculateAggregationResults → Watching::AggregationPurchases → WatchSettings::Matcher`。サイト実装はブラウザ取得基盤と DOM に依存する。
