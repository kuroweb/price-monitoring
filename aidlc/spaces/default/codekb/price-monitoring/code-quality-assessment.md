# Code Quality Assessment

> この文書は調査時点の記録であり、その後の販売状態同期の変更を反映していない。現行動作は `docs/backend/product-monitoring-poc.md` を参照する。

評価は、商品計測の販売状態と、その周囲で開いたファイルに限る。三点は good / fair / poor。

| 観点 | 評価 | 根拠 |
| --- | --- | --- |
| Naming clarity | good | `sold`、`fetch_detail`、`DetailCandidates`、`sync_janpara_sold`、サイトクラス名が処理と対応する |
| Function size | fair | サイトクラスと `SyncCrawlResults` の upsert SQL は長い。`routes.rb` は `Metrics/BlockLength` を無効にしている。`SyncCrawlResults` の各メソッドは短い |
| Error handling | fair | クロール失敗は source を `failed` にする。サイトの DOM が読めないときは例外で失敗にし、成功したような結果で置き換えない。詳細が `sold` を返せないときは状態を変えない。API の未捕捉は 503。プロキシが無いときの失敗は文書どおり |
| Test presence | fair | `janpara_spec.rb`（3 例）は一覧の `sold: false` を期待し、売り切れ表示の DOM を使う例は無い。`sync_crawl_results_spec.rb` の `describe "じゃんぱらの売り切れ"`（5 例）は、消えた行の売り切れ化、source 無し・失敗・3 時間未満での非実行、検索に残る売却済みの行を販売中へ戻すことを固定する。`crawl_detail_job_spec.rb` はメルカリと Yahoo!フリマの個別確認を持つ |
| Duplication | fair | プラットフォームごとの従来 `Crawl::*` と、商品計測の `Sites::*` が併存する。売り切れ化の待ち時間と判定が `DetailCandidates` と `SyncCrawlResults` の 2 か所にある |
| Dead code | fair | 未使用の全件探索はしていない。`require_login` は定義だけで、開いたコントローラからは呼ばれていない |

## テストと Lint

- Backend の商品計測 spec は `volumes/backend/spec/services/product_monitoring` と `spec/sidekiq/product_monitoring`、request spec は `spec/requests/product_crawl_settings_spec.rb` ほか
- Frontend は Vitest。coverage 対象は `features`、`components`、`lib`（`vitest.config.mts`）
- CI は変更パスに応じて RuboCop、RSpec、Frontend の lint・型・Vitest をコンテナで実行する（`docs/cicd/index.md`）。Playwright と Camoufox の独立ジョブは無い
- このスキャンではテストも lint も実行していない

### じゃんぱらの spec で固定されていること

- 検索結果にあるじゃんぱらは売却済みでも `sold: false` に戻り、`bought_date` は残る（`sync_crawl_results_spec.rb` の「検索結果にあるじゃんぱらは売却済みでも販売中に戻すこと」）。結果の `sold` は `false` で与えている
- 価格なしで検索に残るじゃんぱらの既存行は `sold: false` のまま残り、検索から消えた行だけが `sold: true` になる
- 他サイトの行はじゃんぱらの取得で変わらない
- じゃんぱらの source が無い、別サイトの source だけ、失敗した、最終更新から 3 時間未満、のいずれでも売り切れにしない

### 空白（開いた spec に無いもの）

- 検索結果の出品が `sold: true` で、`save_matched` と `sync_janpara_sold` が組み合わさったときの最終状態
- 一覧の売り切れ表示（`.search_nostock` など）を `sold: true` に変える解析と、その DOM を使った `Sites::Janpara` の例
- 売り切れで価格が表示されない出品の扱い
- じゃんぱらの source が複数あり一部だけ失敗する場合、除外済みの行が検索から消えた場合、5 ページ上限を超えた出品

## 文書

`docs/backend/product-monitoring-poc.md` は、じゃんぱらを「一覧にある出品を販売中とし、売れた日は取得しない」（37 行）、「個別の店舗在庫や販売状態は確認しない」（46 行）と書く。コードの `sold: false` 固定、`fetch_detail` の不在、および検索に返った行を `false` に戻す処理と一致する。一方、検索から消えたじゃんぱらの行を、取得が成功したときに売り切れにする処理（`sync_janpara_sold`）は、39 行の「取得元が失敗しても…一覧から消えた出品は…確認する」（個別確認の説明）を含め、どこにも書かれていない。`docs/database/index.md` は同じテーブル群をまだ載せていない。

## 技術的負債

- じゃんぱらの `sold` が、一覧の `sold: false` 固定と、保存側 `sync_janpara_sold` の「検索への出現だけで販売中、消失だけで売り切れ」という 2 段構えで決まる。検索に出たままの売り切れ表示は、どちらでも拾えない
- `sync_janpara_sold` は、`save_matched` が価格 nil で捨てた結果も「検索に返った」とみなす。価格が出ない出品は既存行が `false` のまま残る
- 1 URL 5 ページ・500 件の上限と、取得 `succeeded` の判定が結びついていない。上限で返らなかったじゃんぱらの出品が、売り切れ化の対象になり得る
- 同じ「`fetch_detail` が無い」グループにイオシスとトレファクがある。この 2 サイトには、検索から消えた行を売り切れにする処理が無い。トレファクは売り切れ DOM を保存しない
- `.rubocop_todo.yml` が残っており、`SyncCrawlResults` も対象に含まれる
- Sidekiq Web の本番 Basic 認証は TODO のまま
- 管理 API に会員単位の認可が無いことは、認証文書が既に書いている
