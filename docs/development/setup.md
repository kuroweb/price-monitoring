# 初回セットアップ

新しいチェックアウトで開発環境を準備する開発者向けの手順。以下はホストのリポジトリルートで、上から順に実行する。Orca の worktree では、証明書・環境変数・署名鍵を setup がメインからコピーするので、[新規 worktree の初期化](worktree.md#新規-worktree-の初期化) に従う。

## ホストの準備

Docker Compose v2.24.4 以降、just、mkcert を準備する。Compose のバージョンは、任意の `env_file` と、worktree 用の設定の `!override` を使うために必要。macOS で mkcert を導入する場合は、ホストで次を実行する。

```bash
brew install mkcert
mkcert -install
```

## コミット前のシークレット検査

このリポジトリは public なので、コミットの前に、ステージした差分にシークレットがないかを gitleaks で検査する。フックは pre-commit が [.pre-commit-config.yaml](../../.pre-commit-config.yaml) から入れ、gitleaks のバージョンも同じファイルで固定する。pre-commit は開発補助ツールで、アプリの依存関係ではない。ホストで次を実行する。

```bash
brew install pre-commit
pre-commit install --allow-missing-config
```

フックは git の共通ディレクトリに入るので、メインと Orca の worktree のどちらで実行しても、すべての worktree に効く。`--allow-missing-config` を付けるのは、`.pre-commit-config.yaml` がまだないブランチでのコミットを止めないためなので、省略しない。gitleaks は、最初のコミットで pre-commit が固定されたバージョンをビルドして用意する。検査に止められたら、`--no-verify` で回避せず、該当箇所を取り除く。

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
