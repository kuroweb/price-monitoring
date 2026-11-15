# Requirements: じゃんぱらの検索結果の SOLD OUT 表示を売り切れとして反映する

## Sources

- [desc] Initial description: じゃんぱらの検索結果に表示される売り切れ商品を正しく売り切れにする。実例は検索結果 URL（`KEYWORDS=mac+studio`）の `ITMCODE=313448` で、一覧の `.search_nostock` に SOLD OUT、詳細に在庫 0 点と表示される。旧実装は一覧商品を常に `sold: false` にし、検索に存在する商品を販売中へ戻す。
- [scope] Workflow-selected scope: bugfix（デプロイ系ステージは対象外）
- 既存コードの調査結果: `aidlc/spaces/default/intents/261114-janpara-listed-sold/inception/reverse-engineering/developer-scan.md`
- 上流の code knowledge base（`aidlc/spaces/default/codekb/price-monitoring/`）
  - `business-overview.md`: 商品計測は取得結果を `product_crawl_results` に保存し、最安値の対象は `sold: false` の出品に限る
  - `architecture.md`: 取得（`Sites::*`、`Crawler`）と保存（`SyncCrawlResults`）の分担、じゃんぱらだけ保存側で売り切れを補う二重構造
  - `code-structure.md`: `volumes/backend/app/services/product_monitoring/` と対応する `spec/` の配置

## Intent Analysis

SOLD OUT と表示されたじゃんぱらの商品が、販売中のまま残る。原因は次の 3 つで、いずれも直さないと直らない。

1. 一覧の解釈が `.search_nostock` を見ず、常に `sold: false` を返す（`sites/janpara.rb:69`）。
2. 一覧が `sold: true` を返しても、保存後の `sync_janpara_sold` が検索に返った既存行を `sold: false` に戻す（`sync_crawl_results.rb:102`）。
3. SOLD OUT になると価格が表示されない出品は、`save_matched` が価格 nil を捨てるため保存経路では更新されない。一方で検索結果の ID には含まれるので、検索から消えるまで売り切れにならない。

目的は、検索結果に SOLD OUT で残っている既存の出品を、その取得で売り切れにすること。

## Functional Requirements

### FR1: じゃんぱらの一覧で売り切れ表示を読み取る

- FR1.1: 一覧の商品が `.search_nostock` を持つとき、その出品の `sold` を `true` にする。
- FR1.2: `.search_nostock` を持たない商品は `sold` を `false` にする（従来どおり）。
- FR1.3: SOLD OUT で価格が表示されない商品も、`price: nil`・`sold: true` の取得結果として返す。価格が取れないこと自体は取得失敗にしない。

### FR2: 検索結果にある既存の出品へ売り切れを反映する

- FR2.1: 検索結果に `sold: true` で出た既存の出品を、価格の有無にかかわらず、その取得で `sold: true` にする。
- FR2.2: 検索結果に `sold: false` で出た既存の出品は、従来どおり `sold: false` にする。これは、売り切れで検索に残っていた出品が販売再開として出たときに販売中へ戻す挙動で、`bought_date` は保持する。
- FR2.3: FR2.1 と FR2.2 は、`updated_at` と `bought_date` を変更しない。
- FR2.4: 同じ `external_id` でも、別のサイトの出品や別の商品計測設定の出品は変更しない。
- FR2.5: 判定には価格なし・条件不一致・除外済みの結果も含める（`sync_janpara_sold` が `crawled[:results]` の全件を入力にする現状を保つ）。

### FR3: 検索から消えた出品の売り切れ化を保つ

- FR3.1: じゃんぱらの検索元が 1 件以上あり、そのすべての取得が成功したとき、検索結果から消えて最終更新から 3 時間以上経った出品を売り切れにする従来の挙動を変えない。
- FR3.2: 取得元が無い場合、または一部が失敗した場合は、FR3.1 を実行しない（従来どおり）。

### FR4: 文書

- FR4.1: `docs/backend/product-monitoring-poc.md` の、一覧にある出品の販売状態を述べた箇所を、じゃんぱらは一覧の売り切れ表示を反映する内容に直す。
- FR4.2: 同文書の、検索から消えた出品の売り切れ化を述べた箇所に、検索に残る売り切れ表示は価格がなくても既存の出品に反映することを加える。他サイトの記述は変えない。

## Non-Functional Requirements

- NFR1（回帰）: 既存のじゃんぱら関連の spec は、意図した挙動の変更に当たる例を除いて通ったままにする。FR2.2 を固定する既存の例（検索に残る売却済みの行を販売中へ戻し、`bought_date` を保持する）は、そのまま通る。
- NFR2（回帰テスト）: bugfix の床として、次の 2 点を再現する例を追加する。(a) 価格のない `.search_nostock` の一覧が `sold: true`・`price: nil` になる。(b) `sold: true` の取得結果が、価格なしでも既存行を即時に売り切れにし、`updated_at`・`bought_date`・他サイトの行を変えない。
- NFR3（実サイトでの確認）: 実例 `ITMCODE=313448` を、実物のクローラーでプロキシ経由で取得し、`sold: true`・`price: nil` になることを確認する。直接 IP からは取得しない。
- NFR4（実行場所）: テストと RuboCop は Docker Compose のコンテナで実行する。ホストでアプリ用の依存を入れ替えない。
- NFR5（変更の閉じ方）: 変更は `volumes/backend` の取得と保存、その spec、`docs/backend/product-monitoring-poc.md` に閉じる。Datadog・BugSnag の連携、クロール設定、画面には影響しない。

## Constraints

- 本修正はイオシスの修正（PR #186）と混ぜない。作業ブランチは `kuroweb/janpara-listed-sold` で、基点の `master` にはイオシス修正は入っていない。そのため、イオシス側で一般化された保存処理（`sync_search_sold` 等）ではなく、この基点の `sync_janpara_sold` を直す。
- 取得は既存の `Crawl::Client` と動的プロキシ経由に限る。
- 元のワークスペース（`iosys-sold-out`）の未コミット変更・記録は変更しない。
- デプロイは行わない。

## Assumptions & Open Questions

- [assumption] SOLD OUT で価格が表示されない出品は、すでに保存済みの行がある場合だけ売り切れに更新する。保存済みの行が無い出品を新規に作ることはしない。根拠: 保存列 `price` は `null: false` で、価格 nil の結果は従来どおり保存対象外のため（FR2.1、`developer-scan.md` の観点 7）。
- [assumption] 一覧の SOLD OUT 判定は `.search_nostock` の有無だけで行う。リポジトリ内にこの DOM の fixture は無く、実例のデータ（依頼文）と実サイトの確認（NFR3）を根拠にする。
- Open question: SOLD OUT のときに `.item_amount` が残るかは未確認。残る場合、一覧は `price` を持つ `sold: true` として返り、FR2.1 の通常の保存経路でも売り切れになる。実装段階の NFR3 の確認で確かめる。
