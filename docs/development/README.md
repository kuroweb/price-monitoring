# 開発

## 領域

| 文書 | 内容 |
| --- | --- |
| [Backend](backend/README.md) | BFF / batch の責務分離・テスト方針・運用手順 |
| [Frontend](frontend/README.md) | frontend の責務分離・Lint・テスト方針 |
| [認証基盤](auth-provider/README.md) | Provider / Client の構成、認証固有の初回準備・検証・Kubernetes 運用 |
| [Database](database/README.md) | BFF / batch のデータ領域の分け方、ER、アソシエーション |
| [CI/CD と自動レビュー](cicd/README.md) | CI/CD、Dependabot、PR 自動レビュー、全イメージの手動デプロイ |

## ローカル開発

| 文書 | 内容 |
| --- | --- |
| [ローカル開発環境の構成](environment.md) | 用語・接続先・API の接続経路 |
| [初回セットアップ](setup.md) | 新しいチェックアウトで環境を準備する |
| [日常操作](operations/README.md) | 起動・停止、依存関係の更新、本番ログ調査、MCP の初回導入 |
| [テスト](testing.md) | RSpec・静的検証・frontend のテスト |
| [Orca の worktree](worktree.md) | Orca の worktree でメインと並行して動かす |
| [別の Mac から開発する](remote.md) | 開発ホストの環境を別の Mac から使う |
| [AI-DLC](ai-dlc.md) | AI-DLC で機能の検討・実装を進める |

## 規約

| 文書 | 内容 |
| --- | --- |
| [コーディング規約](coding-conventions.md) | レイヤーに共通するコードの書き方（コメントなど） |
| [文書規約](documentation-conventions.md) | 文書の配置・役割・正本、機能文書の設計、更新規約・記述規約 |
