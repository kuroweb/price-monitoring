# Build and Test Summary

じゃんぱらの SOLD OUT 表示を売り切れとして反映する修正（ゼロ Unit の bugfix、Test Strategy は Minimal）。入力は `code-generation/code-generation-plan.md`、`unit-test-instructions.md`、`code-summary.md`。

## Overall status

- ビルド: 成功（RuboCop 363 ファイル・指摘なし）
- テスト: 対象 spec 31 例・0 失敗、バックエンド全体 428 例・0 失敗・1 pending（既存の `xit`）
- 実サイト確認: 完了（Code Generation で実施。`test-results.md` に結果）

## Test type inventory

- Minimal strategy のため、追加のテスト指示ファイル（integration / performance / security）は作っていない。
- 単体の回帰テストは Code Generation で 2 例を追加済み（取得側 1・保存側 1）。

## Coverage expectations

- 行カバレッジの下限は設定していない。bugfix の床（targeted regression と既存 suite の維持）を、追加した 2 例と全体 suite の通過で満たす。

## Target Verification Matrix

| Target ID | Source | Expected | Actual | Evidence | Owning Stage | Verdict |
|---|---|---|---|---|---|---|
| TC-REGRESSION | Testing Contract の scope floor（`code-generation-plan.md`）、NFR2 | バグを再現する targeted regression がある | 取得側 1 例・保存側 1 例。レビューで、修正前のコードでは失敗することを確認済み | `sites/janpara_spec.rb`、`sync_crawl_results_spec.rb` | build-and-test | Met |
| TC-SUITE-GREEN | Testing Contract の scope floor、NFR1 | 既存の suite が通ったままである | 428 examples, 0 failures, 1 pending（既存の `xit`） | `test-results.md` の `just rspec-backend` | build-and-test | Met |
| TC-STRATEGY-MINIMAL | Testing Contract の strategy（minimal） | 要件ごとに最も狭い層で検証できる 1 件のテスト | FR1・FR2 は追加 2 例、FR3 は既存の「じゃんぱらの売り切れ」の例、FR4 は文書で確認（テスト対象外） | `unit-test-instructions.md` の対応表、`cross-unit-traceability.md` | build-and-test | Met |
| NFR3 | `requirements.md` の NFR3 | 実例 `ITMCODE=313448` が実物のクローラーで `sold: true`・`price: nil` になる | 一覧で `price: nil`・`sold: true`。保存まで通すと `sold: true`、`updated_at`・`bought_date` 不変 | `code-generation/code-summary.md`、`test-results.md` | build-and-test | Met |
| NFR4 | `requirements.md` の NFR4 | テストと RuboCop を Docker Compose 内で実行する | すべて `docker compose exec backend` 経由（`just` レシピ） | `test-results.md` のコマンド列 | build-and-test | Met |
| CI | Testing Contract の CI 義務 | 計画が CI Pipeline を実行する場合のみ | この計画は CI Pipeline を実行しない | `aidlc-state.md`（ci-pipeline はスキップ） | - | N/A |

## Readiness assessment

- build-ready: はい
- test-ready: はい
- deployment-ready: 対象外。デプロイ系のステージは、依頼でスコープから外した。

## Known limitations or outstanding items

- 同じ `external_id` が 1 回の取得で `sold: true` と `sold: false` の両方で返る場合の順序（`true` の後に `false`）を固定するテストは無い（Code Generation のレビュー R-01、リスクとして承認済み）。
- 結果に `sold` キーが無い（nil の）場合は、新実装では何も更新しない。現行の経路では起きない（同 R-02）。
- `docs/backend/product-monitoring-poc.md` の「個別の店舗在庫や販売状態は確認しない」は残っている。「個別」と限定されているため誤りではないが、追加項目と並ぶと矛盾して見える可能性がある（同 R-03）。
- ブランチは `kuroweb/janpara-listed-sold`。コミットと PR 作成はまだ行っていない。PR #186（イオシス修正）とは混ぜていない。
