# Code Generation Plan: じゃんぱらの SOLD OUT 表示を売り切れとして反映する

## Summary

- Builds: じゃんぱらの一覧の SOLD OUT 表示を `sold: true` として読み取り、検索結果にある既存行へ価格なしでも売り切れを反映する修正
- Touches: `volumes/backend/app/services/product_monitoring/sites/janpara.rb`、`sync_crawl_results.rb`、対応する 2 つの spec、`docs/backend/product-monitoring-poc.md`
- Tests: 回帰テスト 2 件（取得側 1・保存側 1）。既存のじゃんぱら関連 spec は変更せず通ったままにする

## Scope and Approach

- ゼロ Unit の bugfix。Unit 分割はしない。作業ブランチは `kuroweb/janpara-listed-sold`（基点 `master`）。
- 基点にはイオシス修正（PR #186）が入っていない。そのため、この基点の `sync_janpara_sold` を直す。イオシス側で一般化された保存処理は持ち込まない。
- 他の作業ツリー（`iosys-sold-out`）で調査済みの修正は、考え方（一覧で `.search_nostock` を読む、保存で `sold` の値ごとに更新する）だけを参考にし、この基点のコードに合わせて書く。
- データモデルの変更は無い。テーブル・列・インデックスの追加は無く、`## Assumptions` は無い。

## Steps

- [x] Step 1: 既存のテスト実行環境を確認し、Unit 範囲の実行コマンドを記録する（Docker Compose の `backend` コンテナ。起動していなければ `just up`）。変更前に対象 spec を一度実行して基準を取る。（NFR1、NFR4）
- [x] Step 2: 取得（一覧の解釈）を実装する。`volumes/backend/app/services/product_monitoring/sites/janpara.rb` の `Janpara.listing` で、`sold` を固定の `false` ではなく `dom.at_css(".search_nostock").present?` にする。価格要素が無い SOLD OUT は、既存の `listing_price` が nil を返すので、そのまま `price: nil`・`sold: true` で返る。（FR1.1、FR1.2、FR1.3）
- [x] Step 3: 取得の回帰テストを書いて実行する。`volumes/backend/spec/services/product_monitoring/sites/janpara_spec.rb` に、価格のない `.search_nostock` の一覧が `external_id: "ITMCODE=313448"`・`price: nil`・`sold: true` になる例を足す。（NFR2(a)、FR1）
- [x] Step 4: 保存（検索結果にある既存行の更新）を実装する。`volumes/backend/app/services/product_monitoring/sync_crawl_results.rb` の `sync_janpara_sold` で、検索に返った行を結果の `sold` に関係なく `false` にしている処理（102 行）を、返った結果の `sold` の値ごとに既存行を `update_all(sold:)` する処理に置き換える。入力は従来どおり `crawled[:results]` の全件（価格なし・条件不一致・除外済みを含む）で、`updated_at`・`bought_date`・他サイトの行・他の設定の行は変えない（`update_all` は `updated_at` を触らず、`scope` は設定とサイトで絞られている）。`sell_out_missing_janpara` 以降（検索から消えた出品の売り切れ化、3 時間、取得元の全成功の条件）は変更しない。（FR2.1、FR2.2、FR2.3、FR2.4、FR2.5、FR3.1、FR3.2）
- [x] Step 5: 保存の回帰テストを書いて実行する。`volumes/backend/spec/services/product_monitoring/sync_crawl_results_spec.rb` の `describe "じゃんぱらの売り切れ"` に、価格なしで `sold: true` の結果が既存行を即時に売り切れにし、`updated_at`・`bought_date`・他サイトの同じ `external_id` の行を変えない例を足す。既存の「検索結果にある売却済みの行を販売中へ戻す」例（`bought_date` を保持）は変更せず通ることを確認する。（NFR2(b)、NFR1、FR2）
- [x] Step 6: 文書を更新する。`docs/backend/product-monitoring-poc.md` で、(a) イオシス・じゃんぱら・トレファクを一覧にある出品を販売中とする記述から、じゃんぱらを分け、じゃんぱらは一覧の売り切れ表示を反映すると書く。(b) 検索から消えたイオシス・じゃんぱらの売り切れ化の記述に、検索に残る売り切れ表示は価格がなくても既存の出品に反映することを書く。他サイトの記述は変えない。確認方法は、該当の 2 箇所に記述があること。（FR4.1、FR4.2）
- [x] Step 7: 静的検証と対象 spec を Docker Compose 内で実行する。`just rubocop-backend` と、`unit-test-instructions.md` の対象 spec。失敗したら対象だけを再実行し、既存の例は緩めない。（NFR1、NFR4）
- [x] Step 8: コード要約とトレーサビリティを書く。`code-summary.md` と `traceability.json`。実サイトでの確認（NFR3）は、プロキシ経由の実物のクローラーで、Build and Test で行う。（NFR3、NFR5）

## Requirement Traceability

| 要件 | 計画の Step |
|---|---|
| FR1.1、FR1.2、FR1.3 | Step 2、Step 3 |
| FR2.1、FR2.2、FR2.3、FR2.4、FR2.5 | Step 4、Step 5 |
| FR3.1、FR3.2 | Step 4（変更しないことを Step 5・Step 7 の既存 spec で確認） |
| FR4.1、FR4.2 | Step 6 |
| NFR1 | Step 1、Step 5、Step 7 |
| NFR2 | Step 3、Step 5 |
| NFR3 | Step 8（実行は Build and Test） |
| NFR4 | Step 1、Step 7 |
| NFR5 | Step 2、Step 4、Step 6（変更はこの範囲に閉じる） |

## Risks

- SOLD OUT の DOM は、依頼文の `.search_nostock` と実例が根拠で、リポジトリに fixture が無い。実サイトの確認（NFR3）で、SOLD OUT のときに価格が表示されるかも確かめる。表示される場合は価格付きの `sold: true` として返り、通常の保存経路でも売り切れになる。
- 同じ `external_id` が 1 回の取得で `sold: true` と `sold: false` の両方で返る場合の優先は、今回は決めない（範囲外）。実装は `sold` の値ごとの更新で、`true` の後に `false` を適用する。

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
