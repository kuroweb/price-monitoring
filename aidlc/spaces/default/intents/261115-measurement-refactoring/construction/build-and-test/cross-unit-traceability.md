# 要件と検証の対応

判定: PASS。`aidlc engine sensor-traceability --stage build-and-test` は未対応 0 件。Unit 分割はない。

| ID | 対応先 |
| --- | --- |
| FR1 | `volumes/backend/spec/services/product_monitoring/crawler_spec.rb` |
| FR2 | `volumes/backend/spec/services/product_monitoring/sync_crawl_results_spec.rb` |
| FR3 | `volumes/backend/app/services/product_monitoring/sync_search_sold_status.rb` |
| FR4 | `volumes/backend/spec/requests/product_crawl_settings_spec.rb` |
| NFR1 | `volumes/backend/spec/services/product_monitoring/sites/browser_page_spec.rb` |
| NFR2 | `aidlc/spaces/default/intents/261115-measurement-refactoring/construction/code-generation/code-summary.md` |
