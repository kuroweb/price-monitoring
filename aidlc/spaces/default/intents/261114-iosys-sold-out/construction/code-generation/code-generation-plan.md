# コード生成計画

## Summary

- Builds: イオシスの検索消失・再出現に伴う販売状態の同期
- Touches: backend の商品計測同期処理、RSpec、商品計測の文書
- Tests: 要件を網羅する6件以上の回帰・境界テストと既存テスト

## 実施手順

- [x] Step 1: Compose の稼働状態と既存 RSpec 設定を確認し、変更前の backend テストを実行する。（NFR2）
- [x] Step 2: `volumes/backend/app/services/product_monitoring/sync_crawl_results.rb` で既存じゃんぱらの判定を共有し、イオシスにも適用する。取得成功条件、検索結果の存在判定、3時間の基準、更新対象の設定とサイトを維持する。（FR1–FR4、NFR1）
- [x] Step 3: `volumes/backend/spec/services/product_monitoring/sync_crawl_results_spec.rb` に消失、再出現、価格なし、失敗、対象外、境界時刻の検証を追加し、対象テストを実行する。（FR1–FR4、NFR1、NFR2）
- [x] Step 4: `docs/backend/product-monitoring-poc.md` の販売状態に関する説明を更新し、変更結果と要件の対応を記録する。（FR1–FR4）
- [x] Step 5: backend の既存テストと必要な lint を実行する。（NFR2）

既存のモデル・列・API・設定に変更は加えない。影響範囲は商品計測結果の保存と販売中の商品表示で、監視通知の設定は変更しない。

## Testing Contract

```json
{
  "version": 1,
  "methodology": "test-after",
  "source": "org",
  "ordering": "implement each applicable testable layer, then write and run that layer's tests.",
  "scope": "express",
  "test_strategy": "minimal",
  "project_type": "brownfield",
  "applicable_notes": [
    {
      "layer": "org",
      "text": "We treat tests as a first-class deliverable in every Bolt. The specific\nmethodology (TDD, BDD, ATDD, or classic test-after) is affirmed at\npractices-discovery and recorded in `team.md` under this heading with explicit\n`Methodology` and `Ordering` fields; Code Generation resolves those fields\nindependently from coverage, tooling, and scope notes.\n\nWhen no posture has been affirmed, our default per scope is:\n- **Methodology**: test-after\n- **Ordering**: implement each applicable testable layer, then write and run\n  that layer's tests.\n- `mvp`, `enterprise`, `feature`, `infra` add an 80% line-coverage\n  floor and CI execution before merge.\n- `bugfix`, `security-patch` add a targeted regression for the specific\n  bug/vulnerability and require the existing suite to remain green.\n- `express` uses the Minimal strategy: requirement-driven unit tests (one per\n  requirement, with a happy-path floor per component); existing tests remain\n  green.\n- `poc`, `refactor`, `workshop`, `classic` add no extra new-test floor and require the\n  existing suite to remain green.\n\nThe active `Test Strategy` still applies in every scope and determines test\nvolume/types. Scope floors are additive; they never reduce or replace the\nselected strategy.\n\nBuild and Test verifies defined coverage floors and affirmed quality targets;\nthey may not be weakened to make a step pass.\n\nAffirm a stricter posture in `team.md` if the team commits to one."
    },
    {
      "layer": "project",
      "text": "- 検証は [テスト手順](../../../../docs/development/testing.md) に従い、変更範囲に応じて選ぶ。失敗時は対象だけを再実行し、依存サービスの状態を確認する。\n- アプリの起動・テストと依存関係の更新は、Compose service 経由で実行する（[AGENTS.md](../../../../AGENTS.md#コマンドの実行場所)）。"
    }
  ],
  "obligations": {
    "strategy": "minimal",
    "strategy_volume": [
      "One verifiable test per requirement at the narrowest effective level.",
      "At least one happy-path unit test per component.",
      "Unit tests are the default; a bugfix/security scope floor may require an integration or E2E regression when that is the narrowest level that reproduces the defect."
    ],
    "scope_floor": [
      "Keep the existing test suite green.",
      "This scope adds no extra new-test floor beyond the selected test strategy."
    ],
    "combination_rule": "Apply every selected-strategy obligation and every scope-floor obligation; neither replaces the other, and a targeted scope regression may add the narrowest necessary test type beyond the strategy default."
  },
  "plan_profile": {
    "methodology": "test-after",
    "runner_step": "Verify the existing test runner/configuration and record the exact unit-scoped command.",
    "runner_ready_before_first_test": true,
    "testable_layers": [
      "Data model / database behavior",
      "Repository / data access",
      "Business logic",
      "API / endpoint",
      "Frontend behavior"
    ],
    "steps": [
      "Project structure and production configuration skeleton.",
      "Verify the existing test runner/configuration and record the exact unit-scoped command.",
      "Data model / database behavior - implement.",
      "Data model / database behavior - write and run its tests after implementation.",
      "Repository / data access - implement.",
      "Repository / data access - write and run its tests after implementation.",
      "Business logic - implement.",
      "Business logic - write and run its tests after implementation.",
      "API / endpoint - implement.",
      "API / endpoint - write and run its tests after implementation.",
      "Frontend behavior - implement.",
      "Frontend behavior - write and run its tests after implementation.",
      "Environment/build configuration.",
      "Documentation and traceability."
    ]
  },
  "input_sha256": "sha256:12d4a578c38dbed12422869423fc8760efa08baa9a7b722268be225be154c167",
  "contract_sha256": "sha256:e2efbd0c6712ae60bcd1df0d3c5ed27d3949da3f605899bb20d12af5c63f1ebf"
}
```
