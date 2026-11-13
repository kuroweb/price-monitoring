# ローカル開発

開発参加者向けに、ローカル開発環境の構成と、セットアップ・日常操作・テストの手順を案内する。
手順のシェル例は、特に書かない限りホストのリポジトリルートから実行する。アプリの言語ツールは Docker Compose / just 経由で対象コンテナ内で実行する。実行先の全一覧と AI 向けの制約は [AGENTS.md](../../AGENTS.md#コマンドの実行場所) を参照する。

## 文書の案内

| 目的 | 文書 |
| --- | --- |
| 新しいチェックアウトで環境を準備する | [初回セットアップ](setup.md) |
| 起動・停止・ログ確認、依存関係の更新 | [日常操作](operations.md) |
| RSpec・静的検証・frontend のテスト | [テスト](testing.md) |
| Orca の worktree でメインと並行して動かす | [Orca の worktree](worktree.md) |
| 開発ホストの環境を別の Mac から使う | [別の Mac から開発する](remote.md) |
| AI-DLC で機能の検討・実装を進める | [AI-DLC](ai-dlc.md) |

関連する手順:

- [Seed データの投入](../backend/operations/seeds.md)
- [認証基盤の準備・検証](../auth-provider/index.md)
- [CI/CD と自動レビュー](../cicd/index.md)
- [文書全体の索引](../index.md)

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
