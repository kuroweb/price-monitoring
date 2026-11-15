# Unit Test Instructions

ゼロ Unit の bugfix。Test Strategy は Minimal、方法論は test-after（実装してから、その層のテストを書いて実行する）。

## Test framework setup

- RSpec（`rails_helper`）と FactoryBot。既存の設定をそのまま使い、新しい設定やテスト依存は追加しない。
- 実行は Docker Compose の `backend` コンテナ（`just rspec-backend`）。ホストで `bundle` / `rspec` を直接実行しない。
- コンテナが起動していなければ、先に `just ps` で状態を確認し、未起動なら `just up` を実行する。

## How to run this work's tests

Step 1 で最初に実行する、変更前の基準を取るコマンドと同じものを、変更後にも実行する。

```bash
just rspec-backend spec/services/product_monitoring/sites/janpara_spec.rb spec/services/product_monitoring/sync_crawl_results_spec.rb
```

静的検証:

```bash
just rubocop-backend app/services/product_monitoring/sites/janpara.rb app/services/product_monitoring/sync_crawl_results.rb spec/services/product_monitoring/sites/janpara_spec.rb spec/services/product_monitoring/sync_crawl_results_spec.rb
```

失敗したら対象の spec だけを再実行し、必要に応じて `just logs` で依存サービスの状態を確認する。

## Tests to add (Minimal: one per requirement, plus the bugfix regression)

| テスト | 層 | 確かめること | 要件 |
|---|---|---|---|
| `sites/janpara_spec.rb`: 価格のない SOLD OUT 表示を売り切れとして取得する | 取得（一覧の解釈） | `.search_nostock` を持つ商品が `external_id: "ITMCODE=313448"`・`price: nil`・`sold: true` で返る | FR1.1、FR1.3、NFR2(a) |
| `sync_crawl_results_spec.rb`: 検索結果で価格のない売り切れ商品を即時に売り切れにする | 保存 | 価格なし・`sold: true` の結果が既存行を売り切れにし、`updated_at`・`bought_date`・他サイトの行を変えない | FR2.1、FR2.3、FR2.4、NFR2(b) |

既存の例は変更しない。特に次の例は、変更後もそのまま通ることを確認する。

- `sync_crawl_results_spec.rb` の「検索結果にある売却済みの行を販売中へ戻す」例（`bought_date` を保持。FR2.2）
- `describe "じゃんぱらの売り切れ"` の、検索から消えた行・取得元が無い場合・取得失敗・3 時間未満の例（FR3）

## Expected coverage

行カバレッジの下限は設定しない（bugfix は targeted regression と既存 suite の維持が床）。変更した 2 つのコード経路（`Janpara.listing` の `sold`、`sync_janpara_sold` の返却行の更新）は上の 2 件で通る。

## Mocking and test data

- 取得側は `fetch_page` をスタブして HTML を直接渡す（既存の `janpara_spec.rb` と同じ）。実サイトにはアクセスしない。
- 保存側は FactoryBot の `create(:product_crawl_result, ...)` で行を作り、`Crawler.call` のスタブで `sources` と `results` を渡す（既存の `describe "じゃんぱらの売り切れ"` と同じ）。

## Manual verification on the real site (Build and Test)

テストとは別に、NFR3 として、実例 `ITMCODE=313448` を実物のクローラーで取得し、`sold: true`・`price: nil` になることを確認する。取得はプロキシ経由の `BrowserPage.fetch` に限り、直接 IP からは取得しない。SOLD OUT のときに `.item_amount` が残るかも、この確認で確かめる。
