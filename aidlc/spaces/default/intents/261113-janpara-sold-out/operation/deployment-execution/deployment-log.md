# デプロイ記録

クラスタへは出していない。`deployment-execution-questions.md` の回答は、マージを待つ記録だけにする、である。

## 状態

作業ブランチ `fix/janpara-sold-out-results` の変更は、`develop` にも `master` にも入っていない。承認した手順（`aidlc/spaces/default/intents/261113-janpara-sold-out/operation/deployment-pipeline/cd-config.md` と `deployment-strategy.md`）では、CD はそれらのブランチへの push で動く。イメージのビルド、レジストリへの push、k8s リポジトリのタグ更新、ArgoCD の同期は、実行していない。

## 前提

`aidlc/spaces/default/intents/261113-janpara-sold-out/construction/build-and-test/test-results.md` のローカルテストは成功している。マイグレーションは無い。Environment Provisioning はこの bugfix では作っていない。

## 次に出すとき

Pull Request をマージし、対象ブランチへの push で既存の CD が backend イメージを出す。戻し方は `rollback-runbook.md`。
