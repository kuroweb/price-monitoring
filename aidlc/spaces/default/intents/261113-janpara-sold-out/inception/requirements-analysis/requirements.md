# 要件

売り切れたじゃんぱらの商品が、商品計測結果に販売中のまま残らないようにする。検索結果にまだ出ている商品は、売り切れにしない。

依頼の原文は `project-description.json` にある。判断は `inception/requirements-analysis/requirements-analysis-questions.md` の回答による。現状の販売状態、取得から表示までの流れ、コードの置き場所は、それぞれ `aidlc/spaces/default/codekb/price-monitoring/business-overview.md`、`aidlc/spaces/default/codekb/price-monitoring/architecture.md`、`aidlc/spaces/default/codekb/price-monitoring/code-structure.md` を参照した。

## 意図

商品モニタリングは `sold: false` の商品計測結果だけを販売中として読む。じゃんぱらの検索は売り切れを載せず、一覧に出た商品は常に `sold: false` になる。一覧から消えた商品は `fetch_detail` を持つサイトだけが `ProductMonitoring::DetailCandidates` で更新されるため、じゃんぱらの行は `sold: false` のまま残る。この修正は、その行を条件付きで売り切れにする。

## 機能要件

### FR1 検索から消えたじゃんぱらを売り切れにする

じゃんぱらの商品計測結果のうち、次をすべて満たす行は `sold: true` になる。

- その取得で、じゃんぱらの検索取得が成功している
- 行の最終更新から 3 時間以上たっている
- その取得のじゃんぱらの検索結果に、その行の `external_id` が無い

Given じゃんぱらの検索取得が成功している
And 商品計測結果の最終更新から 3 時間以上たっている
And その結果にその `external_id` が無い
When 商品計測の保存が終わる
Then その行の `sold` は `true` である

### FR1.1 取得が成功していないときは売り切れにしない

じゃんぱらの検索取得が成功していないとき、結果に無いことを理由に `sold` を `true` にしない。成功の判定は、`ProductMonitoring::DetailCandidates` がそのサイトの取得元を成功とみなす条件と同じにする。

Given じゃんぱらの検索取得が成功していない
And 既存の行が結果に無い
When 商品計測の保存が終わる
Then その行の `sold` は取得前のままである

### FR1.2 最終更新から 3 時間未満の行は売り切れにしない

最終更新は `product_crawl_results.updated_at` とする。間隔は `ProductMonitoring::DetailCandidates::DETAIL_RECHECK_INTERVAL`（3 時間）と同じにする。

Given じゃんぱらの検索取得が成功している
And 行の最終更新から 3 時間未満である
And その結果にその `external_id` が無い
When 商品計測の保存が終わる
Then その行の `sold` は `true` にならない

### FR1.3 検索結果にある商品は販売中のままにする

じゃんぱらの検索結果に含まれる商品は、これまでどおり `sold: false` で保存する。`ProductMonitoring::Sites::Janpara` が一覧に出た商品へ `sold: false` を付ける挙動は変えない。

Given じゃんぱらの検索結果にその `external_id` がある
When 商品計測の保存が終わる
Then その行の `sold` は `false` である

## 非機能要件

### NFR1 回帰テストで三つの境界を分ける

FR1、FR1.1、FR1.2、FR1.3 を、それぞれ自動テストで区別する。テストは既存の商品計測のサービススペックに足し、`docs/development/testing.md` と `AGENTS.md` の実行先に従って `backend` コンテナで実行する。

## 制約

- 対象はじゃんぱらの商品計測結果だけである。イオシスとトレファクは変えない。
- じゃんぱらに `fetch_detail` は足さない。売り切れにした行の `bought_date` は埋めない。
- 商品モニタリングが販売中として読む条件（`sold: false`）は変えない。
- メルカリ、Yahoo!フリマ、ヤフオクの個別確認は変えない。

## 仮定

- 最終更新は `product_crawl_results.updated_at` である。画面に出る別の時刻ではない。
- 取得の成功は、`DetailCandidates` が個別確認の対象を選ぶときの「そのサイトの取得元が成功している」と同じである。全プラットフォームの成否でじゃんぱらを止めない。
- `sold: true` にしたあとも行は残る。削除や除外（`excluded_at`）では表さない。

## 対象外

- イオシスとトレファクで、検索から消えた商品が販売中のまま残ること
- じゃんぱらの詳細ページ取得と、`bought_date` の推定
- 商品計測結果や商品モニタリング画面の表示変更
- 3 時間という間隔の変更
- 従来クロール（`Crawl::Janpara` と `janpara_products`）

## 未決事項

None.
