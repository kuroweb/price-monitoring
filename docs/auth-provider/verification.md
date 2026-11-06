# 認証の検証

認証を変更する開発者向けの、テスト準備とログイン・ログアウトの確認手順。構成は [認証基盤](index.md) を参照する。

共通の起動・状態確認・RSpec 実行方法は [ローカル開発のテスト手順](../development/testing.md) を参照する。
Provider のテスト DB・アセットを初回または関連変更後に準備する。ホストのリポジトリルートから実行し、処理はテスト環境の `auth-provider` コンテナで行う。

```bash
docker compose run --rm -e RAILS_ENV=test auth-provider bundle exec rails db:prepare
docker compose run --rm -e RAILS_ENV=test auth-provider bundle exec rails tailwindcss:build
```

BFF の OIDC 関連テストを絞って確認する場合は、起動中の `backend` コンテナで実行する。

```bash
just rspec-backend spec/requests/sessions_controller_spec.rb spec/requests/oidc_token_control_spec.rb
```

認証・proxy のログ確認はホストから次を実行する。

```bash
docker compose logs --tail=100 auth-provider nginx
```

https://dev.price-monitoring.com/auth/test からログインし、Provider での認証後に BFF へ戻ること、ログアウト後に BFF のログイン状態が解除されることを確認する。

worktree では [ローカル開発ガイドの Orca の worktree](../development/worktree.md) に従い、`.env` の `WORKTREE_HTTPS_PORT` を URL に付ける（例: `https://dev.price-monitoring.com:8443/auth/test`）。メインと同じブラウザで両方にログインし、片方の BFF からログアウトしても他方はログイン状態を維持することを、両方向で確認する。Provider の「ログイン状態を保持する」を有効にしてログインした場合も、片方のログアウトが他方に影響しないことを確認する。BFF のログアウトは Provider のセッションを終了しないため、再ログイン時に Provider のパスワード入力が省略されることはある。

## proxy・ポート変更後の確認

[worktree の初期化と設定](../development/worktree.md) と [ポート変更とローカル DB の準備](setup.md#worktreeのポート変更) を済ませ、`just ps` で対象環境と公開ポートを確認してから行う。

- Provider の `/.well-known/openid-configuration` を開き、issuer と各 endpoint がその環境の URL と一致することを確認する。worktree では割り当てた HTTPS ポートが含まれることを確認する。
- 上記のログイン・ログアウトと Cookie 分離を、変更後の構成で実行する。
- アプリ画面と API を確認し、frontend の一時的な表示変更が HMR でページ内状態を保って反映されることを確認する。確認用の変更は戻す。

確認は変更後の構成で行う。PR 本文に、確認した環境（メイン / worktree とポート）と未確認の項目を書く。

## 準備・batch・API の変更後の確認

`just prepare` を、空の DB と既存の DB の両方で実行する。どちらも成功し、既存 DB では変更前の管理ユーザーでログインできることを確認する。必須項目が無いときの失敗は `just rspec-auth-provider spec/db/seeds_spec.rb` で確認する。seed は既存の secret や redirect URI の不一致を検出しない。設定を変えたあとは [Provider DB の再作成](setup.md#ローカル-provider-db-の再作成) を先に行う。

- batch は `docker compose logs --tail=100 backend-batch-1 backend-batch-2 backend-batch-3` で確認する。3プロセスとも起動エラーがなく、Sidekiq が `Starting processing` まで出ていることを確認する。Compose の設定を見ただけでは、この確認を終えたことにしない。
- 商品一覧が表示されれば、Next.js サーバーから BFF への接続は通っている。ブラウザの開発者ツールの Network で、画面からの `/api` がページと同じ origin（worktree ではポート付き）になっていることを確認する。
- CORS を変更した場合は、development と production / integration の許可を分けて確認する。

`just prepare` や API の成功だけでは、OIDC・Cookie 分離・HMR を確認したことにはならない。PR 本文に、確認した環境と未確認の項目を書く。
