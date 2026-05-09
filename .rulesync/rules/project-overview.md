---
root: true
targets: ["*"]
description: "price-monitoring の実装判断と開発ワークフローの共通前提"
globs: ["**/*"]
---

# Project Overview

## 目的

- Web上の商品の最安値探索と相場把握を支援する。
- Rails / TypeScript の実践的なキャッチアップを兼ねる。
- Datadog / BugSnag を使った運用監視の学習と実運用を行う。

## システム構成

- Frontend: Next.js / TypeScript / Tailwind CSS
- Backend BFF: Rails
- Batch: Sidekiq + Playwright
- Data Store: MySQL / Redis
- 認証: OpenID Connect（実装中）

## 開発ワークフロー

### 開発・運用環境

- 開発環境は Docker Compose を基本とする。
- 本番環境は自宅 Kubernetes（Master 1 / Worker 3）を利用する。
- CI/CD は GitHub Actions で運用する。

### ローカル開発ワークフロー

1. 初回セットアップ: 証明書作成と `/etc/hosts` 設定を行う（README の手順に従う）。
2. イメージ準備: `docker compose build`
3. 起動: `just up`
4. 状態確認: `just ps`（起動確認） / `just logs`（エラー確認）
5. 実装・修正: 既存の責務境界（Frontend / BFF / Batch）を維持して変更
6. 検証: 変更範囲に応じて `just rspec` などを実行
7. 終了: `just down`

### 主要コマンド

- `just up`: Docker Compose の全サービスをバックグラウンド起動
- `just down`: Docker Compose の全サービス停止とネットワーク破棄
- `just ps`: コンテナ稼働状態の確認
- `just logs`: 全サービスのログをフォロー表示
- `just restart-all`: 全サービスを再起動
- `just restart <container-name>`: 指定コンテナのみ再起動
- `just attach <container-name>`: 指定コンテナにアタッチして対話確認
- `just rspec [args...]`: Rails のテスト実行。引数で対象ファイル・行・オプションを指定可能（`spring` コンテナ経由）
- `docker compose build`: ローカル開発用イメージ再ビルド
- `make build-all` / `make push-all`: デプロイ用イメージのビルド・push（主に運用向け）

### テスト実行ガイド

- 前提: `just up` 後に `spring` コンテナが起動していることを `just ps` で確認する。
- 全体実行: `just rspec`（ローカル反復向け。`spring` コンテナを利用）
- 単一ファイル実行: `just rspec spec/models/<target>_spec.rb`
- 行指定実行: `just rspec spec/models/<target>_spec.rb:42`
- 失敗時の切り分け: まず対象 spec を単体で再実行し、必要に応じて `just logs` で依存サービスの状態を見る。

### 実装時の判断基準

- まず `just ps` で実行環境を確認し、未起動なら `just up` を優先する。
- 不具合調査は `just logs` で事実確認してから修正に入る。
- 変更対象は最小スコープに限定し、既存の責務分離（Frontend / BFF / Batch）を崩さない。
- 変更は必要最小限にし、学習目的を踏まえて可読性を優先する。
- 監視・運用影響がある変更では Datadog / BugSnag への影響も確認する。
- コマンド追加や運用変更が必要な場合は、`README.md` / `justfile` / `Makefile` の整合を保つ。
- デプロイ用の `make` タスクは、ローカル開発修正だけなら原則触らない。

### 変更後チェックリスト

- 変更ファイルが対象レイヤーに閉じているか
- ローカル実行手順に影響がある場合、関連ドキュメントを更新したか
- 必要なテストまたは最低限の動作確認を実施したか
- 監視・運用影響がある変更かどうかを確認したか

## エージェント設定

- このリポジトリでは `.rulesync/` を正本として扱う。
- ルール・スキル・サブエージェントを変更するときは `.rulesync/` のみ編集する。
- `rulesync generate` の出力物（`AGENTS.md` / `CLAUDE.md` / `GEMINI.md`、各エージェント向け rules・memories など）は直接編集しない。
- 内容を変更するときは `.rulesync/` を修正してから `rulesync generate` を実行する。
- `.rulesync/` と生成物が矛盾する場合は `.rulesync/` を正とする。
