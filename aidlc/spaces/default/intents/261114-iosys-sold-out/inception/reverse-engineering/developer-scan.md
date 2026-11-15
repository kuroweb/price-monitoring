## Developer Code Scan Results

### Scan Coverage
- 7 ファイルを個別に指定したスナップショット取得後に再読し、候補の対象範囲と一致することを確認した。
- **Analyzed deeply**: `volumes/backend/app/services/product_monitoring/sync_crawl_results.rb`
- **Analyzed deeply**: `volumes/backend/app/services/product_monitoring/sites/iosys.rb`
- **Analyzed deeply**: `volumes/backend/app/services/product_monitoring/sites/janpara.rb`
- **Analyzed deeply**: `volumes/backend/app/services/product_monitoring/crawler.rb`
- **Analyzed deeply**: `volumes/backend/app/services/product_monitoring/detail_candidates.rb`
- **Analyzed deeply**: `volumes/backend/spec/services/product_monitoring/sync_crawl_results_spec.rb`
- **Analyzed deeply**: `volumes/backend/spec/services/product_monitoring/sites/iosys_spec.rb`
- **Skimmed only**: 既存の全体知識ベース（前回スキャン、現時点では未検証）
- **Left out**: 依存パッケージ、生成物、キャッシュ、秘密情報、AI-DLC のインストール

### Packages Found
- Backend — Rails アプリケーション — Ruby — BFF、バッチ、商品監視

### Build System
- **Type**: Bundler
- **Config Files**: `volumes/backend/Gemfile`、`Gemfile.lock`（既存知識より）
- **Build Dependencies**: Rails アプリと Sidekiq は同じ Backend コードに依存

### APIs Discovered
- 商品検索の内部契約 — `Crawler.call` は `sources` と `results` を返し、source ごとに platform と status を記録
- サイトアダプター — `Sites::Iosys.fetch` と `Sites::Janpara.fetch` が一覧と次ページを返す

### Frameworks & Libraries
- Rails / Active Record、Nokogiri、RSpec（版は既存知識を参照）

### Test Coverage
- **Test Directories**: `volumes/backend/spec/services/product_monitoring/`
- **Test Frameworks**: RSpec
- **Coverage Config**: 今回未調査

### Code Quality Indicators
- **Linting**: RuboCop（既存知識）
- **CI/CD**: 既存知識を保持、今回未検証
- **Documentation**: 既存知識を保持、今回未検証

### Technical Debt Signals
- イオシスは一覧で常に販売中を返し、個別取得も、検索から消えた行の同期もない。
- 一覧取得は最大５ページで切るため、それを超える結果で検索から消えたと判断する場合の影響に注意する。

## Handoff Summary
- **Intent-relevant finding**: `sync_crawl_results.rb` の `sync_janpara_sold` は対象サイトの source が１件以上ありすべて成功したとき、最終更新が３時間以上前で今回の全検索結果にない行を売り切れにする。戻った行は販売中へ戻す。PR #185 のコミット 55be0347 後、source 不在時の扱いが修正されているため現行コードを基準にする。 `sites/iosys.rb` は `sold: false` 固定で `fetch_detail` がない。
- **Risks / follow-up**: 価格なしの検索結果も消失判定から除外すること、同サイトの複数 source の一部失敗や source 不在を考慮すること、他サイト・設定への影響と再出現、売却日・更新日時の維持を検証すること。
