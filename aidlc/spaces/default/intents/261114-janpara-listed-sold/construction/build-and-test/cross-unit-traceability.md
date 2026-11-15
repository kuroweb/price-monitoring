# Cross-Unit Traceability

Verdict: pass（未対応の要件 ID は無い）。ゼロ Unit のため、Unit は `code-generation` の 1 つだけ。入力は `aidlc engine sensor-traceability --stage build-and-test` の出力。

| ID | Covered | 担当 | 対象ファイル |
|---|---|---|---|
| FR1.1 | yes | code-generation | `volumes/backend/app/services/product_monitoring/sites/janpara.rb` |
| FR1.2 | yes | code-generation | `volumes/backend/app/services/product_monitoring/sites/janpara.rb` |
| FR1.3 | yes | code-generation | `volumes/backend/spec/services/product_monitoring/sites/janpara_spec.rb` |
| FR2.1 | yes | code-generation | `volumes/backend/app/services/product_monitoring/sync_crawl_results.rb` |
| FR2.2 | yes | code-generation | `volumes/backend/app/services/product_monitoring/sync_crawl_results.rb` |
| FR2.3 | yes | code-generation | `volumes/backend/spec/services/product_monitoring/sync_crawl_results_spec.rb` |
| FR2.4 | yes | code-generation | `volumes/backend/spec/services/product_monitoring/sync_crawl_results_spec.rb` |
| FR2.5 | yes | code-generation | `volumes/backend/app/services/product_monitoring/sync_crawl_results.rb` |
| FR3.1 | yes | code-generation | `volumes/backend/app/services/product_monitoring/sync_crawl_results.rb` |
| FR3.2 | yes | code-generation | `volumes/backend/app/services/product_monitoring/sync_crawl_results.rb` |
| FR4.1 | yes | code-generation | `docs/backend/product-monitoring-poc.md` |
| FR4.2 | yes | code-generation | `docs/backend/product-monitoring-poc.md` |
| NFR1 | yes | code-generation | `volumes/backend/spec/services/product_monitoring/sync_crawl_results_spec.rb` |
| NFR2 | yes | code-generation | `volumes/backend/spec/services/product_monitoring/sites/janpara_spec.rb` |
| NFR3 | yes | code-generation | `aidlc/spaces/default/intents/261114-janpara-listed-sold/construction/code-generation/code-summary.md` |
| NFR4 | yes | code-generation | `docs/development/testing.md` |
| NFR5 | yes | code-generation | `volumes/backend/app/services/product_monitoring/sync_crawl_results.rb` |

Uncovered: なし。
