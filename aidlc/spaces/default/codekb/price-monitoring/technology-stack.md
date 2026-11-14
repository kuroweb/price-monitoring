# Technology Stack

版はマニフェストと lockfile、Dockerfile の固定指定から写した。lock に無いものは「固定なし」と書く。

| 領域 | 技術 | 版 | 出どころ |
| --- | --- | --- | --- |
| BFF / batch | Ruby | 4.0.4 | `volumes/backend/.ruby-version`、`Gemfile`、`containers/backend/Dockerfile` |
| BFF / batch | Rails | 8.1.4.1 | `volumes/backend/Gemfile.lock` |
| BFF / batch | Sidekiq | 8.1.7 | 同 lock |
| BFF / batch | Puma | 8.0.2 | 同 lock |
| BFF / batch | mysql2 | 0.5.7 | 同 lock |
| BFF / batch | Nokogiri | 1.19.7 | 同 lock（linux 向け） |
| BFF / batch | playwright-ruby-client | 1.62.0 | 同 lock |
| BFF / batch | omniauth_openid_connect | 0.8.0 | 同 lock |
| BFF / batch | Bugsnag | 6.30.0 | 同 lock |
| BFF / batch | datadog | 2.48.0 | 同 lock |
| BFF / batch | RuboCop | 1.92.2 | 同 lock |
| BFF / batch | rspec-rails | 8.0.4 | 同 lock |
| BFF イメージ内 Node | Node.js | 20.0.0 | `containers/backend/Dockerfile` の `n 20.0.0` |
| BFF イメージ内 Python | curl_cffi | 固定なし | 同 Dockerfile の `pip install curl_cffi` |
| Frontend | Node イメージ | `node:26` | `containers/frontend/Dockerfile` |
| Frontend | Next.js | 16.4.5 | `volumes/frontend/package.json` |
| Frontend | React / react-dom | 19.3.1 | 同 |
| Frontend | TypeScript | 5.9.3 | 同 |
| Frontend | Tailwind CSS | 4.3.4 | 同 |
| Frontend | daisyUI | 5.7.50 | 同 |
| Frontend | Vitest | 5.1.0 | 同 |
| Frontend | ESLint | 10.14.0 | 同 |
| Auth Provider | Ruby | 3.2.2 | `volumes/auth-provider/.ruby-version` |
| Auth Provider | Rails | 8.1.4.1 | `volumes/auth-provider/Gemfile.lock` |
| Auth Provider | Devise | 5.0.4 | 同 lock |
| Auth Provider | Doorkeeper | 5.9.9 | 同 lock |
| Auth Provider | doorkeeper-openid_connect | 2.1.0 | 同 lock |
| ブラウザ | Playwright サーバー | 1.62.0 | `containers/backend_playwright/Dockerfile` |
| ブラウザ | Python | 3.12 | `containers/backend_camoufox/Dockerfile` |
| ブラウザ | Camoufox | 0.5.8 | 同 Dockerfile |
| データ | MySQL | `mysql/mysql-server:8.0` | `docker-compose.yml` |
| データ | Redis | `redis:latest` | 同。タグは latest のまま |
| 実行 | Docker Compose / just | Compose ファイルと `justfile` | ローカル |
| 本番 | Kubernetes / ArgoCD | クラスタ構成は README。マニフェストは別リポジトリ | `docs/cicd/index.md` |

テストは実行していない。ここに書いた版はファイル上の指定である。
