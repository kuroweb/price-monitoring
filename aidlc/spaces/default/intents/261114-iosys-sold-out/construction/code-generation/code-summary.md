# 実装結果

## 変更ファイル

- `volumes/backend/app/services/product_monitoring/sync_crawl_results.rb`: じゃんぱらの販売状態同期をサイトごとに適用し、イオシスを対象に追加。
- `volumes/backend/spec/services/product_monitoring/sync_crawl_results_spec.rb`: 消失、再出現、価格なし、取得失敗、対象の隔離、3時間の境界を検証。オークションの既存テストは実際のサイトに合わせた。
- `docs/backend/product-monitoring-poc.md`: 同期条件とページ数制限を記載。

## 実装方針

検索結果に戻った商品を販売中にし、対象サイトの取得元が1件以上かつ全件成功した場合に3時間以上前に更新され未出現の商品を売り切れとする。検索元が失敗した場合は消失と判定しない。変更は計測設定とサイトで限定し、売却日と更新日時を変更しない。Datadog と BugSnag の設定には変更なし。

## 検証

- 変更前の backend 全体: 426 examples、0 failures、1 pending。
- 変更後の対象 spec: 32 examples、0 failures。
- 変更後の backend 全体: 432 examples、0 failures、1 pending。
- 対象2ファイルの RuboCop: 問題なし。
- 未実行の計画テスト: なし。

## 差異

初回起動時に nginx のポート 8444 が競合し、`just up` は失敗した。backend・MySQL・Redis は稼働したため、コンテナ内のテストは実行できた。初回 RSpec は test DB 不在で失敗したため、backend コンテナで `RAILS_ENV=test` の `db:prepare` を実行後に再実行した。
