# 認証の検証

認証を変更する開発者向けの、テスト準備とログイン・ログアウトの確認手順。構成は [認証基盤](index.md) を参照する。

共通の起動・状態確認・RSpec 実行方法は [ローカル開発のテスト手順](../development/index.md#テスト) を参照する。
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
