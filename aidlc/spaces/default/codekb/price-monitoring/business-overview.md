# Business Overview

Web 上の商品の最安値と相場を、自宅のホームラボで調べる。画面は Next.js、API と取得バッチは Rails、ログインは別 Rails の OIDC Provider である。

## 利用者が行うこと

- 計測対象の商品と、プラットフォームごとの従来クロール条件を管理する
- 商品計測設定に検索語とサイト、または追加の検索結果 URL を登録し、取得結果を見る
- 商品モニタリング設定の条件で、販売中の安い出品と日次の相場を見る
- Backmarket の監視対象を登録する

商品計測の画面は `/product-crawl-results`、商品モニタリングは `/product-monitoring`。有効な商品計測設定は 10 分ごと、相場集計は毎日 0 時、モニタリング評価は 10 分ごとに Sidekiq が動かす（`volumes/backend/config/schedule.yml`）。

## 販売状態

商品計測結果の `sold` は三値である。`false` は販売中、`true` は売り切れ、`nil` は未設定。カラム定義は `null: true` の boolean（`db/schema.rb` の `product_crawl_results`）。

商品モニタリングが販売中として読むのは `sold: false` だけである（`ProductMonitoring::LowestListings.candidates`）。相場集計が買うのは、除外されておらず `bought_date` がある結果である。

サイトごとの現状は次のとおり。

| サイト | 一覧の `sold` | `fetch_detail` |
| --- | --- | --- |
| メルカリ | 売り切れ画像の有無 | あり。JSON-LD と削除表示 |
| Yahoo!フリマ | `alt="sold"` の有無 | あり。JSON-LD |
| ヤフオク | 落札相場の一覧だけ `true`。出品中は `false` | なし |
| イオシス | 常に `false` | なし |
| じゃんぱら | 常に `false` | なし |
| トレファク | 価格のある出品だけを残し、その `sold` は `false`。売り切れ DOM は一覧から外す | なし |

じゃんぱらの検索結果に出ている商品グループは、`SRCODE` または `ITMCODE` を `external_id` にし、下限価格を価格にする。`listing` は `sold: false` を固定で付ける。個別の店舗在庫や販売状態は見ていない（`docs/backend/product-monitoring-poc.md` と `Sites::Janpara`）。

保存時、今回の結果に含まれる ID だけが `update_sold` の対象になる。`sold: true` の結果は該当行を `true` にする。`sold: false` の結果は、既存の `sold` が `nil` の行だけを `false` にする。重複更新の SQL は名前・URL・価格などを上書きし、`sold` 列は代入しない。

一覧から消えた行は、`fetch_detail` を持つサイトに限り `DetailCandidates` が個別確認へ回す。条件は、そのサイトの取得元が成功していること、最終更新から 3 時間以上たっていること、そして `sold` が true ではないこと、または売り切れだが `bought_date` が空であること。1 回の上限は 50 件。じゃんぱらに `fetch_detail` は無いので、検索結果から消えたじゃんぱらの行はこの候補に入らない。行が条件に一致する限り `CleanseCrawlResults` も消さない。結果として `sold: false` のまま商品モニタリングの販売中に残る。

従来の計測対象クロール（`Crawl::Janpara` と `janpara_products`）は、この `sold` とは別のテーブルである。あちらに `sold` の代入は無い。
