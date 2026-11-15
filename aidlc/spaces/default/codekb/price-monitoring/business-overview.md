# Business Overview

> この文書は調査時点の記録であり、その後の販売状態同期の変更を反映していない。現行動作は `docs/backend/product-monitoring-poc.md` を参照する。

Web 上の商品の最安値と相場を、自宅のホームラボで調べる。画面は Next.js、API と取得バッチは Rails、ログインは別 Rails の OIDC Provider である。

## 利用者が行うこと

- 計測対象の商品と、プラットフォームごとの従来クロール条件を管理する
- 商品計測設定に検索語とサイト、または追加の検索結果 URL を登録し、取得結果を見る
- 商品モニタリング設定の条件で、販売中の安い出品と日次の相場を見る
- Backmarket の監視対象を登録する

商品計測の画面は `/product-crawl-results`、商品モニタリングは `/product-monitoring`。有効な商品計測設定は 10 分ごと、相場集計は毎日 0 時、モニタリング評価は 10 分ごとに Sidekiq が動かす（`volumes/backend/config/schedule.yml`）。

## 販売状態

商品計測結果の `sold` は三値である。`false` は販売中、`true` は売り切れ、`nil` は未設定。カラム定義は `null: true` の boolean（`db/schema.rb` の `product_crawl_results`）。`price` は `null: false, default: 0` の integer で、価格が取れない出品は新規行として保存できない。

商品モニタリングが販売中として読むのは `sold: false` だけである（`ProductMonitoring::LowestListings.candidates`）。相場集計が買うのは、除外されておらず `bought_date` がある結果である。

サイトごとの現状は次のとおり（2026-11-14、head `efe22f77`）。

| サイト | 一覧の `sold` | 検索から消えた行の売り切れ化 | `fetch_detail` |
| --- | --- | --- | --- |
| メルカリ | 売り切れ画像の有無 | `DetailCandidates` が個別確認へ回す | あり。JSON-LD と削除表示 |
| Yahoo!フリマ | `alt="sold"` の有無 | 同上 | あり。JSON-LD |
| ヤフオク | 落札相場の一覧だけ `true`。出品中は `false` | 無し | なし |
| イオシス | 常に `false` | 無し | なし |
| じゃんぱら | 常に `false`（`.search_nostock` などの売り切れ表示は参照しない） | `SyncCrawlResults#sync_janpara_sold` が売り切れにする | なし |
| トレファク | 価格のある出品だけを残し、その `sold` は `false`。売り切れ DOM は一覧から外す | 無し | なし |

じゃんぱらの検索結果に出ている商品グループは、`SRCODE` または `ITMCODE` を `external_id` にし、下限価格を価格にする。`listing` は `sold: false` を固定で付ける。個別の店舗在庫や販売状態は見ていない（`docs/backend/product-monitoring-poc.md` と `Sites::Janpara`）。

保存時、価格が取れた結果だけが `save_matched` の対象になり、`update_sold` は今回の結果に含まれる ID を更新する。`sold: true` の結果は該当行を `true` にする。`sold: false` の結果は、既存の `sold` が `nil` の行だけを `false` にする。つまり汎用の経路では、売り切れの行は一覧に再び出ても販売中へ戻らない。重複更新の SQL は名前・URL・価格などを上書きし、`sold` 列は代入しない。新規行の INSERT だけが結果の `sold` を持つ。

じゃんぱらだけは、`save_matched` のあとに `sync_janpara_sold` が同じトランザクションで動く。入力は `crawled[:results]` の全件で、価格なし・条件不一致・除外の結果も含む。

- 検索に返った ID の既存行は、結果の `sold` に関係なく `sold: false` に戻る（売却済みの行も販売中へ戻り、`bought_date` は残る）
- じゃんぱらの source が 1 件以上あり、そのすべてが `succeeded` のとき、検索に返らなかった ID で最終更新から 3 時間以上たつ行を `sold: true` にする。`updated_at` と `bought_date` は変えない。他サイトの失敗と未対応 URL（`platform` が nil の source）は、この判定に影響しない。除外済みの行も対象になる

この経路は、コミット 55be0347 と e8c2bfd0（PR #185）で入った。これらより前は、検索から消えたじゃんぱらの行が `sold: false` のまま商品モニタリングの販売中に残っていた。一覧に残っている SOLD OUT 表示の商品は、今も販売中のまま残る。理由は、一覧が `sold: false` を返すこと、`sold: true` を返しても `sync_janpara_sold` が後から `false` に戻すこと、価格が表示されない出品は `save_matched` が捨てる一方で「検索に返った」扱いになり既存行が `false` のまま残ること、の 3 点である。

`fetch_detail` を持つサイトの個別確認は `DetailCandidates` が担う。条件は、そのサイトの取得元が成功していること、最終更新から 3 時間以上たっていること、そして `sold` が true ではないこと、または売り切れだが `bought_date` が空であること。1 回の上限は 50 件。じゃんぱらに `fetch_detail` は無いので、この候補には入らない。行が条件に一致する限り `CleanseCrawlResults` も消さない。

従来の計測対象クロール（`Crawl::Janpara` と `janpara_products`）は、この `sold` とは別のテーブルである。あちらに `sold` の代入は無い。
