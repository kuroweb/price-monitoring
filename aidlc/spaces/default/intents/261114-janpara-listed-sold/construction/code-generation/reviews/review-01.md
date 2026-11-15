## Review

**Verdict:** READY
**Reviewer:** aidlc-architecture-reviewer-agent
**Date:** 2026-11-15T00:41:51Z
**Iteration:** 1
**Verdict Dictated:** no

### Findings

| ID | Severity | Location | Finding | Required action | Status |
|---|---|---|---|---|---|
| R-01 | Minor | volumes/backend/spec/services/product_monitoring/sync_crawl_results_spec.rb > describe "じゃんぱらの売り切れ" | `update_janpara_sold` のコメントは「同じ出品が売り切れと販売中の両方で返るときは、販売中を後に適用する」と述べ、`[true, false]` の順序はその仕様に依存するが、この順序を固定する例が無い。順序を `[false, true]` に入れ替えても全例が通る。 | 同じ `external_id` が `sold: true` と `sold: false` の両方で返る例を1件足すか、順序の仕様を意図的に固定しないならコメントを削る。 | New |
| R-02 | Minor | volumes/backend/app/services/product_monitoring/sync_crawl_results.rb > update_janpara_sold | 旧実装は検索に返った行を一律 `sold: false` にしていたが、新実装は結果の `sold` が `true`/`false` のものだけを更新する。`sold` キーが無い（nil の）結果は、旧実装では販売中に戻っていたが、今は何も更新されない。`Sites::Janpara.listing` は常に真偽値を返すため現行の経路では起きない。 | 現行では対応不要。意図した縮小であれば code-summary.md の実装判断に1行残すと、後の読み手が迷わない。 | New |
| R-03 | Minor | docs/backend/product-monitoring-poc.md > じゃんぱらの取得を述べた段落（47行目付近）と追加項目 | 47行目の「個別の店舗在庫や販売状態は確認しない」は残っている。追加した項目は一覧の売り切れ表示を反映するため、読み手には矛盾に見える。「個別」と限定されているので誤りではない。計画 Step 6(b) の追記先が基点に無かったため新しい項目を足した、という code-summary.md の Deviations の扱いは妥当。 | 47行目を「個別ページの店舗在庫は確認しない。一覧の売り切れ表示だけを反映する」のように言い換えるか、現状のままでよいか判断する。 | New |
| R-04 | Minor | aidlc/spaces/default/intents/261114-janpara-listed-sold/construction/code-generation/traceability.json > NFR4 | NFR4（コンテナでの実行）の対象が `docs/development/testing.md` になっている。このファイルは今回変更しておらず、実在はするが、実装の証拠ではなく手順の文書である。code-summary.md に実行結果（29例から31例、0失敗、RuboCop no offenses）が記載されているため、実行は裏付けられている。 | 対象を code-summary.md の Test coverage summary に変えるか、現状の対応づけで足りるか判断する。 | New |

### Validation Tool Results

| Tool | Result | Interpretation |
|---|---|---|
| コードの読み取り（git diff、`sync_crawl_results.rb` 全文、`sites/janpara.rb`、spec の該当箇所） | 実行せず、読み取りのみ | テスト実行はこのレビューの対象外。結果は code-summary.md の記載（31例・0失敗、RuboCop no offenses）と、読んだコードの整合で判断した。矛盾は見つからなかった。 |

**確認した観点**

- FR1: `.search_nostock` の有無が `sold` になる（`janpara.rb`）。価格要素が無ければ `listing_price` は nil を返し、`price: nil, sold: true` で返る。価格が取れないこと自体は例外にならない。FR1.1〜FR1.3 を満たす。
- FR2: `update_janpara_sold` は `product_crawl_results.where(platform:)` の範囲で `update_all` する。範囲は設定とサイトに閉じる。`update_all` は `updated_at` も `bought_date` も触らない。入力は `crawled[:results]` のじゃんぱら全件で、価格なし・条件不一致・除外済みを含むため、FR2.1〜FR2.5 を満たす。既存の「売却済みでも販売中に戻す」例（`bought_date` 保持）はそのまま通る形である。
- FR3: `sell_out_missing_janpara` の条件（3時間、`returned_ids` 以外、取得元が1件以上かつ全成功）は変わっていない。`sources_succeeded?` は呼び出し元が `janpara_fetch_succeeded?` だけで、本体は `all? { status == "succeeded" }` と同一である。畳み込みで振る舞いは変わっていない。
- 順序: `[true, false]` の順に適用するので、同じ出品が両方で返れば最後は `false` になる。コメントと実装は一致する。
- 回帰テストの有効性: 修正前のコードでは、`janpara_spec` の新しい例は `sold: false` が返って失敗し、`sync_crawl_results_spec` の新しい例は検索に返った行を `sold: false` に戻す旧処理で失敗する。バグを再現する設計になっている。別サイトの行は設定ごとに external_id が一意なため別の設定の行で用意しており、検証は緩んでいない。
- `save_matched` の経路: 価格ありで `sold: true` の新規じゃんぱら出品は、売り切れのまま保存され、`bought_date` は nil になる。じゃんぱらは詳細取得サイトでは無いので、`newly_sold_ids` の詳細確認も走らない。この挙動は要件が禁じていない。
- traceability.json: OK の対象6件（`janpara.rb`、`sync_crawl_results.rb`、2つの spec、docs、`testing.md`）はすべて実在する。NFR3 は Deferred で、Build and Test に回す理由が code-summary.md と一致する。要件 ID の過不足は無い。

### Summary

要件 FR1〜FR3 は実装とテストで満たされ、4つの懸念（一覧の `sold: true`、既存行への反映、消えた出品の売り切れ化、`updated_at`・`bought_date`・他サイト・他設定の不変）はコードで確認できた。回帰テストは修正前のコードで失敗する設計である。残る指摘はすべて Minor で、承認を妨げない。
