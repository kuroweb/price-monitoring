# ビルドとテストの結果

backend の全 RSpec は 444 件中失敗 0、既存の保留 1 件。対象 RSpec と RuboCop も成功。新しいサイト別判定の spec と既存の状態遷移・API・ジョブの spec を実行した。画像ビルドは成功したが nginx はポート競合で起動せず、画面経由の検証はしていない。

## Target Verification Matrix

| Target ID | Source | Expected | Actual | Evidence | Owning Stage | Verdict |
| --- | --- | --- | --- | --- | --- | --- |
| T1 | code-generation-plan.md / Testing Contract | 既存スイートを維持 | 444 examples、0 failures、1 pending | test-results.md | build-and-test | Met |
| T2 | code-generation-plan.md / Testing Contract | 各要件と新規コンポーネントの正常系を検証 | 6 ID 対応、新規処理に正常系と境界テストあり | cross-unit-traceability.md、test-results.md | build-and-test | Met |
| T3 | requirements.md / NFR2 | 変更前後の対象テストを同じ Compose 環境で実行 | 変更前135件、変更後対象138件はいずれも失敗なし | test-results.md | build-and-test | Met |

数値カバレッジ下限は定められていない。デプロイの可否はこの検証だけでは判断しない。
