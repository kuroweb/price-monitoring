# Dependabot による依存関係の更新

開発・運用担当者向けに、Dependabot による依存関係の更新の対象と除外を解説する。

[dependabot.yml](../../../.github/dependabot.yml) をデフォルトブランチの `master` に配置すると、以下の依存関係を週次で確認し、更新する Pull Request を `master` 向けに作成する。

| 対象 | 依存関係ファイル |
| --- | --- |
| バックエンド | `volumes/backend/Gemfile` / `Gemfile.lock` |
| 認証アプリ | `volumes/auth-provider/Gemfile` / `Gemfile.lock` |
| Frontend | `volumes/frontend/package.json` / `package-lock.json` |
| GitHub Actions | `.github/workflows/*.yml` |

マイナー・パッチ更新は対象ごとに一つの Pull Request にまとめ、メジャー更新は個別に作成する。通常のバージョン更新で同時に開く Pull Request は、各対象で最大 5 件とする。この上限と週次スケジュールはセキュリティ更新の実行頻度・件数を制御するものではない。

バックエンドと認証アプリ の更新では「[Pull Request の自動テスト](pipeline.md#pull-request-の自動テスト)」に従って RuboCop と RSpec が動き、Frontend の更新では lint・型検査・Vitest が動く。ローカルでの確認は [テスト手順](../testing.md)を参照する。Dependabot の更新 PR も「[PR の自動レビュー](code-review.md)」の対象となる。

Docker イメージと Dockerfile 内の `npm install` / `pip install` は、この設定の対象に含めない。Playwright のクライアントとサーバーはメジャー・マイナーバージョンを揃える必要がある ([公式仕様](https://playwright.dev/docs/api/class-browsertype))。そのため `playwright-ruby-client` のメジャー・マイナー更新は Dependabot の対象から除外し、サーバーと合わせて手動で更新する。Camoufox 0.5.8 は Playwright 1.63 未満を要求するため ([依存要件](https://pypi.org/project/camoufox/0.5.8/))、更新時は `containers/backend_playwright/**` と `containers/backend_camoufox/**` の指定、および `ProductMonitoring::Crawling::Client` / `Crawl::CamoufoxClient` の接続APIを合わせて確認する。これらのイメージには独立したCIジョブがないため、各Dockerfileのビルドと両方の接続確認を行う。

Frontend の `typescript` は 7 系への更新を Dependabot の対象から除外する。typescript-eslint が TypeScript 7 に対応しておらず、7 系では lint が動かないためである。typescript-eslint の peer の範囲に 7 系が入ったら除外を外して更新する。

Dependabot alerts とセキュリティ更新 PR の自動作成は、GitHub のリポジトリ設定で別途有効化する。設定項目の意味は [GitHub の公式資料](https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-options-reference)を参照する。
