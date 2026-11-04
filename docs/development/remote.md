# 別の Mac から開発する

開発ホストで動かしている環境を、別の Mac の Orca から操作・表示する開発者向けの手順。開発ホストでの環境の準備は [初回セットアップ](setup.md) と [Orca の worktree](worktree.md) に従う。

nginx は開発ホストの `127.0.0.1` でしか待ち受けず、hosts も開発ホストにしか設定していない。そのため、別の Mac のブラウザからはそのままでは開けない。

## Orca の接続

Orca の設定名・挙動は Orca 1.4.246 で確認した。

Orca では開発ホストを SSH target として登録し、リポジトリの場所にその SSH target を選ぶ。Remote Orca Server として接続した場合は、次のブラウザの設定が無いので使えない。

設定 → ブラウザの「SSH ワークスペース」が「SSH ホスト」（初期値）のとき、Orca 内のブラウザの通信と名前解決が開発ホストを経由する。別の Mac で hosts の設定やポート転送をしなくても、開発ホストと同じ URL で開ける。「このデバイス」にした場合や、「代わりにこのデバイスからブラウジングするホスト」に開発ホストを入れた場合は経由しない。

## 証明書の信頼

証明書は開発ホストの mkcert の CA が発行しているので、別の Mac では CA を信頼するまで `ERR_CERT_AUTHORITY_INVALID` になる。別の Mac のローカルのターミナルで次を一度実行し、Orca を再起動する。`<user>` と `<開発ホスト>` は、開発ホストへの SSH のユーザー名とホスト名に置き換える。

```bash
ssh <user>@<開発ホスト> 'cat "$HOME/Library/Application Support/mkcert/rootCA.pem"' > /tmp/rootCA.pem
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain /tmp/rootCA.pem
```

1 行目は開発ホストの CA の証明書を別の Mac にコピーし、2 行目はそれをシステムのキーチェーンにルート CA として登録する。

- 開発ホストに SSH したターミナル（Orca で SSH target の worktree から開いたターミナルを含む）で実行すると、開発ホスト自身への登録になり、承認ダイアログを出せずに失敗する。
- 同じディレクトリの `rootCA-key.pem` は CA の秘密鍵なのでコピーしない。
- 登録すると、その CA が発行したすべての証明書を信頼する。不要になったらキーチェーンアクセスの「システム」から `mkcert <user>@<開発ホスト名>` の証明書を削除する。

## 開発ホストの再起動

再起動後、開発ホストの画面にログインするまでは、SSH から Docker Desktop を起動できない（`open -a Docker` が `Launch failed.` で失敗する）。開発ホストの画面にログインしてから Docker Desktop を起動し、[日常操作](operations.md#起動と状態確認) の `just up` を実行する。画面にログインした後なら、SSH から `open -a Docker` でも起動できる。
