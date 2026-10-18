# auth-provider

Devise / Doorkeeper を使う OpenID Connect Provider。`volumes/backend` の OIDC Client / BFF とは別の Rails アプリとして管理する。

セットアップ・既存データの引き継ぎ・検証・CI/CD は [認証基盤のドキュメント](../../docs/auth-provider/overview.md) を参照する。

リポジトリルートで `just up` を実行して起動し、`just rspec-auth-provider` でテストする。
