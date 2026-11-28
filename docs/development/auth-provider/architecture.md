# 認証基盤の構成

認証を開発・運用する人向けに、Provider / Client の境界と配置を解説する。
認証基盤は price-monitoring と同じリポジトリ・Docker Compose で管理する。OIDC Provider と Client は別の Rails アプリとし、モデル・DB・Redis を共有しない。

## 会員登録とログイン

アプリのヘッダーの「ログイン・新規登録」から BFF の OIDC 認証を開始し、Provider のログイン画面で新規登録を選ぶ。名前・メールアドレス・パスワードは Provider が受け取り、登録後に認可を続行する。BFF は認証成功時に Provider の識別子に対応するユーザーを作成し、アプリのトップへ戻す。ログイン中はヘッダーの名前からマイページとログアウトを選べる。マイページには名前とメールアドレスを表示する。ログアウトは BFF のセッションを終了したあと、Provider の `/oauth/logout`（OIDC の RP-Initiated Logout）で Provider のセッションも終了し、トップへ戻す。Provider は自分が発行した ID トークンがあるときだけセッションを終了し、戻り先はそのクライアントの redirect URI と同じオリジンに限る。パスワードは BFF や frontend に渡さない。

現状はメールアドレスの確認なしで登録でき、BFF の管理 API に会員ごとの権限分離はない。公開運用にはメール配送・確認と管理操作の認可方針を決める必要がある。

| 用途 | 配置 / Compose service |
| --- | --- |
| Client / BFF | `volumes/backend` / `backend` |
| Provider（Devise / Doorkeeper） | `volumes/auth-provider` / `auth-provider` |
| Provider の Dockerfile | `containers/auth-provider` |
| 共通の HTTPS proxy | `volumes/nginx` / `nginx`（ホスト名で BFF / Provider を振り分け） |
| Provider の MySQL / Redis | `auth-provider-db` / `auth-provider-redis` |

## 取り込み元

取り込み元: `kuroweb/auth-provider` の `870262c767aef54bab2ca00a03163f5152c312ff`。アプリのコードを取り込み、Git 履歴は統合していない。
