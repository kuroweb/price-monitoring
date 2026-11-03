# worktree開発構成の判断

操作手順の正本は [ローカル開発](docs/development/index.md)、[認証の初回準備と再構築](docs/auth-provider/setup.md)、[認証の検証](docs/auth-provider/verification.md)。この文書は、コードを読んでも追えない判断と検証結果だけを残す。

## 判断

メインと worktree は同じホスト名と証明書を使う。Cookie はポートで分かれないので、公開ポートと Cookie 名でセッションを分ける。公開が必要なのはブラウザから届く nginx だけで、Redis / Playwright / Camoufox は Compose ネットワーク内で足りる。

OIDC の開発用クライアントは Compose を正本にする。`.env` に置くと、BFF の `env_file` と Compose の `environment` と seed の間で同じ値を重ねることになる。batch は Web 用 OIDC を使わないので渡さない。

issuer の入力形式は揃えていない。Provider の `DOMAIN_NAME` はメール設定と本番の契約に使われ、BFF は完全な issuer URL を必要とする。揃える変更はこの範囲に含めず、解決した URL が一致することだけを確認する。

ブラウザの API 起点をビルド時に固定すると、worktree のポートとずれる。未設定のときはページの origin を使い、明示した `NEXT_PUBLIC_API_URL` は本番などの別 origin のために優先する。Next.js サーバーから BFF への接続は公開ポートに依存させない。

`localhost:8080` は開発環境で frontend を公開しなくなったため、development の CORS から外した。固定 IP の用途は未確認で、production / integration の既存許可と一緒に残す。

seed は既存のクライアント登録を更新しない。設定変更と初回準備を同じ操作にすると、ローカル DB を意図せず作り直す。`just prepare` はデータを消さない。設定を変えたら、利用者が Provider DB の再作成手順を実行する。

scope が複数箇所で定義されていること、`.env` の一括配布、setup の同時実行制御は、今回は対応しない。setup は他アプリの使用中ポートを見ない。hosts・TLS 証明書・Provider 署名鍵の準備は引き続き必要。本番の Cookie 名・デプロイ用タスク・Datadog / BugSnag 設定は変更しない。

## 検証

対象は起動中のメイン `https://dev.price-monitoring.com` と worktree `https://dev.price-monitoring.com:8443`。メインは再起動前の既存クライアント設定のまま、worktree は Compose の開発用クライアントで確認した。

| 確認 | 結果 |
| --- | --- |
| discovery | メインの issuer はポートなし。worktree は各 endpoint に `:8443` |
| ログインと Cookie | 両方で Provider 認証後に BFF へ戻った。接尾辞なしと `_8443` の Cookie が共存し、片方の BFF をログアウトしても他方は維持された。逆方向も同じ |
| Provider セッション | BFF ログアウト後の worktree 再ログインはパスワード入力を省略した |
| remember | 両方で有効にした。worktree の Provider セッション Cookie だけを失効させてもダッシュボードへ戻り、メインの Provider はログイン維持 |
| 画面と API | worktree の `/products` から同一 origin の products API が 200 JSON |
| HMR | サイドバーを開いたままヘッダー文言の一時変更が反映された。確認後に文言を戻した |
| token 更新 | 画面上の残時間は約2時間で、5分前の更新枠までは待っていない。成功・失敗・タイムアウト・再試行は既存の `oidc_token_control_spec` |

Compose の解決値、batch 3プロセスの起動、`just prepare`、seed と BFF 認証の RSpec、frontend のテスト、CORS の development と production / integration の差は、変更後に確認済み。
