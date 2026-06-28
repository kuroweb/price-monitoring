---
name: pj-security-review
description: |
  セキュリティレビュー。PR・変更差分・認証/API/infra 変更のマージ前確認で使う。
  トリガー: 「セキュリティレビュー」「セキュリティチェック」「pj-security-review」,
  「脆弱性」「認可漏れ」「シークレット漏洩」「マージ前にセキュリティ確認」。
---

# Security Review

変更差分をセキュリティ観点で深掘りする。
レビュー中はファイルを変更しない（指摘と修正案の提示のみ）。

一般コードレビューは `pj-code-review` を使う。本スキルはセキュリティ特化。

## チェックリスト

詳細は `references/` を読んでからレビューする。

| ファイル | いつ読むか |
| --- | --- |
| [references/common.md](references/common.md) | 常に |
| [references/project.md](references/project.md) | 常に |
| [references/frontend.md](references/frontend.md) | `volumes/frontend/` に変更があるとき |
| [references/backend.md](references/backend.md) | `volumes/backend/` に変更があるとき |

## 実行手順

### 1. レビュー文脈を確認する

依頼文だけでは意図が読み取れない場合はユーザーにヒアリングする。

#### 確認項目

1. **何を変えたか** — 一言での変更内容
2. **セキュリティ上の懸念** — 認証・認可・外部入力・秘密情報・infra など
3. **到達経路** — 未認証 / 認証済み / 内部のみ など、誰が触れるか
4. **確認してほしい点** — 特に見てほしい箇所（任意）

一度に聞く項目は 3〜4 個まで。

### 2. レビュー対象を確定する

- **ブランチ差分** → `git diff <base>...HEAD`（base 未指定なら `master`）
- **作業ツリー** → `git diff` / `git diff --staged`
- **ファイル指定** → 指定ファイルとその周辺（認可・入力検証・秘密情報の流れ）を読む

差分が取れない場合は、比較 base・対象ファイルをユーザーに確認する。

### 3. 変更レイヤーを分類する

- Frontend: `volumes/frontend/`
- Backend BFF / Batch: `volumes/backend/`
- Infra / CI / secrets: `.github/`, `docker-compose.yml`, `k8s/`, `Makefile` など

認証境界（Frontend ↔ BFF ↔ Batch ↔ 外部）をまたぐ変更は重点的に見る。

### 4. チェックリストでレビューする

1. 到達経路（誰が・どの経路で exploit できるか）を先に整理する
2. `common.md` と `project.md` を読む
3. 変更レイヤーに応じて `frontend.md` / `backend.md` を読む
4. 秘密情報・認可・入力の流れが diff だけで追えないときは、呼び出し元・設定・ middleware を読む
5. 指摘は **脆弱性の内容 → 到達条件・影響 → 修正案** の順で書く

### 5. 結果を出力する

## 出力フォーマット

```markdown
## Summary
<1〜3 文。主なリスクとマージ可否の判断>

## Attack Surface
- 今回の変更で増減した攻撃面（エンドポイント、入力源、秘密情報、管理 UI など）

## Good
- セキュリティ上よい実装・既存対策の維持

## Needs Improvement

### Critical
- マージ前に必須修正（到達条件 + 影響 + 具体的修正案）

### Warning
- マージ前に直した方がよい問題（到達条件 + 影響 + 具体的修正案）

### Suggestion
- 改善推奨・任意（理由 + 具体的修正案）

## Questions
- 差分だけでは exploit 可否や意図が判断できない点
```

- 問題がなければ Needs Improvement の各セクションは「なし」と書く
- 推測で Critical / Warning を付けない。根拠が差分または読んだコードにない指摘は Questions へ回す
- 深刻度の目安:
  - **Critical** — マージ不可（未認証 exploit、秘密情報漏洩、認可 bypass、RCE/SQLi の直接経路）
  - **Warning** — マージは可能だが修正推奨（認証済み exploit、条件付きだが現実的な攻撃、秘密情報の誤配置、防御不足）
  - **Suggestion** — ハードニング・ベストプラクティス・将来改善

## やらないこと

- レビュー中にコードを直接修正しない
- 一般の可読性・設計レビューに広げない（`pj-code-review` の領域）
- OWASP 用語の羅列で埋めない（この repo の認証境界・データの流れを優先）
- チェックリストを SKILL.md に複製しない（`references/` を正本とする）

## 委譲

- 一般コードレビュー → `pj-code-review` スキル
- Cursor の `security-review` サブエージェントによる自動スキャン → 利用可能な場合、本スキルのチェックリストレビューと併用可（サブエージェント単独で完結させない）
- docs の更新判断 → `pj-docs-updater-*` スキル
