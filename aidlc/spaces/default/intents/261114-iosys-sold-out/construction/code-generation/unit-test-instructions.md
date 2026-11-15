# テスト手順

RSpec と既存の Rails テスト設定を使用する。コンテナの状態は `just ps` で確認し、必要なら `just up` で起動する。

対象テスト: `just rspec-backend spec/services/product_monitoring/sync_crawl_results_spec.rb`

既存の crawler スタブと DB データを使い、イオシスの取得成功・失敗、全検索元、3時間の境界、再出現、価格なし、他サイト・他設定への影響を検証する。外部サイトへの接続は行わない。要件ごとに少なくとも1件の検証を行い、既存テストも維持する。追加のカバレッジ率の数値目標はない。
