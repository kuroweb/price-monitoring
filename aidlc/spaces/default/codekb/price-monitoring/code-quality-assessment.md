# Code Quality Assessment

評価は、商品計測の販売状態と、その周囲で開いたファイルに限る。三点は good / fair / poor。

| 観点 | 評価 | 根拠 |
| --- | --- | --- |
| Naming clarity | good | `sold`、`fetch_detail`、`DetailCandidates`、サイトクラス名が処理と対応する |
| Function size | fair | サイトクラスと `SyncCrawlResults` の upsert SQL は長い。`routes.rb` は `Metrics/BlockLength` を無効にしている |
| Error handling | fair | クロール失敗は source を `failed` にする。詳細が `sold` を返せないときは状態を変えない。API の未捕捉は 503。プロキシが無いときの失敗は文書どおり |
| Test presence | fair | `janpara_spec.rb` は一覧の `sold: false` を期待する。`sync_crawl_results_spec.rb` と `crawl_detail_job_spec.rb` はメルカリと Yahoo!フリマの個別確認を持つ。検索結果から消えたじゃんぱらの売り切れ・失敗時・再出現を検証する spec がある |
| Duplication | fair | プラットフォームごとの従来 `Crawl::*` と、商品計測の `Sites::*` が併存する |
| Dead code | fair | 未使用の全件探索はしていない。`require_login` は定義だけで、開いたコントローラからは呼ばれていない |

## テストと Lint

- Backend の商品計測 spec は `volumes/backend/spec/services/product_monitoring` と `spec/sidekiq/product_monitoring`、request spec は `spec/requests/product_crawl_settings_spec.rb` ほか
- Frontend は Vitest。coverage 対象は `features`、`components`、`lib`（`vitest.config.mts`）
- CI は変更パスに応じて RuboCop、RSpec、Frontend の lint・型・Vitest をコンテナで実行する（`docs/cicd/index.md`）。Playwright と Camoufox の独立ジョブは無い
- このスキャンではテストも lint も実行していない

## 文書

`docs/backend/product-monitoring-poc.md` は、じゃんぱらを「一覧にある出品を販売中とし、売れた日は取得しない」「個別の店舗在庫や販売状態は確認しない」と書いている。コードの `sold: false` 固定および `fetch_detail` の不在と一致する。`docs/database/index.md` は同じテーブル群をまだ載せていない。

## 技術的負債

- イオシスは一覧から消えたあとも `DetailCandidates` が更新せず、じゃんぱらと異なり専用の売り切れ同期もない
- 同じ「`fetch_detail` が無い」グループにイオシスとトレファクがある。トレファクは売り切れ DOM を保存しない
- `.rubocop_todo.yml` が残っており、`SyncCrawlResults` も対象に含まれる
- Sidekiq Web の本番 Basic 認証は TODO のまま
- 管理 API に会員単位の認可が無いことは、認証文書が既に書いている
