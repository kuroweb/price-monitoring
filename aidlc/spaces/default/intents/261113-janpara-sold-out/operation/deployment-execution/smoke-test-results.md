# スモークテスト

デプロイ後の確認はしていない。クラスタへ出していないためである。

マージ前の確認は、`aidlc/spaces/default/intents/261113-janpara-sold-out/construction/build-and-test/test-results.md` に記録したローカルの RSpec である。

| コマンド | 結果 |
| --- | --- |
| `just rspec-backend spec/services/product_monitoring/sync_crawl_results_spec.rb` | 25 examples, 0 failures |
| `just rspec-backend` | 425 examples, 0 failures, 1 pending |

これはデプロイ後のスモークではない。出したあとの確認は、既存の CD のあと、商品モニタリングの販売中一覧を見る。
