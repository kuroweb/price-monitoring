# 文書の索引

## 全体

| 文書 | 内容 |
| --- | --- |
| [ルート README](../README.md) | 目的・技術スタック・全体構成 |
| [GLOSSARY.md](../GLOSSARY.md) | 商品モニタリングの用語 |
| [AGENTS.md](../AGENTS.md) | AI の実行制約と作業判断 |
| [文書規約](development/documentation-conventions.md) | 文書の配置・役割・正本、機能文書の設計、更新規約・記述規約 |
| [コーディング規約](development/coding-conventions.md) | レイヤーに共通するコードの書き方（コメントなど） |

## ローカル開発

| 文書 | 内容 |
| --- | --- |
| [開発](development/README.md) | 開発文書の索引 |
| [ローカル開発環境の構成](development/environment.md) | ローカル開発環境の用語・接続先・API の接続経路 |
| [初回セットアップ](development/setup.md) | 共通セットアップ、コミット前のシークレット検査、証明書・hosts、イメージ、DB の準備 |
| [日常操作](development/operations/README.md) | 開発環境の操作・本番調査の手順の索引 |
| [ローカル環境の起動と状態確認](development/operations/local-environment.md) | 起動・停止・ローカルログの確認 |
| [依存関係の更新・調査](development/operations/dependencies.md) | アプリの依存関係の更新・調査 |
| [本番ログの調査](development/operations/production-logs.md) | 本番ログの読み取り調査 |
| [本番ログ調査用 MCP のセットアップ](development/operations/mcp-setup.md) | Claude Code・Codex・Cursor のログ調査用 MCP 導入 |
| [テスト](development/testing.md) | RSpec・静的検証・frontend のテスト |
| [Orca の worktree](development/worktree.md) | Orca の worktree の setup・初期化・ポート |
| [別の Mac から開発する](development/remote.md) | 開発ホストの環境を別の Mac から使う |
| [AI-DLC](development/ai-dlc.md) | AI-DLC の起動・再開・知識の登録・更新 |

## 領域別の開発

| 文書 | 内容 |
| --- | --- |
| [Backend](development/backend/README.md) | Backend の文書の索引 |
| [Backend の責務分離](development/backend/architecture.md) | BFF / batch の責務分離 |
| [Backend のテスト方針](development/backend/test-conventions.md) | RSpec の説明文の書き方 |
| [Backend の運用手順](development/backend/operations/README.md) | BFF / batch の保守手順の索引 |
| [Rails バージョンアップ](development/backend/operations/rails-upgrade.md) | Rails 更新 |
| [Seed データの投入](development/backend/operations/seeds.md) | BFF の seed 投入 |
| [Frontend](development/frontend/README.md) | Frontend の文書の索引 |
| [Frontend の責務分離](development/frontend/architecture.md) | frontend の責務分離 |
| [Frontend の Lint の構成](development/frontend/lint.md) | ESLint の構成 |
| [Frontend のテスト方針](development/frontend/test-conventions.md) | Vitest のテストの書き方と対象範囲 |
| [認証基盤](development/auth-provider/README.md) | 認証基盤の文書の索引 |
| [認証基盤の構成](development/auth-provider/architecture.md) | Provider / Client の配置・境界、会員登録とログイン |
| [認証の初回セットアップ](development/auth-provider/setup.md) | 認証固有の初回準備・クライアント登録 |
| [認証の検証](development/auth-provider/verification.md) | 認証固有のテスト準備・動作確認 |
| [認証基盤の CI/CD と Kubernetes](development/auth-provider/kubernetes.md) | 認証基盤の Kubernetes 上の構成と OIDC クライアント登録 |
| [Database](development/database/README.md) | Database の文書の索引 |
| [テーブル定義](development/database/tables.md) | BFF / batch のカラム・インデックス・外部キー |
| [CI/CD と自動レビュー](development/cicd/README.md) | CI/CD の文書の索引 |
| [CI/CD のパイプライン](development/cicd/pipeline.md) | CI/CD の実行条件、PR の自動テスト、全イメージの手動デプロイ |
| [Dependabot による依存関係の更新](development/cicd/dependabot.md) | Dependabot の対象と除外 |
| [PR の自動レビュー](development/cicd/code-review.md) | Claude Code による PR 自動レビュー |

## 機能

| 文書 | 内容 |
| --- | --- |
| [機能](features/README.md) | 機能文書の索引 |
| [商品モニタリング](features/product-monitoring/README.md) | 商品モニタリングの文書の索引 |
| [商品モニタリングの外部仕様](features/product-monitoring/external-spec.md) | 画面と通知から見える振る舞い |
| [商品モニタリングの内部仕様](features/product-monitoring/internal-spec.md) | 保存・抽出・取得・ジョブの実装 |
| [商品モニタリングの API](features/product-monitoring/api.md) | エンドポイントごとの契約 |
| [商品モニタリングのオペレーション](features/product-monitoring/operations.md) | 商品モニタリングの操作手順 |
| [商品モニタリングの DB](features/product-monitoring/database.md) | 商品モニタリングのテーブル間の関連（ER 図） |
