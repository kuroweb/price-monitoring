# Dependencies

版の表は `technology-stack.md`。ここは依存の向きだけを書く。

## 外部

- Frontend の実行依存は `package.json` の `dependencies`（Next.js、React、react-hook-form、nuqs、camelcase-keys、snakecase-keys、react-toastify）。チャートの recharts は `devDependencies` にある
- BFF の実行依存は `volumes/backend/Gemfile`（Rails、Sidekiq、mysql2、Redis セッション、Playwright クライアント、OmniAuth OpenID Connect、Bugsnag、Datadog、rack-cors）
- Auth Provider の実行依存は Devise、Doorkeeper、doorkeeper-openid_connect、mysql2、Redis、Tailwind
- 取得先のサイトは実行時の外部依存。商品計測が名前を持つのはメルカリ、イオシス、じゃんぱら、Yahoo!フリマ、ヤフオク、トレファク
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

循環 import は、今回読んだ商品計測の Ruby ではサービスがモデルとジョブを呼ぶ一方向だった。Frontend の `features` 間参照は方針として禁止されている。全ファイルの隣接リストは作っていない。
