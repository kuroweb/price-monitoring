## Summary

- Builds: 全6サイトの取得後の販売状態判定をサイトの責務に沿って整理
- Touches: backend の商品計測サイトクラス、同期処理、詳細確認候補、関連 spec
- Tests: 各サイトの判定と共通同期・ジョブ境界の RSpec

## 設計の比較

現行でもサイト別の HTML 取得・解析は `Sites` 配下に分かれる。一方で、取得後の一覧からの販売状態反映や消失時の判定は `SyncCrawlResults`、詳細確認候補は `DetailCandidates` にあり、サイト固有の規則と全体調整が混在している。

### A. 設定単位のジョブを維持し、サイト単位の処理を整理する（今回の推奨）

`CrawlJob` と `SyncCrawlResults` は計測設定単位の実行・トランザクション・詳細確認投入を調整する。各サイトの取得と販売状態判定の違いは、それぞれの境界を明確にして整理する。全サイトに同じ処理を強制せず、重複が実際にある判断だけを共通化する。

利点は、失敗時の処理・DB トランザクション・詳細ジョブ上限を維持しながら変更できること。1サイトの取得遅延が後続の取得に影響する現状は残る。

### B. 設定とサイトの組ごとにジョブを分ける（今後の候補）

親処理が設定と検索元を確定し、サイトごとのジョブがそのサイトの全 URL を取得・反映する構成。サイトごとの再試行・監視・並列化が可能になる一方、設定編集との競合、複数サイトの完了判定、重複ジョブ、失敗後の再実行の扱いが必要になる。

イオシス・じゃんぱらの消失判定は当該サイトの全 URL が成功し、いずれも打ち切られていない場合に限る。詳細確認候補は失敗と打ち切りを別の条件で扱い、全サイトで最大50件の選択を維持する。サイト間で取得結果の重複排除が `external_id` 単独で行われる現在の挙動も、変更には別途合意が必要。これらをサイトジョブ間でどう集約・確定するか、親処理の失敗時や Sidekiq 再試行時にどう再開するかは未決定である。既存の設定単位ロックと、手動・定期ジョブの引数差も検証する。

### C. URL ごとにジョブを分ける

URL ごとに再試行できるが、同じサイトの全 URL の成功と打ち切りの集約が別途必要になる。ジョブ数と途中状態が増え、B の論点に加えてページ途中の失敗も扱うため、現時点では採用しない。

候補 B・C を実装する場合は、完了状態の保持方法と障害からの復旧を含む別の計画を提示し、振る舞い・運用・データ構造の変更について合意を得る。現時点で新しいテーブルやジョブを追加しない。

## 対象と境界

全6サイトの取得後処理を確認し、サイトが自身の販売状態の扱いを表し、共通の同期側が特定サイト名を列挙せず調整する構成を目指す。取得、除外、集計、API、DB スキーマとジョブの契約は変更しない。サイトごとの全取得成功・打ち切り・価格なし・3時間境界・再出現の扱いを維持する。サイト横断の ID 衝突や `updated_at` の意味の変更は対象外。

## サイト別の責務と設計

| サイト | 一覧と保存後の扱い | 今回の変更方針 |
| --- | --- | --- |
| イオシス | 一覧は販売中。全取得成功・未打ち切りなら3時間経過した消失行を売り切れにする | サイト側が一覧と消失による状態反映を選び、じゃんぱらと共通の `SyncSearchSoldStatus` を利用する |
| じゃんぱら | 一覧の売り切れ表示を価格なしでも反映し、消失も同条件で判定する | サイト側が同じ共通処理を選ぶ。両サイトの解析の違いは各サイトに残す |
| メルカリ | 一覧の売り切れ表示と個別ページで状態・売却日を確認する | 個別確認可能なサイトとして既存の `fetch_detail` と候補選択に参加する。全体の候補順と上限は共通側で維持する |
| Yahoo!フリマ | 一覧と個別ページで状態・売却日を確認する | メルカリと同じ共通候補選択を使い、サイト固有の取得・解析は既存クラスに残す |
| ヤフオク | 出品中と落札相場の一覧から状態・売却日を取得する | 一覧の解析をサイト内に維持し、消失判定や個別確認を追加しない |
| トレファク | 価格のある販売中出品を一覧から取得する | 一覧の解析をサイト内に維持し、消失判定や個別確認を追加しない |

既存の `UrlRouter::SITES` をサイトの登録元として使い、サイト自身が必要な取得後の一覧状態反映を明示する。対応するサイトだけに処理を委ねる方法を実装時に選び、空のクラスや不要な共通インターフェースは作らない。`DetailCandidates` は既存の `fetch_detail` 能力を使い、サイトごとに選んだ候補を集約してから古い順に最大50件を投入する。現行のメルカリのジョブ引数も維持する。サイト別ジョブ、新しい DB テーブル、ID の意味の変更は含めない。

## 手順

- [ ] Step 1: `just ps` でサービス状態を確認し、必要に応じて `just up`。既存の RSpec 設定と `unit-test-instructions.md` の対象コマンドで変更前の結果を記録する。既存失敗は診断する。（NFR2）
- [ ] Step 2: `volumes/backend/app/services/product_monitoring/sync_crawl_results.rb` の一覧反映・消失判定を、同じ名前空間の責務を表す小さなクラスへ移す。既存の呼び出し順、トランザクション、条件、更新対象を維持し、新規の設定やスキーマを追加しない。（FR2、FR3）
- [ ] Step 3: `volumes/backend/spec/services/product_monitoring/sync_crawl_results_spec.rb` の既存事例を再実行し、抽出後の公開された振る舞いに不足がある場合に限り新規クラスの spec を追加する。成功、失敗、打ち切り、価格なし、3時間境界、復帰、他サイト・他設定への非影響を確認する。（FR1、FR2、FR3、NFR2）
- [ ] Step 4: crawler、サイト、設定 API、詳細ジョブ、表示・集計の関連 spec を実行し、DB 更新とジョブ投入の既存動作を確認する。変更前と比較して回帰を解決する。（FR1、FR2、FR4、NFR1、NFR2）
- [ ] Step 5: 変更ファイルの RuboCop と対象テストを実行し、ログ・Datadog・BugSnag の影響を確認する。操作や構成に変化がある場合のみ文書の正本を更新し、結果と残課題を記録する。（FR4、NFR1、NFR2）
- [ ] Step 6: 全6サイトの一覧・詳細と保存後の判定を表に沿って照合し、一覧状態反映を行うサイトが自分の責務を宣言できるようにする。`SyncCrawlResults` のイオシス・じゃんぱらの名指しを除き、既存の `SyncSearchSoldStatus` を両サイトで共有する。取得結果の重複排除、同一トランザクションと詳細候補の取得時点を維持する。（FR1、FR2、FR3）
- [ ] Step 7: 変更したサイト・同期処理の既存 spec を拡張し、6サイトそれぞれの処理選択、対象外サイトの非実行、複数 URL の部分失敗・打ち切り、価格なし、3時間境界、詳細候補の全サイト合算・上限を確認する。新しい実行経路は正常系と異常・境界を検証する。（FR1、FR2、FR3、NFR2）
- [ ] Step 8: 関連 RSpec と変更ファイルの RuboCop を再実行し、DB・ジョブ・ログ・監視・表示・集計への影響を再確認する。サイト追加手順が変われば `docs/features/product-monitoring/index.md` の該当箇所を更新する。（FR4、NFR1、NFR2）
- [ ] Step 9: じゃんぱらとイオシスの従来の反映順を維持する処理とテスト上の順序指定を取り除き、登録順で処理する。ロールバック検証は登録順でも先行更新を確認できるよう調整する。（FR2、FR3）
- [x] Step 10: Rails が読み込む `timeout` の重複した require を `crawler.rb` から削除し、crawler の既存テストで確認する。（FR1、NFR2）

- [x] Step 11: 商品計測の関連ファイル内の他の require を確認し、Rails 起動時の読み込みで不要と確認できるものを削除する。サイト・通知を含む関連 spec で確認する。（FR1、NFR1、NFR2）

## 影響と戻し方

更新処理は取得ジョブから呼ばれ、保存済み出品を介して表示・通知・集計に波及する。コード変更は独立した単位にまとめ、問題時はその変更単位を戻す。データ修復や移行は行わない。

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
