# Reverse Engineering Timestamp

## Run Record

- Date: 2026-11-15
- Commit: e5ea867202290921aacf91e98ddeb78ea8d5abb4

## Scope of Analysis

```yaml
scope_version: 1
kind: partial
intent: measurement-refactoring
fingerprint: 88782c714cea1c07356584896640a4aeefbff16f
analyzed:
  paths:
    - volumes/backend/app/services/product_monitoring/crawler.rb
    - volumes/backend/app/services/product_monitoring/sync_crawl_results.rb
    - volumes/backend/app/services/product_monitoring/detail_candidates.rb
    - volumes/backend/app/services/product_monitoring/filter.rb
    - volumes/backend/app/services/product_monitoring/input.rb
    - volumes/backend/app/services/product_monitoring/url_router.rb
    - volumes/backend/app/services/product_monitoring/aggregation_purchases.rb
    - volumes/backend/app/services/product_monitoring/sites/janpara.rb
    - volumes/backend/app/services/product_monitoring/sites/iosys.rb
    - volumes/backend/app/sidekiq/product_monitoring/crawl_detail_job.rb
    - volumes/backend/spec/services/product_monitoring/crawler_spec.rb
    - volumes/backend/spec/services/product_monitoring/sync_crawl_results_spec.rb
    - docs/features/product-monitoring/index.md
  components:
    - Product Monitoring
shallow:
  paths:
    - ./
    - volumes/backend/app/services/product_monitoring/cleanse_crawl_results.rb
    - volumes/backend/app/services/product_monitoring/lowest_listings.rb
    - volumes/backend/app/services/product_monitoring/sites/treasure_factory.rb
    - volumes/backend/app/services/product_monitoring/sites/yahoo_auction.rb
    - volumes/backend/app/services/product_monitoring/sites/browser_page.rb
    - volumes/backend/app/services/product_monitoring/sites/pagination.rb
    - volumes/backend/spec/services/product_monitoring/sites/janpara_spec.rb
    - volumes/backend/spec/services/product_monitoring/url_router_janpara_spec.rb
    - docs/backend/product-monitoring-poc.md
    - volumes/backend/app/services/crawl/
    - volumes/backend/app/models/
    - volumes/backend/app/sidekiq/crawl/
    - volumes/frontend/features/products/
    - volumes/frontend/features/categories/
    - volumes/frontend/features/backmarket/
    - volumes/frontend/features/auth/
    - volumes/auth-provider/app/
    - docs/development/
    - .github/workflows/
```
