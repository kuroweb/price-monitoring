# Build and Test Summary

前提は `aidlc/spaces/default/intents/261113-janpara-sold-out/construction/code-generation/code-generation-plan.md`、実行コマンドは `aidlc/spaces/default/intents/261113-janpara-sold-out/construction/code-generation/unit-test-instructions.md`、実装の要約は `aidlc/spaces/default/intents/261113-janpara-sold-out/construction/code-generation/code-summary.md`。

## 状態

ビルドは不要。テストは実行済み。デプロイはこの段階の範囲外。

## テストの種類

Minimal。追加の結合・性能・セキュリティ手順は作っていない。単体に相当するサービススペックは Code Generation が書いた。

## カバレッジ

行カバレッジの下限は無い。

## Target Verification Matrix

| Target ID | Source | Expected | Actual | Evidence | Owning Stage | Verdict |
| --- | --- | --- | --- | --- | --- | --- |
| T-NFR1 | `requirements.md` NFR1 | FR1、FR1.1、FR1.2、FR1.3 を自動テストで区別する | 25 examples, 0 failures。そのうち 4 例が境界 | `just rspec-backend spec/services/product_monitoring/sync_crawl_results_spec.rb` | build-and-test | Met |
| T-SUITE | bugfix の既存スイート | backend の RSpec が失敗しない | 425 examples, 0 failures, 1 pending | `just rspec-backend` | build-and-test | Met |
| T-CI | CI でテストをマージ前に実行する | この計画は CI Pipeline を実行しない | 該当なし | `aidlc-state.md` の ci-pipeline は SKIP | ci-pipeline | N/A |

理由: the plan runs no CI Pipeline。

## 準備

テスト可能。画面の挙動は見ていない。
