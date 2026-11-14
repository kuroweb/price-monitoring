# CD の設定

この修正は新しい CD を足さない。既存の経路に乗る。CI Pipeline と Infrastructure Design はこの bugfix では作っていない。根拠は `docs/cicd/index.md` と `aidlc/spaces/default/memory/project.md` の Deployment。

## 契機

| 環境 | 契機 | workflow |
| --- | --- | --- |
| Integration | `develop` への push、または手動実行 | `.github/workflows/cicd-integration.yml` |
| Production | `master` への push、または手動実行 | `.github/workflows/cicd-production.yml` |
| 全イメージの手動 | `workflow_dispatch` のみ | `.github/workflows/deploy-integration.yml`、`deploy-production.yml` |

Pull Request では `.github/workflows/ci-pr.yml` が、`volumes/backend/**` または `containers/backend/**` の変更に対して RuboCop と RSpec を実行する。デプロイはしない。

## この修正が通る経路

変更は `volumes/backend/app/services/product_monitoring/sync_crawl_results.rb` と、そのスペックである。spec 以外のアプリファイルが変わるので、マージ先への push では backend の CI のあと CD が走る。

共通処理は `.github/workflows/reusable-cd.yml`。

1. GitHub Actions runner を Tailscale に接続する。
2. runner 上の make / Docker Buildx で backend イメージをビルドし、レジストリへ push する。
3. `kuroweb/k8s` の `manifests/price-monitoring` で、対象環境のイメージタグを更新して push する。競合時は最新の `master` を取り直し、最大 5 回試行する。
4. ArgoCD がマニフェストを同期し、自宅の Kubernetes クラスタへ適用する。

AWS は使わない。workflow ファイルと Kubernetes マニフェストは、この修正では変えない。
