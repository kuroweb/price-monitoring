# 初回セットアップ

新しいチェックアウトで開発環境を準備する開発者向けの手順。以下はホストのリポジトリルートで、上から順に実行する。Orca の worktree では、証明書・環境変数・署名鍵を setup がメインからコピーするので、[新規 worktree の初期化](worktree.md#新規-worktree-の初期化) に従う。

## ホストの準備

Docker Compose v2.24.4 以降、just、mkcert を準備する。Compose のバージョンは、任意の `env_file` と、worktree 用の設定の `!override` を使うために必要。macOS で mkcert を導入する場合は、ホストで次を実行する。

```bash
brew install mkcert
mkcert -install
```

## コミット前のシークレット検査

このリポジトリは public なので、コミットの前に、ステージした差分にシークレットがないかを gitleaks で検査する。フックは pre-commit が [.pre-commit-config.yaml](../../.pre-commit-config.yaml) から入れ、gitleaks の版も同じファイルで固定する。pre-commit は開発補助ツールで、アプリの依存関係ではない。ホストで次を実行する。

```bash
brew install pre-commit
pre-commit install --allow-missing-config
```

フックは git の共通ディレクトリに入るので、メインと Orca の worktree のどちらで実行しても、すべての worktree に効く。`--allow-missing-config` を付けるのは、`.pre-commit-config.yaml` がまだないブランチでのコミットを止めないためなので、省略しない。gitleaks は、最初のコミットで pre-commit が固定された版をビルドして用意する。検査に止められたら、`--no-verify` で回避せず、該当箇所を取り除く。

## AI-DLC の監査ログに使う端末名

このリポジトリは public なので、監査ログのファイル名に hostname を載せないよう、端末名を `workstation` にする。AI-DLC 2.11.4 は、Git 管理外の `aidlc/.aidlc-clone-id` の1行目をクローン固有の識別子、2行目を端末名として使い、監査ログを `<端末名>-<識別子>.md` に追記する。端末名が同じでも識別子で区別できるため、このファイルを他のクローンへコピーしない。

これは公式の設定コマンドではなく、2.11.4 のファイル形式に基づく手順。版を上げたときは、形式と書き込み先を確認する。

AI ツールをこのチェックアウトで初めて起動する前に、次を行う。すでに起動している場合は、このチェックアウトを使うエージェントとワーカーをすべて終了してから変更する。

1. `aidlc/.aidlc-clone-id` があれば、1行目の識別子を保持し、2行目だけを `workstation` に変更する。
2. ファイルがなければ、ホストで次を実行して識別子を生成し、下の形式で `aidlc/.aidlc-clone-id` を作る。既存ファイルの識別子は生成し直さない。

   ```bash
   python3 -I -c 'import secrets; print(secrets.token_hex(6))'
   ```

   ```text
   <出力された12桁の識別子>
   workstation
   ```

3. すでに監査ログがあれば、`aidlc/spaces/*/intents/audit/` と各 intent の `audit/` にある、この識別子で終わるファイルの端末名部分も `workstation` に変更する。識別子と本文は保持し、他のクローンのログは変更しない。同名ファイルがある場合は上書きしない。
4. AI ツールを起動し直して AI-DLC の `--doctor` を実行し、新しい記録が `workstation-<識別子>.md` に追記され、旧名のファイルが再作成されないことを確認する。追跡済みログのリネームは、次のコミットに含める。

過去のコミットに含まれた hostname は、リネームしても履歴に残る。AI-DLC の起動・更新の手順は [AI-DLC](ai-dlc.md) を参照する。

## 証明書と hosts

共通の Nginx が使う BFF / Provider 両方の開発用証明書を、ホストで作成する。

```bash
mkdir -p volumes/nginx/certs/auth-provider
mkcert \
  -cert-file volumes/nginx/certs/fullchain.pem \
  -key-file volumes/nginx/certs/privkey.pem \
  dev.price-monitoring.com
mkcert \
  -cert-file volumes/nginx/certs/auth-provider/fullchain.pem \
  -key-file volumes/nginx/certs/auth-provider/privkey.pem \
  dev.auth-provider.com
```

ホストの `/etc/hosts` に以下を設定する。

```text
127.0.0.1 dev.price-monitoring.com dev.auth-provider.com
```

## 環境変数

ルートの環境変数ファイルを用意する。既存の `.env` は上書きしない。

```bash
cp .env.example .env
```

## イメージの準備

Compose の開発用イメージをビルドする。

```bash
docker compose build
```

## アプリの初期化と起動

Provider の署名鍵が無い場合は、先に [認証の初回準備](../auth-provider/setup.md#初回準備) で生成する。状態を確認し、開発環境を準備する。

```bash
just ps
just prepare
just ps
```

`just prepare` は BFF の `db:prepare`、Provider の `db:prepare db:seed`、全サービスの起動の順に実行する。既存 DB は削除しない。Provider の登録内容と、設定変更時の再作成は [OIDC クライアント登録](../auth-provider/setup.md#oidc-クライアント登録) を参照する。

起動したら [接続先](index.md#接続先) の URL を開く。以降の起動・停止は [日常操作](operations.md) を使う。
