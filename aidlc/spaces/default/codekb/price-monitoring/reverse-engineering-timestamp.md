# Reverse Engineering Timestamp

## Run Record

- Date: 2026-11-14
- Commit: efe22f77306b1398dfdc6acb5af4b547b83334ef

## Scope of Analysis

```yaml
scope_version: 1
kind: partial
intent: iosys-sold-out
fingerprint: aec7581786c92374517b2bf673b0a7e6b347a171
analyzed:
  paths:
    - volumes/backend/app/services/product_monitoring/sync_crawl_results.rb
    - volumes/backend/app/services/product_monitoring/sites/iosys.rb
    - volumes/backend/app/services/product_monitoring/sites/janpara.rb
    - volumes/backend/app/services/product_monitoring/crawler.rb
    - volumes/backend/app/services/product_monitoring/detail_candidates.rb
    - volumes/backend/spec/services/product_monitoring/sync_crawl_results_spec.rb
    - volumes/backend/spec/services/product_monitoring/sites/iosys_spec.rb
  components:
    - Product Monitoring
shallow:
  paths:
    - ./
```
