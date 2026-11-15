# テスト手順

RSpec と既存の Rails 設定を使う。ホストから `just ps` で状態を確認し、必要なら `just up` を実行する。以下はリポジトリルートから実行し、backend コンテナ内で RSpec が動く。

```bash
just rspec-backend spec/services/product_monitoring/crawler_spec.rb spec/services/product_monitoring/sites spec/services/product_monitoring/sync_crawl_results_spec.rb spec/services/product_monitoring/filter_spec.rb spec/services/product_monitoring/calculate_aggregation_results_spec.rb spec/services/product_monitoring/lowest_listings_spec.rb spec/services/product_monitoring/watch_listings_spec.rb spec/sidekiq/product_monitoring/crawl_detail_job_spec.rb spec/sidekiq/product_monitoring/crawl_job_spec.rb spec/requests/product_crawl_settings_spec.rb
```

新たに spec を追加した場合は、そのパスも対象に加えて実行する。要件ごとに検証可能なテストを確保し、追加するコンポーネントに正常系を含める。既存テストを維持し、全体の既存スイートも Build and Test で確認する。数値カバレッジ下限はこの作業では指定されていない。

外部サイト取得は既存 spec に合わせてスタブし、DB 更新・MySQL の upsert とトランザクションは実際のテスト DB で検証する。時刻境界は既存の時刻制御とテストデータ作成パターンに従う。実サイトや通知先に接続しない。
