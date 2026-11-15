# Reverse Engineering Timestamp

## Run Record

- Date: 2026-11-14
- Commit: efe22f77306b1398dfdc6acb5af4b547b83334ef

## Scope of Analysis

```yaml
scope_version: 1
kind: partial
intent: janpara-listed-sold
fingerprint: b115e7d0189859b38169b29e7b0919923a0ae93d
analyzed:
  paths:
    - volumes/backend/app/services/product_monitoring/sites/janpara.rb
    - volumes/backend/app/services/product_monitoring/sync_crawl_results.rb
    - volumes/backend/app/services/product_monitoring/detail_candidates.rb
    - volumes/backend/app/services/product_monitoring/crawler.rb
    - volumes/backend/app/services/product_monitoring/url_router.rb
    - volumes/backend/app/services/product_monitoring/filter.rb
    - volumes/backend/app/services/product_monitoring/cleanse_crawl_results.rb
    - volumes/backend/app/services/product_monitoring/lowest_listings.rb
    - volumes/backend/app/services/product_monitoring/sites/iosys.rb
    - volumes/backend/app/services/product_monitoring/sites/treasure_factory.rb
    - volumes/backend/app/services/product_monitoring/sites/yahoo_auction.rb
    - volumes/backend/app/services/product_monitoring/sites/browser_page.rb
    - volumes/backend/app/services/product_monitoring/sites/pagination.rb
    - volumes/backend/spec/services/product_monitoring/sites/janpara_spec.rb
    - volumes/backend/spec/services/product_monitoring/sync_crawl_results_spec.rb
    - volumes/backend/spec/services/product_monitoring/url_router_janpara_spec.rb
    - volumes/backend/spec/services/product_monitoring/crawler_spec.rb
    - docs/backend/product-monitoring-poc.md
  components:
    - Product Monitoring
shallow:
  paths:
    - ./
    - volumes/backend/app/services/product_monitoring/
    - volumes/backend/spec/services/product_monitoring/
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
