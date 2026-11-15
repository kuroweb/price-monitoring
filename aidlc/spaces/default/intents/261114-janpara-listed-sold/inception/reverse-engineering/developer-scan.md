# Developer Scan Handoff (price-monitoring)

Intent: janpara-listed-sold（bugfix、Brownfield、Minimal）。Focused scan。head_commit: efe22f77306b1398dfdc6acb5af4b547b83334ef。既存 store は STALE（intent janpara-sold-out、kind full、analyzed.paths は `./`）。

## Developer Code Scan Results

### Scan Coverage
- **Analyzed deeply**:
  - volumes/backend/app/services/product_monitoring/sites/janpara.rb
  - volumes/backend/app/services/product_monitoring/sync_crawl_results.rb
  - volumes/backend/app/services/product_monitoring/detail_candidates.rb
  - volumes/backend/app/services/product_monitoring/crawler.rb
  - volumes/backend/app/services/product_monitoring/url_router.rb
  - volumes/backend/app/services/product_monitoring/filter.rb
  - volumes/backend/app/services/product_monitoring/cleanse_crawl_results.rb
  - volumes/backend/app/services/product_monitoring/lowest_listings.rb
  - volumes/backend/app/services/product_monitoring/sites/iosys.rb
  - volumes/backend/app/services/product_monitoring/sites/treasure_factory.rb
  - volumes/backend/app/services/product_monitoring/sites/yahoo_auction.rb
  - volumes/backend/app/services/product_monitoring/sites/browser_page.rb
  - volumes/backend/app/services/product_monitoring/sites/pagination.rb
  - volumes/backend/spec/services/product_monitoring/sites/janpara_spec.rb
  - volumes/backend/spec/services/product_monitoring/sync_crawl_results_spec.rb
  - volumes/backend/spec/services/product_monitoring/url_router_janpara_spec.rb
  - volumes/backend/spec/services/product_monitoring/crawler_spec.rb
  - docs/backend/product-monitoring-poc.md
- **Skimmed only**:
  - volumes/backend/app/services/product_monitoring/sites/mercari.rb、yahoo_fleamarket.rb、mercari_detail.rb（`sold` と `fetch_detail` の行だけ grep。本体は読んでいない）
  - volumes/backend/app/services/product_monitoring/ の残り（aggregation_purchases、calculate_aggregation_results、crawl_setting_writer、input、lowest_price_notifier、watch_listings、watch_setting_writer）
  - volumes/backend/spec/services/product_monitoring/ の残り（`janpara` の出現数だけ grep。sites/ 配下の他サイトの spec は `janpara` を含まない）
  - 範囲外の読み取り: volumes/backend/db/schema.rb の `product_crawl_results` 定義だけ（列の型の確認）。深い解析には載せない
- **Left out**: 該当なし（build 出力・依存フォルダは開いていない。AI-DLC の install とワークスペースは対象外）

### Packages Found
- ProductMonitoring — Rails service 群（Ruby）— 商品計測の取得・保存・集計・通知。今回の範囲はサイト取得（`Sites::*`、`Crawler`、`UrlRouter`）と保存（`SyncCrawlResults`、`DetailCandidates`、`CleanseCrawlResults`）と表示側の読み取り（`LowestListings`）
- ProductMonitoring::Sites::Janpara — サイトクラス（Ruby）— じゃんぱら検索一覧の解釈。`fetch_detail` は持たない
- 登録順は `UrlRouter::SITES` = Mercari、Iosys、Janpara、YahooFleamarket、YahooAuction、TreasureFactory

### Build System
- **Type**: Bundler / Rails（Compose の `backend` コンテナで実行。今回は実行していない）
- **Config Files**: 範囲外のため未確認
- **Build Dependencies**: Nokogiri（HTML 解析）、Retryable（`BrowserPage.fetch`）、`Crawl::Client` / `Crawl::DynamicProxy`（Playwright 経由の取得）

### APIs Discovered
- 範囲内に HTTP endpoint は無い。内部の入口は `ProductMonitoring::SyncCrawlResults.call(product_crawl_setting:)`（`CrawlJob` から呼ばれる。ジョブ本体は範囲外）
- サイトクラスの契約: `HOST`、`PATH`、`PLATFORM`、`search_urls(keyword)`、`validate_query(uri)`、`fetch(uri)` → `[records, next_uri]`。`fetch_detail(external_id)` を持つのは Mercari と YahooFleamarket だけ（`DetailCandidates#detail_sites` が `respond_to?(:fetch_detail)` で選ぶ）
- 出品ハッシュの形: `external_id`、`name`、`price`、`product_url`、`thumbnail_url`、`sold`、任意で `buyout_price`、`end_date`、`bought_date`

### Frameworks & Libraries
- Nokogiri、Retryable、playwright-ruby-client（`BrowserPage` 経由）。版は既存 store の technology-stack.md を保持（今回は lockfile を開いていない）

### Test Coverage
- **Test Directories**: volumes/backend/spec/services/product_monitoring/、同 sites/
- **Test Frameworks**: RSpec（`rails_helper`）、FactoryBot（`create(:product_crawl_result)`）
- **Coverage Config**: 範囲外のため未確認
- じゃんぱら関連の example
  - `sites/janpara_spec.rb`（3 例）: 商品グループ・下限価格・2 番目の金額の優先と `sold: false`（15 行）、2 価格の範囲を価格 nil にし `.sorry` を空結果と認識し、それ以外の空を例外にする、`fetch_page` の応答・最終ホスト・サイズ検証。売り切れ表示の DOM を使う例は無い
  - `url_router_janpara_spec.rb`（1 例）: Janpara の URL 振り分けと `detail_site("janpara")` が nil
  - `sync_crawl_results_spec.rb` の `describe "じゃんぱらの売り切れ"`（256-320 行、5 例）: 検索から消えた行を売り切れにし、価格なしで検索に残る行と他サイトは変えない / source が無い・別サイトだけの取得では売り切れにしない / 取得失敗では売り切れにしない / 最終更新から 3 時間未満は売り切れにしない / 検索結果にある売却済みの行を販売中へ戻す（`bought_date` は保持）
  - `crawler_spec.rb`: じゃんぱらは検索語の URL 生成の 1 行だけ（103 行）
- 空白（開いた spec に無いもの）
  - 検索結果の `sold: true` のじゃんぱら出品の保存・`sync_janpara_sold` との相互作用
  - 売り切れ表示（`.search_nostock` など）の DOM を使う一覧解析
  - じゃんぱらの source が複数あり一部が失敗する場合
  - 除外済み（`excluded_at`）の行が検索から消えた場合
  - 5 ページ上限を超えた出品の扱い

### Code Quality Indicators
- **Linting**: RuboCop（`.rubocop_todo.yml` あり。今回は実行しない）。`YahooAuction` は `Metrics/ClassLength` を局所的に無効化
- **CI/CD**: 範囲外
- **Documentation**: `docs/backend/product-monitoring-poc.md` が仕様の正本。コードのコメントは日本語で、変更理由を書く

### Technical Debt Signals
- じゃんぱらだけ、検索一覧の `sold` を使わず、保存側で別途補う二重構造になっている（`sites/janpara.rb:69` の `sold: false` 固定と `sync_crawl_results.rb:97-112`）
- イオシスとトレファクは `sold: false` 固定で、検索から消えた行を売り切れにする処理が無い。トレファクは売り切れ DOM を一覧から外すだけ
- 文書 `docs/backend/product-monitoring-poc.md` の 37・39・46 行は、検索から消えたじゃんぱらを売り切れにする処理（コミット 55be0347、e8c2bfd0）を書いていない

## Handoff Summary
- **Intent-relevant finding**:
  1. **一覧解釈の現状**: `Sites::Janpara.listing` は `sold: false` を固定で返す（`sites/janpara.rb:69`）。`.search_nostock` は app・spec・docs のどこにも出現しない（grep で `nostock` と `SOLD OUT` を確認。`SOLD OUT` はトレファクの spec と DOM にだけある）。一覧の対象は `.search_item_s`（41 行）で、売り切れ商品が同じ要素に含まれるか、SOLD OUT 時に価格 `.item_amount` が残るかは、リポジトリに HTML fixture が無く未確認。価格は `.item_amount` が 3 個以上なら nil、2 個なら 2 番目、1 個なら 1 番目で、無ければ `Crawler.parse_price("")` により nil（72-77 行）。
  2. **保存での sold の反映**: 通常経路は `save_matched`（`sync_crawl_results.rb:49-55`）で、価格 nil の結果を捨ててから `upsert_listings` と `update_sold` を呼ぶ。upsert の ON DUPLICATE は `sold` を代入しない（58-67 行）。新規行は INSERT で結果の `sold` が入る。`update_sold`（86-92 行）は `sold == false` の結果では既存が nil の行だけを false にし、`sold == true` の結果では該当行を true にする。つまりメルカリ等では売り切れが販売中へ戻らない。
  3. **じゃんぱら専用の経路**: `sync_janpara_sold`（97-104 行）は `save_matched` の後、同じトランザクション内で実行される。入力は `crawled[:results]` の全件で、価格なし・条件不一致・除外の結果も含む。(a) 検索に返った ID の既存行を、結果の `sold` に関係なく `update_all(sold: false)` する（102 行）。(b) じゃんぱらの source が 1 件以上あり、そのすべてが `succeeded` のとき（`janpara_fetch_succeeded?`、114-117 行。他サイトの失敗と `platform: nil` の未対応 URL は無視）、返らなかった ID で `updated_at` が 3 時間以上前の行を `update_all(sold: true)` する（106-112 行。`updated_at` と `bought_date` は変わらない。除外済みの行も対象）。
  4. **旧実装の不具合の機構**: SOLD OUT が検索に残っているあいだ、(1) 一覧は `sold: false`、(2) 仮に `sold: true` を返しても 102 行が後から false に戻す、(3) 価格が消えていれば `save_matched` が捨てる一方で `returned_ids` には含まれ、既存行は false のまま残り、検索から消えるまで売り切れにならない。(2) と (3) は、一覧解析だけを直しても保存側が上書き・無視する構造になっていることを示す。
  5. **他経路との関係**: `DetailCandidates` が個別確認に回すのは `fetch_detail` を持つメルカリと Yahoo!フリマだけ（`detail_candidates.rb:31-33`）。じゃんぱらは対象外で、spec が `detail_site("janpara")` の nil を固定している。間隔は `DETAIL_RECHECK_INTERVAL = 3.hours`（4 行）で、`sell_out_missing_janpara` も同じ定数を使う。`CleanseCrawlResults` は現在の条件に合わない行を消すだけで、`sold` を見ない。表示側の `LowestListings.candidates` は `not_excluded.where(sold: false)`（`lowest_listings.rb:23`）で、nil は販売中に含まれない。
  6. **取得量の上限**: `Crawler.fetch` は 1 URL につき最大 5 ページ・1 ページ 100 件（`crawler.rb:8-9、74-86`）。500 件を超えた出品は `returned_ids` に入らないが、source は `succeeded` になるため、`sell_out_missing_janpara` の対象になり得る。`store_records` は同じ `external_id` を最初の 1 件だけ残す（67-69 行）。
  7. **列の制約**（範囲外の読み取り）: `product_crawl_results.price` は `integer default 0 null: false`、`sold` は nullable boolean。価格 nil の出品は新規保存できない。
  8. **文書**: 37 行「イオシス・じゃんぱら・トレファクは一覧にある出品を販売中とし」、46 行「個別の店舗在庫や販売状態は確認しない」、39 行は個別確認の候補だけを説明する。検索から消えたじゃんぱらを売り切れにする仕様は文書に無い。
- **Risks / follow-up**:
  - 既存 store の business-overview、architecture、component-inventory、code-quality-assessment は「検索から消えたじゃんぱらは `sold: false` のまま残る」と書いており、コミット 55be0347・e8c2bfd0 の後は古い。architect と合成側はその文章を更新する。
  - `.search_nostock` と SOLD OUT 時の DOM は、依頼で与えられた名前で、リポジトリ内に根拠が無い。fix の実装段階で、実物のクローラーで確かめる必要がある（プロキシ経由のみ）。
  - 範囲外の `CrawlDetailJob`・`ProductCrawlResult` モデル・`WatchListings` は読んでいない。既存 store の記述を保持する。
  - 範囲内でテスト・ビルド・プログラムは実行していない。
