# コード変更の概要

イオシスとじゃんぱらの一覧中の販売状態の反映と、完全取得後に消えた古い出品の売り切れ判定を `SyncSearchSoldStatus` に分離した。`SyncCrawlResults` は同じトランザクション内でサイトごとに呼ぶ。SQL の条件、時刻、ジョブと API は変更していない。

抽出クラスに、完全な取得、取得失敗と一覧反映の共存、同一出品の相反する表示についての spec を追加した。既存の同期 spec は打ち切り、価格なし、更新から3時間の境界、再出現と他サイト・他設定への影響を検証する。

変更前: 対象 135 examples、0 failures。変更後: 新規 3 件を含む 138 examples、0 failures。変更した3ファイルの RuboCop は違反なし。初回実行時に test DB がなかったため、backend コンテナで test 環境の `db:prepare` を実行した。nginx はホストポート競合で起動しなかったが、backend・DB・Redis は起動してテストを実行できた。

追加の変更として、イオシスとじゃんぱらが `sync_search_sold_status` を定義し、共通同期処理は登録済みサイトが持つ能力に基づき登録順に呼ぶ。処理は同一トランザクションで行う。残る4サイトには不要な状態反映メソッドを加えず、詳細確認対象は既存の `fetch_detail` 判定を維持する。サイト追加時の状態反映の定義方法を機能文書に追記した。

追加分の検証: 対象 141 examples、0 failures。状態反映対象の6サイトの選択、途中失敗時のロールバック、サイトをまたぐ詳細ジョブの古い順の上限と引数を追加確認。処理順の変更後、関連 88 examples と変更した2ファイルの RuboCop は成功。ロールバックテストは、先行更新が実際に行われた後での失敗を確認した。ログ・通知・Datadog・BugSnag の処理は変更していない。外部 API、操作、構成とスキーマに変更はない。サイト単位のジョブ分割や ID の扱いは対象外。

`crawler.rb` の重複した `require "timeout"` を削除した。既存の crawler spec は11 examples、0 failures。

商品計測配下の `nokogiri` 6件、`uri`・`digest`・`net/http` 各1件の明示 require も削除した。変更後、test と development の Rails 起動直後に各定数が解決することを確認した。アプリの `rails/all` と Bundler による読み込みに依存するため、依存の将来の変更に伴う読み込み順の保証ではない。関連サービス・ジョブ・リクエスト spec は174 examples、0 failures、変更9ファイルの RuboCop は違反なし。
