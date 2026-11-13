# Project-Level Rules

> Project-specific specialisation and corrections. Loaded after `org.md` and
> `team.md` as strict-additive guidance.
> Populated by practices-discovery and the self-learning loop.
>
> Use sparingly: most teams don't need a project layer. Reach for it
> only when this specific project needs stable, durable guidance beyond the
> team practice (for example, package-specific release checks or an additional
> regression suite for a legacy component).

## Way of Working

- 質問・成果物・承認の案内は日本語で書く。
- 作業は [AGENTS.md](../../../../AGENTS.md) の実行制約に従う。

<!-- Project-specific specialisation. Example: -->
<!-- This monorepo requires package-scoped branch names and a package owner -->
<!-- review in addition to the team's normal merge policy. -->
<!-- A project that merges into another branch than team.md names says so on its own line, read before team.md's: -->
<!-- - **Integration branch**: develop -->

## Walking Skeleton

<!-- Project-specific specialisation. Example: -->
<!-- The walking skeleton must exercise the legacy service adapter as well -->
<!-- as the new service boundary. -->

## Testing Posture

- 検証は [テスト手順](../../../../docs/development/testing.md) に従い、変更範囲に応じて選ぶ。失敗時は対象だけを再実行し、依存サービスの状態を確認する。
- アプリの起動・テストと依存関係の更新は、Compose service 経由で実行する（[AGENTS.md](../../../../AGENTS.md#コマンドの実行場所)）。

## Guard Policy

<!-- Project-specific. Mode: strict, relaxed, or off. Strict here holds for every intent, whatever one person asks in chat; relaxed or off here applies to every intent whose policy came from its scope, unless the person sets another; changing this line changes it. A section under the retired Change Control heading, written by an earlier release, is still read. -->

## Deployment

- デプロイは [CI/CD](../../../../docs/cicd/index.md) が行う。本番は自宅の Kubernetes と ArgoCD で、AWS は使わない。

## Code Style

- 実装前に対象レイヤーの既存実装を読み、[Backend](../../../../docs/backend/index.md) / [Frontend](../../../../docs/frontend/index.md) の責務境界を守る。変更は最小スコープにし、可読性を優先する。

## Tech Stack

- 技術スタックと全体構成は [README](../../../../README.md) を参照する。

## Decided

<!-- Decisions made in earlier stages that should not be re-asked. -->
<!-- Format: DECIDED: [decision] (Stage [slug], [date]) -->

## Scope Overrides

<!-- Custom scope rules for this project. -->

## Forbidden

<!-- Populated by practices-discovery affirmation gate. -->
<!-- Format: - NEVER [behavior] (affirmed [date]) -->
<!-- Example: - NEVER throw exceptions across service layer boundaries (affirmed 2026-05-17) -->

## Mandated

<!-- Populated by practices-discovery affirmation gate. -->
<!-- Format: - ALWAYS [behavior] (affirmed [date]) -->
<!-- Example: - ALWAYS use Result<T,E> for fallible operations in service layer (affirmed 2026-05-17) -->

## Corrections

<!-- Project-specific corrections from human feedback. -->
<!-- Format: NEVER/ALWAYS [behavior] (learned [date]) -->
