# ローカル開発環境の構成

開発参加者向けに、ローカル開発環境の用語・接続先・API の接続経路を解説する。
手順のシェル例は、特に書かない限りホストのリポジトリルートから実行する。アプリの言語ツールは Docker Compose / just 経由で対象コンテナ内で実行する。実行先の全一覧と AI 向けの制約は [AGENTS.md](../../AGENTS.md#コマンドの実行場所) を参照する。

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
