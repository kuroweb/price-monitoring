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
| [開発](development/index.md) | 開発文書の入口、ローカル開発環境の構成・用語・接続先 |
| [初回セットアップ](development/setup.md) | 共通セットアップ、コミット前のシークレット検査、証明書・hosts、イメージ、DB の準備 |
| [日常操作](development/operations/index.md) | 開発環境の操作・本番調査の手順一覧 |
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
| [Backend](development/backend/index.md) | BFF / batch の責務分離 |
| [Backend の運用手順](development/backend/operations/index.md) | BFF / batch の保守手順の一覧 |
| [Rails バージョンアップ](development/backend/operations/rails-upgrade.md) | Rails 更新 |
| [Seed データの投入](development/backend/operations/seeds.md) | BFF の seed 投入 |
| [Frontend](development/frontend/index.md) | frontend の責務分離 |
| [認証基盤](development/auth-provider/index.md) | Provider / Client の配置・境界 |
| [認証の初回セットアップ](development/auth-provider/setup.md) | 認証固有の初回準備・クライアント登録 |
| [認証の検証](development/auth-provider/verification.md) | 認証固有のテスト準備・動作確認 |
| [Database](development/database/index.md) | BFF / batch のデータ領域の分け方 |
| [ER](development/database/er.md) | BFF / batch のカラム・インデックス |
| [アソシエーション](development/database/association.md) | 機能文書がまだ無い領域のテーブル間関連 |
| [CI/CD と自動レビュー](development/cicd/index.md) | CI/CD、PR 自動レビュー、全イメージの手動デプロイ |

## 機能

| 文書 | 内容 |
| --- | --- |
| [機能](features/index.md) | 機能文書の一覧 |
| [商品モニタリング](features/product-monitoring/index.md) | 商品モニタリングの概要 |
| [商品モニタリングの外部仕様](features/product-monitoring/external-spec.md) | 画面と通知から見える振る舞い |
| [商品モニタリングの内部仕様](features/product-monitoring/internal-spec.md) | 保存・抽出・取得・ジョブの実装 |
| [商品モニタリングの API](features/product-monitoring/api.md) | エンドポイントごとの契約 |
| [商品モニタリングのオペレーション](features/product-monitoring/operations.md) | 商品モニタリングの操作手順 |
| [商品モニタリングの DB](features/product-monitoring/database.md) | 商品モニタリングのテーブル定義と関連 |
