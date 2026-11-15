# Test Results

実行日: 2026-11-15。すべて Docker Compose の `backend` コンテナで実行した。

## Build status

成功。ビルド工程は無く、RuboCop が通り、全 spec が読み込めて実行できた。

## Commands and results

| コマンド | 終了コード | 結果 |
|---|---|---|
| `just rspec-backend spec/services/product_monitoring/sites/janpara_spec.rb spec/services/product_monitoring/sync_crawl_results_spec.rb` | 0 | 31 examples, 0 failures（変更前は 29 examples, 0 failures。追加 2 例、既存 29 例は変更せず全通過） |
| `just rubocop-backend` | 0 | 363 files inspected, no offenses detected |
| `just rspec-backend` | 0 | 428 examples, 0 failures, 1 pending（`related_products_spec.rb:38` は既存の `xit`） |

失敗したコマンドは無い。skipped は既存の 1 件のみで、この修正と無関係。

## Coverage

行カバレッジの下限は設定していない（bugfix の床は targeted regression と既存 suite の維持）。変更した 2 つの経路は追加した 2 例で通る。カバレッジのレポートは取っていない。

## Real-site verification (NFR3)

Code Generation で実施済み（`code-generation/code-summary.md` の「Real-site verification」）。実物のクローラー（プロキシ経由）で、`ITMCODE=313448` は一覧で `price: nil`・`sold: true`。dev DB の `sold: false` の既存行は `SyncCrawlResults.call` で `sold: true` になり、`updated_at` と `bought_date` は変わらなかった。検証データはロールバックで消した。

## Loop-Back Log

なし。
