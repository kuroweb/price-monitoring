# Code Quality Assessment
 
2026-11-15 の重点再調査で確認した範囲は reverse-engineering-timestamp.md を参照。それ以外の記述は以前の調査記録であり、今回の深い検証対象外。

対象は商品計測の重点調査。実行やカバレッジ測定はしていない。

## テストと Lint

`crawler_spec.rb` はページ上限、空ページ、重複、部分失敗、絞り込みを検証する。`sync_crawl_results_spec.rb` は保存、除外、売却状態、個別確認候補、サイト別の失敗・打ち切りや3時間境界を検証する。ジョブや API の spec も存在する。lint と CI は今回実行していない。

## 文書

`docs/features/product-monitoring/index.md` に仕様、取得制約、API がある。

## 技術的負債

`Crawler` は取得元と結果をハッシュで渡し、`SyncCrawlResults` は MySQL 固有 upsert とサイト別状態遷移を一箇所で扱う。サイトを跨ぐ external_id の衝突可能性、設定更新と取得の並行性、`updated_at` の意味について詳細確認が必要。発生実績は未確認。
