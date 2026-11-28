# 認証基盤の CI/CD と Kubernetes

認証基盤を本番・integration で運用する人向けに、CI/CD と Kubernetes 上の構成・手動作業を解説する。

変更検出・CI・CD・全イメージの手動デプロイは [CI/CD のパイプライン](../cicd/pipeline.md) を参照する。

Kubernetes マニフェストは k8s リポジトリの `manifests/price-monitoring` に統合する。環境ごとの namespace と全体構成は [ルート README](../../../README.md#production) を参照する。認証用の DB・Redis・Secret は `auth-provider-*` として分離する。

seed は development でだけ動くため、k8s の Provider DB には OIDC クライアントを手動で登録する。DB を新しく作ったときは、k8s ホストで BFF の `backend-secret` と同じ値を登録する。登録が無いと、ログイン・会員登録の後の認可が `invalid_client` になる。シークレットがプロセスの引数に残らないよう、値は標準入力で渡す。integration では namespace を `price-monitoring-integration`、`-e` を `integration` にする。

```bash
s() { kubectl -n price-monitoring-production get secret backend-secret -o jsonpath="{.data.$1}" | base64 -d; echo; }
{ s OIDC_CLIENT_ID; s OIDC_CLIENT_SECRET; s OIDC_REDIRECT_URI; } |
  kubectl -n price-monitoring-production exec -i deploy/auth-provider-deployment -- \
  ./bin/rails runner -e production 'uid, secret, redirect_uri = $stdin.read.split("\n"); Doorkeeper::Application.create!(uid:, secret:, name: "price-monitoring", redirect_uri:, scopes: "openid email profile", confidential: true)'
```

既存 PV の移行手順は k8s リポジトリの [auth-provider namespace 移行](https://github.com/kuroweb/k8s/blob/master/docs/operations/auth-provider-namespace.md) を参照する。実クラスタへの namespace 移行は、バックアップと手順確認後に実施する。
