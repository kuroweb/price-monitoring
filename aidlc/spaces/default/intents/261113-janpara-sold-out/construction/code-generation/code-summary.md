# Code Summary

## 変更したファイル

- `volumes/backend/app/services/product_monitoring/sync_crawl_results.rb`
- `volumes/backend/spec/services/product_monitoring/sync_crawl_results_spec.rb`
- `aidlc/spaces/default/intents/261113-janpara-sold-out/construction/code-generation/code-generation-plan.md`（ステップのチェックのみ）

## 実装

`SyncCrawlResults#call` は保存のあと、今回の商品計測設定のじゃんぱら行だけを更新する。見る ID は、その取得が返したじゃんぱらの `external_id` である。取得成功の判定は `DetailCandidates#complete_sources?` と同じ式を、このクラスに写した。

成功していて `updated_at` が 3 時間以上前、かつ結果に無い行は `sold: true` にする。結果にある行は `sold: false` に戻す。`update_all` は `sold` だけを代入し、`bought_date` と `updated_at` は変えない。他のサイト、`Sites::Janpara` の一覧、`DetailCandidates#enqueue` は変えていない。

## テスト

`just rspec-backend spec/services/product_monitoring/sync_crawl_results_spec.rb`

25 examples, 0 failures。既存 21 例に、FR1、FR1.1、FR1.2、FR1.3 の 4 例を足した。この段階で実行していないテストは無い。

## 計画との差

無し。
