# AI-DLC

AI-DLC（AI-Driven Development Life Cycle）で機能の検討・実装を進める開発者向けに、起動・再開・知識の登録・更新の手順をまとめる。シェル例はホストのリポジトリルートで実行し、`/aidlc` などは各ツールのチャットで実行する。

AI-DLC の考え方とステージの一覧は [公式ドキュメント](https://awslabs.github.io/aidlc-workflows/) を参照する。AI エージェント向けの制約は [AGENTS.md](../../AGENTS.md#ai-dlc) にある。

## 構成

| 置き場所 | 内容 | 編集 |
| --- | --- | --- |
| `.claude/`・`.codex/`・`.agents/skills/`・`.cursor/` | Claude Code・Codex・Cursor ごとのエンジン（エージェント、ステージ、フック、センサー、スキル） | しない。`aidlc config` が生成する |
| `aidlc/spaces/default/memory/` | ルール。プロジェクト固有の指示は `project.md` に書く | する |
| `aidlc/spaces/default/knowledge/documents/` | チームの文書の原本 | する |
| `aidlc/spaces/default/intents/` | 作業（intent）ごとの状態・監査ログ・要件・設計の記録 | しない。AI-DLC が書く |
| `.aidlc-version` | このプロジェクトで使う `aidlc` の版 | 版を上げるときだけ |

`aidlc/` は 3 つのツールで共有する。どのツールで進めた intent も同じ記録に残る。

## 起動と再開

前提として、ホストに `aidlc` があり、`.aidlc-version` の版が入っていること（`aidlc version`）。

初回起動前に [監査ログに使う端末名](setup.md#ai-dlc-の監査ログに使う端末名) を `workstation` に設定する。新しいクローンや worktree でも、そのチェックアウトの `.aidlc-clone-id` を確認する。

| ツール | 開始・再開 | 状態の確認 | 設定の確認 |
| --- | --- | --- | --- |
| Claude Code | `/aidlc <やりたいこと>` | `/aidlc --status` | `/aidlc --doctor` |
| Codex | `$aidlc <やりたいこと>` | `$aidlc --status` | `$aidlc --doctor` |
| Cursor | `/aidlc <やりたいこと>` | `/aidlc --status` | `/aidlc --doctor` |

スコープは `/aidlc --scope <scope> <やりたいこと>` で指定するか、AI-DLC の提案から選ぶ。進行中の intent があれば、`/aidlc` で続きから再開する。

初めて使うときは、ツールごとにフックを有効にする。Claude Code はフックの承認を求められたら承認し、終了して起動し直す（`/clear` では足りない）。Codex は `/hooks` で t を押して、フックを信頼する。

## Orca の worktree

worktree の準備と起動は [Orca の worktree](worktree.md) に従う。AI-DLC の記録は Git 管理される一方、アクティブな space や intent を示すカーソルは個人用で Git 管理されない。新しい worktree でのカーソルの扱いは、最初の intent で確認する。

## 承認ゲート

各ステージの最後に、AI-DLC が成果物を示して承認を求める。承認するまで次のステージには進まない。人が確かめるのは、意図が反映されているか（ユーザーストーリー、画面モック、設計の図、ユニットテストの意図）。直してほしいときは「Request Changes」を選ぶ。

## 既存の文書を知識として登録する

AI-DLC のエージェントに読ませたい文書は、`aidlc/spaces/default/knowledge/documents/` に置き、Claude Code で `/aidlc-knowledge` から登録する。登録した文書は list・show で確かめ、原本を変えたら sync で反映する。

## 版を上げる

複数のツールを入れているので、`aidlc config` には必ず `--harness` を付ける。付けないと `multiple project harnesses are present` で止まる。

```bash
aidlc update
aidlc config --pin <version> --yes
aidlc config --harness claude --yes
aidlc config --harness codex --yes
aidlc config --harness cursor --yes
aidlc doctor
```

`.aidlc-version` と生成物の差分をコミットする。ホストの `aidlc doctor` が詳しく調べるのは 1 つのツールなので、Codex と Cursor は各ツールの `--doctor` で確かめる。

## シークレット

AI-DLC の監査ログには、ワークフロー中に入力したメッセージが全文で残り、`aidlc/` ごとコミットする。このリポジトリは public なので、シークレットを入力しない。ログを貼るときは、トークン・Cookie・個人情報・接続先を伏せる。コミット時の検査は [コミット前のシークレット検査](setup.md#コミット前のシークレット検査) を参照する。
