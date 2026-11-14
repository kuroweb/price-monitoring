# Test Results

## Build

`just ps` で `backend` は Up。コンパイルは無い。

## Unit tests

コマンド: `just rspec-backend spec/services/product_monitoring/sync_crawl_results_spec.rb`

終了コード: 0

25 examples, 0 failures。所要 0.48404 秒（読み込み 3.27 秒）。

## Existing suite

コマンド: `just rspec-backend`

終了コード: 0

425 examples, 0 failures, 1 pending。pending は `RelatedProducts#errors` の既存の `xit`。所要 20.81 秒（読み込み 2.57 秒）。

## Coverage

このスコープに行カバレッジの下限は無い。カバレッジコマンドは実行していない。
