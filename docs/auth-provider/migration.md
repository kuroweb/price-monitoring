# 既存 auth-provider 環境の引き継ぎ

旧リポジトリから統合後の構成へ認証データを移す運用担当者向けの手順。構成は [認証基盤](index.md)、共通準備と起動は [ローカル開発](../development/index.md) を参照する。

ホストの旧リポジトリルートで `just down` を実行してから、統合後の環境を起動する。旧環境と同時に起動すると DNS alias・永続データが競合する。`/etc/hosts` の `dev.auth-provider.com` は `127.0.0.2` から `127.0.0.1` へ変更する。ループバックエイリアスの追加は不要。

次のファイルを同じ内容で移す。新しい署名鍵を生成し直さない。

| 旧リポジトリ | このリポジトリ |
| --- | --- |
| `volumes/backend/certs/private.pem` | `volumes/auth-provider/certs/private.pem` |
| `volumes/backend/config/master.key`（存在する場合） | `volumes/auth-provider/config/master.key` |
| `volumes/nginx/certs/fullchain.pem` / `privkey.pem` | `volumes/nginx/certs/auth-provider/` |
| `.env` | `volumes/auth-provider/.env` |

これらの秘密情報は Git に登録しない。BFF の `.env` にある OIDC クライアント情報はそのまま使う。

永続データは、旧構成のボリューム `auth-provider_backend-db` / `auth-provider_backend-redis` から、このリポジトリの Compose project のボリューム（ディレクトリ名が `price-monitoring` なら `price-monitoring_auth-provider-db` / `price-monitoring_auth-provider-redis`）へコピーする。旧環境で Compose project 名を変更していた場合は、`docker volume ls` で実際のボリューム名を確認してから読み替える。コピー先のボリュームが既にある場合は、中身が不要なことを確認して削除してから行う。

旧ボリュームを使うコンテナが動いていると、書き込み途中のデータをコピーしてしまう。次の `docker ps` で何も表示されないことを確かめてからコピーする。コピー先のボリュームは、Compose 管理のラベルが付くよう `docker compose create` で作る。

```bash
docker compose stop auth-provider auth-provider-db auth-provider-redis
docker ps -q --filter volume=auth-provider_backend-db --filter volume=auth-provider_backend-redis
docker compose create auth-provider-db auth-provider-redis
for name in db redis; do
  docker run --rm \
    -v auth-provider_backend-${name}:/from:ro \
    -v price-monitoring_auth-provider-${name}:/to \
    alpine sh -c 'cp -a /from/. /to/'
done
```

同じ Docker daemon 上では既存のユーザー・OAuth クライアント・トークンを引き継ぐ。セッションの継続には同じ `SECRET_KEY_BASE` も必要。

別の Docker daemon に移す場合は MySQL のバックアップ・リストアが必要。`docker compose down -v` は認証データも削除するため、引き継ぎに使わない。
