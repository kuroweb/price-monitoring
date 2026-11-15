# Dependencies

版の表は `technology-stack.md`。ここは依存の向きだけを書く。

## 外部

- Frontend の実行依存は `package.json` の `dependencies`（Next.js、React、react-hook-form、nuqs、camelcase-keys、snakecase-keys、react-toastify）。チャートの recharts は `devDependencies` にある
- BFF の実行依存は `volumes/backend/Gemfile`（Rails、Sidekiq、mysql2、Redis セッション、Playwright クライアント、OmniAuth OpenID Connect、Bugsnag、Datadog、rack-cors）
- Auth Provider の実行依存は Devise、Doorkeeper、doorkeeper-openid_connect、mysql2、Redis、Tailwind
- 取得先のサイトは実行時の外部依存。商品計測が名前を持つのはメルカリ、イオシス、じゃんぱら、Yahoo!フリマ、ヤフオク、トレファク
- じゃんぱらは WAF が古い User-Agent を拒否するため、`Crawl::RequestBlocklist::JANPARA_USER_AGENT` を `BrowserPage.fetch` へ渡す。取得は非 2xx のとき最大 5 回やり直す
- プロキシは `Crawl::DynamicProxy`。一覧が取れないときは接続しない、と PoC 文書にある
- Discord は `PRODUCT_MONITORING_DISCORD_WEBHOOK_URL` があるときだけ通知に使う。値は読んでいない
- 本番レジストリは `Makefile` の `docker-registry.kuroweb.net`。CD は GitHub Actions から別リポジトリ `k8s` を更新する
- Dependabot は `volumes/backend`、`volumes/auth-provider`、`volumes/frontend`、GitHub Actions を週次で見る（`docs/cicd/index.md`）。Playwright のメジャー・マイナーはサーバーと揃えるため除外、とある

## 内部

- Frontend → Backend の `/api/v1`。開発ブラウザからは Nginx の `/api`
- Backend のログイン → Auth Provider の OIDC。戻りは Nginx 経由
- Sidekiq（`backend-batch-1` が `crawl_process.yml`、`backend-batch-2` が `general_process.yml`、`backend-batch-3` が `crawl_process_2.yml`）→ 同じ Backend コードと Backend の MySQL / Redis
- Product Monitoring → `Crawl::Client` / `Crawl::DynamicProxy` → Playwright
- Product Monitoring のサイトクラス → `UrlRouter::SITES`。`DetailCandidates` と `CrawlDetailJob` は `fetch_detail` の有無に依存する
- 従来の `Crawl::*` は `*_products` テーブルへ書き、`product_crawl_results` とは別経路
- Auth Provider は Backend のテーブルを参照しない

## Product Monitoring の呼び出し関係（2026-11-14 の focused scan）

隣接リスト。矢印は呼び出し先を表す。

- `SyncCrawlResults` → `Crawler`、`DetailCandidates`、`CleanseCrawlResults`、`ProductCrawlResult`、`Sites::Janpara::PLATFORM`
- `SyncCrawlResults` → `CleanseCrawlResults::FILTER_KEYS`（保存時と削除時で条件の項目を揃える）
- `SyncCrawlResults` → `DetailCandidates::DETAIL_RECHECK_INTERVAL`（じゃんぱらの売り切れ化の待ち時間）
- `Crawler` → `Input`、`UrlRouter`、`Filter`、`Sites::*`（`target[:site].fetch`）
- `DetailCandidates` → `UrlRouter::SITES`、`ProductMonitoring::CrawlDetailJob`、`ProductCrawlResult`
- `UrlRouter` → `Sites::*`（`SITES` に登録された全サイトクラス）
- `Sites::{Iosys,Janpara,TreasureFactory}` → `BrowserPage`、`Pagination`、`Crawler.listing_nodes`、`Crawler.parse_price`
- `Sites::YahooAuction` → `BrowserPage`、`Pagination`、`Crawl::Client`、従来の `Crawl::YahooAuction::SyncProducts::ListPage`
- `CleanseCrawlResults` → `Filter`
- `LowestListings` → `Filter`、`ProductCrawlResult`

`Crawler` はサイトクラスから `listing_nodes` と `parse_price` を呼ばれる一方で、`Sites::*` を `UrlRouter` 経由で呼ぶ。この相互参照は、Ruby の定数が実行時に解決されるため成立している。そのほかに循環 import は見つからなかった。範囲外のファイルの隣接リストは作っていない。

循環 import は、今回読んだ商品計測の Ruby ではサービスがモデルとジョブを呼ぶ一方向だった。Frontend の `features` 間参照は方針として禁止されている。
