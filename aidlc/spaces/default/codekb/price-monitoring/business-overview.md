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

保存時の通常処理は `sold: false` を既存の `nil` にのみ反映する。じゃんぱらは別途、検索結果に戻った行を販売中へ戻し、同サイトの取得元が１件以上かつ全て成功した場合に、取得結果に無く最終更新から３時間以上の行を売り切れとする。価格なしの結果も存在確認に含める。売却日や更新日時は変更しない。イオシスには同様の処理がなく、検索から消えても販売中のまま残る。

従来の計測対象クロール（`Crawl::Janpara` と `janpara_products`）は、この `sold` とは別のテーブルである。あちらに `sold` の代入は無い。
