# テスト結果

| 検証 | 結果 |
| --- | --- |
| `docker compose exec backend bundle check` | 成功、終了コード 0 |
| `just rspec-backend spec/services/product_monitoring/sync_crawl_results_spec.rb` | 32 examples、0 failures、終了コード 0 |
| 実装後の backend 全体（コード生成時） | 432 examples、0 failures、1 pending |
| 実装前の backend 全体 | 426 examples、0 failures、1 pending |
| 変更した Ruby 2ファイルの RuboCop（コード生成時） | 成功 |

数値のカバレッジ目標は設定されていない。RSpec は crawler をスタブし、DB を使用して同期を検証した。実サイトへの接続は行っていない。nginx は 8444 のポート競合で起動せず、backend・DB・Redis でのテストには影響しなかった。
