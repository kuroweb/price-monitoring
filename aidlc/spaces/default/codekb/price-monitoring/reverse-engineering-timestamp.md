# Reverse Engineering Timestamp

## Run Record

- Date: 2026-11-13T16:14:50Z
- Commit: 3b6af687d72f70afdb499c75aaa19474bfd31938

## Scope of Analysis

```yaml
scope_version: 1
kind: full
intent: janpara-sold-out
fingerprint: bcd35c7413a5adf9e1247b46905fb5749058b3c3
analyzed:
  paths:
    - ./
  components:
    - Frontend
    - Backend
    - Auth Provider
    - Nginx
    - Datastores
    - Batch Browsers
    - Product Monitoring
shallow:
  paths:
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
