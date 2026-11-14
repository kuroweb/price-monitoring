# Cross-Unit Traceability

判定: pass。未カバーの ID は無い。Unit は無い。所有は code-generation。

| ID | Covered | Owning stage | Target file |
| --- | --- | --- | --- |
| FR1.1 | true | code-generation | `volumes/backend/app/services/product_monitoring/sync_crawl_results.rb` |
| FR1.2 | true | code-generation | `volumes/backend/app/services/product_monitoring/sync_crawl_results.rb` |
| FR1.3 | true | code-generation | `volumes/backend/app/services/product_monitoring/sync_crawl_results.rb` |
| NFR1 | true | code-generation | `volumes/backend/spec/services/product_monitoring/sync_crawl_results_spec.rb` |

FR1 は子要件 FR1.1、FR1.2、FR1.3 を通して追跡する。親の行は無い。検索から消えた行を `sold: true` にする例は、同じスペックの FR1 の例である。
