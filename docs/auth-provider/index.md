# 認証基盤

認証を開発・運用する人向けに、Provider / Client の境界と配置を解説し、認証固有の操作手順を案内する。
認証基盤は price-monitoring と同じリポジトリ・Docker Compose で管理する。OIDC Provider と Client は別の Rails アプリとし、モデル・DB・Redis を共有しない。

## 会員登録とログイン

アプリのヘッダーの「ログイン・新規登録」から BFF の OIDC 認証を開始し、Provider のログイン画面で新規登録を選ぶ。名前・メールアドレス・パスワードは Provider が受け取り、登録後に認可を続行する。BFF は認証成功時に Provider の識別子に対応するユーザーを作成し、アプリのトップへ戻す。パスワードは BFF や frontend に渡さない。

現状はメールアドレスの確認なしで登録でき、BFF の管理 API に会員ごとの権限分離はない。公開運用にはメール配送・確認と管理操作の認可方針を決める必要がある。

| 用途 | 配置 / Compose service |
| --- | --- |
| Client / BFF | `volumes/backend` / `backend` |
| Provider（Devise / Doorkeeper） | `volumes/auth-provider` / `auth-provider` |
| Provider の Dockerfile | `containers/auth-provider` |
| 共通の HTTPS proxy | `volumes/nginx` / `nginx`（ホスト名で BFF / Provider を振り分け） |
| Provider の MySQL / Redis | `auth-provider-db` / `auth-provider-redis` |

## 文書の案内

- [初回セットアップ](setup.md) — 新規環境の署名鍵・DB 準備と OIDC クライアント登録
- [認証の検証](verification.md) — テスト準備とログイン・ログアウトの確認
- [ローカル開発](../development/index.md) — セットアップ・日常操作・テストの案内
- [CI/CD と自動レビュー](../cicd/index.md)
- [文書全体の索引](../index.md)

## CI/CD と Kubernetes

変更検出・CI・CD・全イメージの手動デプロイは [CI/CD と自動レビュー](../cicd/index.md) を参照する。

Kubernetes マニフェストは k8s リポジトリの `manifests/price-monitoring` に統合する。環境ごとの namespace と全体構成は [ルート README](../../README.md#production) を参照する。認証用の DB・Redis・Secret は `auth-provider-*` として分離する。
既存 PV の移行手順は k8s リポジトリの [auth-provider namespace 移行](https://github.com/kuroweb/k8s/blob/master/docs/operations/auth-provider-namespace.md) を参照する。実クラスタへの namespace 移行は、バックアップと手順確認後に実施する。

取り込み元: `kuroweb/auth-provider` の `870262c767aef54bab2ca00a03163f5152c312ff`。アプリのコードを取り込み、Git 履歴は統合していない。
