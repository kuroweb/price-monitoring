## Developer Code Scan Results

今回の13ファイルは、現在の対象スナップショット取得後に再確認した。既存の他範囲は深い検証の対象に含めない。

### Scan Coverage
- **Analyzed deeply**: `volumes/backend/app/services/product_monitoring/crawler.rb`, `sync_crawl_results.rb`, `detail_candidates.rb`, `filter.rb`, `input.rb`, `url_router.rb`, `aggregation_purchases.rb`
- **Analyzed deeply**: `volumes/backend/app/services/product_monitoring/sites/janpara.rb`, `sites/iosys.rb`, `volumes/backend/app/sidekiq/product_monitoring/crawl_detail_job.rb`
- **Analyzed deeply**: `volumes/backend/spec/services/product_monitoring/crawler_spec.rb`, `sync_crawl_results_spec.rb`, `docs/features/product-monitoring/index.md`
- **Skimmed only**: 関連する他サイト、ジョブ、API、モデル、DB スキーマ、画面、既存 CodeKB。以前の詳細調査のうち上記以外は再検証していない。
- **Left out**: 依存ライブラリ、ビルド成果物、キャッシュ、秘密情報。アプリの実行・テストは行っていない。

### Packages Found
- Rails Backend の `ProductMonitoring`: 検索取得、保存、個別確認、相場集計、表示・通知。
- Next.js Frontend: 設定と結果の画面。旧 `Crawl` は別の従来機能であり、今回の詳細対象ではない。

### Build System
- **Type**: Bundler。アプリ実行・検証は Compose backend service。
- **Config Files**: 既存記録の technology-stack.md を参照。
- **Build Dependencies**: Rails と Sidekiq は DB、Redis、外部取得基盤に依存。

### APIs Discovered
- JSON API: 商品計測設定、計測結果、商品モニタリング設定、日次相場。手動取得はジョブ投入後 202。詳細は api-documentation.md。

### Frameworks & Libraries
- Rails、Sidekiq、Nokogiri、Playwright。バージョンは technology-stack.md の既存記録を参照し、今回再検証していない。

### Test Coverage
- **Test Directories**: `volumes/backend/spec/services/product_monitoring/`、`spec/sidekiq/product_monitoring/`、`spec/requests/`。
- **Test Frameworks**: RSpec。
- **Coverage Config**: 今回は未確認。測定値なし。

### Code Quality Indicators
- **Linting**: 既存記録を参照。今回実行していない。
- **CI/CD**: 既存記録を参照。今回再検証していない。
- **Documentation**: 商品計測の仕様は `docs/features/product-monitoring/index.md` にある。

### Technical Debt Signals
- `Crawler` は取得・URL ごとの失敗状態・重複排除・採否判定を扱い、結果を名前付きでないハッシュで引き渡す。
- `SyncCrawlResults` は SQL upsert、販売状態調整、条件外削除、詳細確認ジョブ投入をまとめている。
- 同一性が処理ごとに異なる。Crawler と集計は external_id、表示は platform と external_id、DB 一意制約は setting と external_id。衝突は可能性であり発生実績未確認。
- `updated_at` が内容更新と詳細再確認間隔に使われている。

## Handoff Summary
- **Intent-relevant finding**: 一覧取得の成功・失敗・ページ上限は、その後のサイト別販売状態更新と詳細確認の可否を変える。特に `SyncCrawlResults#site_fetch_succeeded?` と `DetailCandidates#complete_sources?` の打ち切り扱いは異なる。
- **Risks / follow-up**: 除外済み行の更新、価格なし出品の存在判定、3時間境界、売却日の保持、別サイトの失敗、手動同期と API 契約を維持する。ID の統一は既存データ・DB 制約・集計の仕様変更が必要になり得る。旧計測との統合範囲はユーザー確認が必要。
