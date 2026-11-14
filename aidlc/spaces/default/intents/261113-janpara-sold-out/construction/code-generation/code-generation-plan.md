# Code Generation Plan

## Summary

- Builds: 検索から消えたじゃんぱらの商品計測結果を、条件を満たすときだけ売り切れにする
- Touches: `volumes/backend/app/services/product_monitoring/sync_crawl_results.rb` と、そのスペック
- Tests: 要件 4 件のサービススペック。既存の `sync_crawl_results_spec.rb` に足す

要件は `aidlc/spaces/default/intents/261113-janpara-sold-out/inception/requirements-analysis/requirements.md`。ユーザーストーリーは無い。各ステップは FR / NFR に対応する。

テスト契約は test-after。データモデル、リポジトリ、API、画面は変えない。適用するのは業務ロジックだけである。スキーマも列も足さない。`product_crawl_results.updated_at` の既存の更新規則（内容が同じ再取得では進めない）は変えない。

## Steps

### Step 1. テスト実行の確認（FR1、NFR1）

- [x] 既存の RSpec が、このスペックだけを対象に動くことを確認する
- コマンドは `unit-test-instructions.md` の通り。`just rspec-backend spec/services/product_monitoring/sync_crawl_results_spec.rb`

### Step 2. 業務ロジックを実装する（FR1、FR1.1、FR1.2、FR1.3）

- [x] `ProductMonitoring::SyncCrawlResults#call` で、保存のあと、今回の商品計測設定のじゃんぱら行だけを更新する
- 見る ID は、保存した行ではなく、その取得が返したじゃんぱらの `external_id` である（価格が無く保存しない出品も、検索結果にあるものとして扱う）
- 取得成功は `ProductMonitoring::DetailCandidates` が「そのサイトの取得元が成功した」とみなす条件と同じにする。成功していないときは、欠落を理由に `sold` を変えない（FR1.1）
- 成功していて、この設定のじゃんぱら行の `updated_at` が `DetailCandidates::DETAIL_RECHECK_INTERVAL`（3 時間）以上前で、返した ID に無い行は `sold: true` にする（FR1、FR1.2）。`bought_date` と `updated_at` は代入しない
- 返した ID にある行は `sold: false` にする。すでに `sold: true` の行も戻す（FR1.3）。`Sites::Janpara` が一覧へ `sold: false` を付ける処理は変えない
- イオシス、トレファク、メルカリ、Yahoo!フリマ、ヤフオクの行は、この処理で更新しない
- `fetch_detail` は足さない。`DetailCandidates#enqueue` の対象サイトは変えない

### Step 3. 業務ロジックのテストを書いて実行する（FR1、FR1.1、FR1.2、FR1.3、NFR1）

- [x] `volumes/backend/spec/services/product_monitoring/sync_crawl_results_spec.rb` に、次の 4 例を足して Step 1 のコマンドで実行する
- FR1: じゃんぱらの取得が成功し、行の `updated_at` が 3 時間以上前で、結果に ID が無いと `sold` は `true`
- FR1.1: じゃんぱらの取得が成功していないと、結果に無くても `sold` は変わらない
- FR1.2: 取得は成功し結果に無いが、`updated_at` が 3 時間未満だと `sold` は `true` にならない
- FR1.3: 結果に ID がある行は `sold: false` になる。直前が `true` でも `false` に戻る
- 既存のこのファイルの例は緑のままにする

## Testing Contract

```json
{
  "version": 1,
  "methodology": "test-after",
  "source": "org",
  "ordering": "implement each applicable testable layer, then write and run that layer's tests.",
  "scope": "bugfix",
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
      "Include a targeted regression for the bug or vulnerability.",
      "Keep the existing test suite green."
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
  "input_sha256": "sha256:f5eaf4be027c962b1c56851ee771e3bf92df1b691cc99ac232ab34c539759450",
  "contract_sha256": "sha256:43b9208a32b9c49b067ed4a7b4785f1d1e86aa128ed4bf46c64e1f29ab5cc0c5"
}
```
