---
name: pj-code-review
description: |
  コードレビュー。PR・変更差分・実装後のセルフレビューで使う。
  トリガー: 「レビューして」「コードレビュー」「PR チェック」「pj-code-review」,
  「この diff 見て」「マージ前に確認して」。
---
# Code Review

変更差分を読み、実装者の文脈に引きずられずにレビューする。
レビュー中はファイルを変更しない（指摘と修正案の提示のみ）。

## チェックリスト

詳細は `references/` を読んでからレビューする。

| ファイル | いつ読むか |
| --- | --- |
| [references/common.md](references/common.md) | 常に |
| [references/project.md](references/project.md) | 常に |
| [references/frontend.md](references/frontend.md) | `volumes/frontend/` に変更があるとき |
| [references/backend.md](references/backend.md) | `volumes/backend/` に変更があるとき |

## 実行手順

### 1. 変更の目的を確認する

レビューに入る前に、依頼文だけでは意図が読み取れない場合はユーザーにヒアリングする。
依頼に十分書いてあれば、その内容を要約して確認するだけでよい。

#### 確認項目

1. **何を変えたか** — 一言での変更内容
2. **なぜ変えたか** — 解決したい問題・背景
3. **意図したスコープ** — 今回触る / 触らない範囲
4. **確認してほしい点** — 特に見てほしい懸念（任意）

一度に聞く項目は 3〜4 個まで。足りなければ追加で聞く。

### 2. レビュー対象を確定する

依頼から次を判断する。

- **ブランチ差分** → `git diff <base>...HEAD`（base 未指定なら `master`）
- **作業ツリー** → `git diff` / `git diff --staged`
- **ファイル指定** → 指定ファイルとその周辺の呼び出し元を読む

差分が取れない場合は、ユーザーに比較 base・対象ファイルを確認する。

### 3. 変更レイヤーを分類する

- Frontend: `volumes/frontend/`
- Backend BFF / Batch: `volumes/backend/`
- Infra / CI / docs: `.github/`, `docker-compose.yml`, `docs/`, `justfile` など

レイヤーをまたぐ変更は、境界を崩していないかを重点的に見る。

### 4. チェックリストでレビューする

1. ユーザーが述べた目的と diff の内容が一致しているかを先に見る
2. `common.md` と `project.md` を読む
3. 変更レイヤーに応じて `frontend.md` / `backend.md` を読む
4. 差分だけで判断できないときは、類似実装 1〜2 件を読んでプロジェクト慣習と比較する
5. 指摘は事実・影響・修正案の順で書く

### 5. 結果を出力する

## 出力フォーマット

```markdown
## Summary
<1〜3 文で全体所見。変更目的との整合とマージ可否の判断>

## Good
- 良い点

## Needs Improvement

### Critical
- マージ前に必須修正（理由 + 具体的修正案）

### Warning
- マージ前に直した方がよい問題（バグの可能性、責務境界違反、テスト不足など。理由 + 具体的修正案）

### Suggestion
- 改善推奨・任意（理由 + 具体的修正案）

## Questions
- 意図確認が必要な点（差分だけでは判断できないもの）
```

- 問題がなければ Needs Improvement の各セクションは「なし」と書く
- 推測で Critical / Warning を付けない。根拠が差分または読んだコードにない指摘は Questions へ回す
- 深刻度の目安: Critical = マージ不可 / Warning = マージは可能だが修正推奨 / Suggestion = 好み・将来改善
- プロジェクト固有の handbook は `docs/backend/overview.md` / `docs/frontend/overview.md` を根拠にできる

## やらないこと

- レビュー中にコードを直接修正しない（修正依頼があれば別タスク）
- 変更と無関係なリファクタリングを提案しない
- 一般論の羅列で埋めない（この repo の責務境界・慣習を優先）
- チェックリストを SKILL.md に複製しない（`references/` を正本とする）

## 委譲

- セキュリティ特化の深掘り → `pj-security-review` スキル
- Bugbot 形式の自動レビュー → `review-bugbot` スキル（利用可能な場合）
- docs の更新判断 → `pj-docs-updater-*` スキル
