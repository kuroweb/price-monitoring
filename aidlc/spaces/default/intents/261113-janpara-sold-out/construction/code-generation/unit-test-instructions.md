# Unit Test Instructions

## Framework

RSpec。既存の `volumes/backend/spec/services/product_monitoring/sync_crawl_results_spec.rb` に足す。新しい設定ファイルは作らない。

## Command

この変更のテストだけを実行する。リポジトリルートで、`backend` コンテナ経由の just を使う。

```bash
just rspec-backend spec/services/product_monitoring/sync_crawl_results_spec.rb
```

プロジェクト全体の `just rspec-backend` は、この段階の合否には使わない。Build and Test が既存スイートの緑を見る。

## Expected coverage targets

Minimal。要件 FR1、FR1.1、FR1.2、FR1.3 に 1 例ずつ。対象コンポーネント `ProductMonitoring::SyncCrawlResults` の正常系は FR1 の例が兼ねる。行カバレッジの下限は、このスコープには無い。プロジェクト全体のカバレッジ閾値は変えない。

## Mocking

検索取得は、既存スペックと同じく `ProductMonitoring::Crawler` を差し替える。データベースの商品計測結果は作る。じゃんぱらのページは取得しない。

## Test data

このスペックの商品計測設定に、じゃんぱらの `ProductCrawlResult` を足す。`updated_at` は 3 時間より前と、3 時間未満の 2 通り。他サイトの行を 1 件置き、この処理が触らないことを FR1 の例で見る。
