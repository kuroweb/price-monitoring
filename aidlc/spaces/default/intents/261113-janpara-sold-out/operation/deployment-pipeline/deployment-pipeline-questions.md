# Deployment Pipeline Questions

## Q1. What your documents already answer

- デプロイは既存の GitHub Actions と ArgoCD が行い、AWS は使わない。根拠は `aidlc/spaces/default/memory/project.md` の Deployment と `docs/cicd/index.md`。
- Integration は `develop` への push、Production は `master` への push。全イメージの手動デプロイは `workflow_dispatch` だけ。根拠は `docs/cicd/index.md` の「環境と実行契機」。
- この修正は `volumes/backend` のアプリケーションコードだけで、workflow と Kubernetes マニフェストは変えない。CD は既存の backend イメージの経路に乗る。根拠は `docs/cicd/index.md` の「変更検出と CI/CD」。
- 戻すときは、k8s リポジトリの対象環境のイメージタグを前のタグに戻して push し、ArgoCD の同期でクラスタへ戻す。根拠は同文書の CD 手順の逆。

A. All correct
B. Some need changing (say which and how)
X. Other (please specify)

[Answer]: A. All correct
