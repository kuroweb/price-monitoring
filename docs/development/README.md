# 開発

開発参加者向けに、Backend・Frontend・認証・Database・CI/CD の各領域の文書と、ローカル開発環境の構成、セットアップ・日常操作・テストの手順を案内する。
手順のシェル例は、特に書かない限りホストのリポジトリルートから実行する。アプリの言語ツールは Docker Compose / just 経由で対象コンテナ内で実行する。実行先の全一覧と AI 向けの制約は [AGENTS.md](../../AGENTS.md#コマンドの実行場所) を参照する。

## 領域別の文書

| 領域 | 文書 |
| --- | --- |
| BFF / batch の責務分離、Rails 更新、seed 投入 | [Backend](backend/README.md) |
| frontend の責務分離 | [Frontend](frontend/README.md) |
| Provider / Client の配置・境界、認証固有の初回準備・検証 | [認証基盤](auth-provider/README.md) |
| BFF / batch のデータ領域の分け方、ER、アソシエーション | [Database](database/README.md) |
| CI/CD、PR 自動レビュー、全イメージの手動デプロイ | [CI/CD と自動レビュー](cicd/README.md) |
| レイヤーに共通するコードの書き方（コメントなど） | [コーディング規約](coding-conventions.md) |
| 文書の配置・役割・正本、機能文書の設計、更新規約・記述規約 | [文書規約](documentation-conventions.md) |

## ローカル開発の文書

| 目的 | 文書 |
| --- | --- |
| 新しいチェックアウトで環境を準備する | [初回セットアップ](setup.md) |
| 起動・停止、依存関係の更新、本番ログ調査、MCP の初回導入 | [日常操作](operations/README.md) |
| RSpec・静的検証・frontend のテスト | [テスト](testing.md) |
| Orca の worktree でメインと並行して動かす | [Orca の worktree](worktree.md) |
| 開発ホストの環境を別の Mac から使う | [別の Mac から開発する](remote.md) |
| AI-DLC で機能の検討・実装を進める | [AI-DLC](ai-dlc.md) |

関連する手順:

- [Seed データの投入](backend/operations/seeds.md)
- [認証基盤の準備・検証](auth-provider/README.md)
- [CI/CD と自動レビュー](cicd/README.md)
- [文書全体の索引](../README.md)

## 用語

| 用語 | 意味 |
| --- | --- |
| ホスト | Docker を動かしているマシン。コンテナの外側 |
| メイン | リポジトリの元のチェックアウト。worktree の setup のコピー元 |
| worktree | Orca が作る、メインとは別のチェックアウト。Compose project もメインと分かれる |
| 開発ホスト | 別の Mac から使うときの、環境を動かしているマシン |

## 接続先

| 接続先 | メイン | worktree |
| --- | --- | --- |
| メインアプリ | https://dev.price-monitoring.com/ | `https://dev.price-monitoring.com:<port>/` |
| 認証プロバイダー | https://dev.auth-provider.com/ | `https://dev.auth-provider.com:<port>/` |

`<port>` は worktree の `.env` の `WORKTREE_HTTPS_PORT`。`just url` で、実行したディレクトリの環境の URL を表示できる。

## API の接続経路

ブラウザからの API リクエストは、`NEXT_PUBLIC_API_URL` が未設定ならページと同じ origin に送る。worktree ではポート付きになる。別 origin の API を使う環境だけ `NEXT_PUBLIC_API_URL` を設定する。

Next.js サーバーは `NEXT_PRIVATE_API_URL` で Compose 内の `backend` に直接接続する。公開ポートを変えても、frontend のこの設定は変えなくてよい。development の CORS は `localhost:8080` を許可しないので、画面は nginx の URL から開く。
