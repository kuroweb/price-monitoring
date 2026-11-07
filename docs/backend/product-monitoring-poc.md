# 商品計測・商品相場PoC

[商品計測と相場集計の仕様](../specs/product-monitoring/index.md) のテーブル設計を、既存の計測対象管理から独立した新しいテーブル群で試す機能。商品計測設定に複数サイトの検索結果URLと共通の追加条件を登録し、取得した商品計測結果を商品相場設定でフィルターして日ごとに集計する。管理ナビの「商品計測（PoC）」から開く。

## 操作

1. [開発手順](../development/index.md)に沿って起動・DB準備する。
2. `/admin/product-crawl-settings` の「商品計測設定を追加」または各行の「…」メニューの「編集」でモーダルを開き、名前と検索結果URLを入力する。「複製」では元の設定値を入れた登録モーダルが開く。メルカリの `/search?...`、イオシスの `/items?...`、じゃんぱらの `/sale/search/result/?KEYWORDS=...`、Yahoo!フリマの `/search/<キーワード>`、ヤフオクの `/search/search?...` と `/closedsearch/closedsearch?...` が対象。各URLの横にホスト名から判定したサイトを表示する。
3. 必要なら全URL共通の必須語・除外語・価格帯を設定する。更新モーダルでは、除外した出品を画像・名前・商品ページへのリンクつきで、件数を示して折りたたんで表示し、その場で個別に取り消せる。除外は `excluded_at` で表し、条件に一致する行は取得し直しても除外されたままになる。
4. モーダルの「登録」または「更新」で商品計測設定を保存する。
5. サイドバーの「商品計測結果」から `/product-crawl-results` を開く。商品計測設定ごとに新着8件のカードを横に並べ、カードの「…」メニューから出品を除外できる。「すべて見る」で `/product-crawl-results/:id` の詳細を開く。詳細では販売状態の絞り込みと並び替えができ、「取得して保存」で非同期ジョブを投入する。しばらくしてから再読み込みすると保存結果を確認できる。カードの「…」メニューから出品を除外できる。一覧と詳細の「設定を編集」で、商品計測設定の更新モーダルを開ける。
6. `/admin/product-aggregation-settings` の「商品相場設定を追加」または各行の「…」メニューの「編集」でモーダルを開き、名前・必須語・除外語・価格帯を登録する。
7. サイドバーの「商品相場」から `/product-aggregation-results` を開き、商品相場設定ごとのセクションの「直近30日を集計」で商品日次相場を計算する。直近・期間平均の購入価格と購入件数を出し、期間（7・14・30日）と表示（グラフ・表）を切り替えられる。「設定を編集」で商品相場設定の更新モーダルを開ける。

worktreeの接続先はルートから `just url` で確認する。言語ツールはbackend/frontendコンテナで実行する。

## 現在の範囲

- 取得は画面からの手動実行に加え、有効な商品計測設定を20分ごとにSidekiqで実行する。集計は画面からの手動実行に加え、全商品相場設定について毎日0時に直近30日分をSidekiqで実行する。
- 最大5 URL、1 URLにつき最大5ページ・1ページ100件（最大500件）。次ページがない場合や結果が0件の場合は終了する。途中の取得が失敗したURLは失敗とする。全体の取得時間は300秒、1 URLは60秒を上限とする。手動取得は設定の有効・無効にかかわらず実行する。
- イオシスの機種グループ検索（`t=g`）は登録できない。`t=g` のない個別出品の検索URLを使う。単一の価格として解釈できない出品は保存しない。
- 必須語はAND、除外語はOR。カンマ・改行で複数指定する。価格は上下限を含み、空欄は無制限。
- 出品の除外は商品計測結果の行ごとに `excluded_at` を設定し、通常の結果表示と集計から除く。同じ設定で再取得するときは `external_id` で除外を判定する。
- 取得して保存するとき、保存済みの結果のうち現在の条件に一致しないものを、除外済みの行も含めて削除する。今回の検索結果に出なかった出品は、条件に一致していれば残す。
- 商品計測設定の更新で必須語・除外語・価格帯のいずれかを変えたときも、同じ削除を更新と同じトランザクションで行う。名前・有効状態・検索結果URLだけの変更では削除しない。商品日次相場は再計算せず、次の集計で反映する。
- 商品相場は、除外されておらず条件に一致する商品計測結果のうち、`bought_date` が集計期間に入るものを `external_id` で1件にまとめ、日ごとに平均する。
- メルカリは一覧の売り切れ表示と個別ページの JSON-LD の在庫状態から販売状態を確認し、売れた日は相対表示から日単位で推定する。一覧から消えた販売中または販売状態不明の出品と、売り切れで売れた日が不明な出品は、最終更新から3時間経過すると個別確認の候補になる。一覧で初めて売り切れと確認した出品は、待たずに候補になる。個別ページの状態を判定できない場合や再試行を使い切った場合は、販売状態を変えず確認日時を更新する。イオシス・じゃんぱらは一覧にある出品を販売中とし、売れた日は取得しない。サムネイルはイオシスの一覧の画像URL、メルカリは出品IDから組み立てたURLを保存する。
- Yahoo!フリマも一覧の sold 画像と個別ページの JSON-LD から販売状態を確認し、時計アイコンの更新日時を既存クローラーと同じ基準で日単位に換算する。日時が表示されない場合は不明のままとする。個別確認の候補と間隔はメルカリと同じで、全サイト合わせて1回最大50件。画像URLは一覧から取得する。
- ヤフオクは出品中の一覧を販売中、落札相場の一覧を売り切れとし、落札相場の終了日時を売れた日として保存する。即決価格と終了日時は一覧から取得し、個別確認は行わない。

## 取得方式と制限

入力URLをHTTPSの対応ホスト・検索パスに限定する。イオシスはHTTPSで取得し、証明書のホスト検証を行い、リダイレクトを追わず、応答は読み取り中に3 MiBで打ち切る。メルカリは既存のPlaywrightクライアントでJavaScriptを実行して描画し、ブラウザのリダイレクトやサブリソース通信を許可する。各ページの遷移後に最終URLがHTTPSの `jp.mercari.com` であることを確認し、描画後のHTMLが10 MiBを超えた場合は失敗とする。メルカリの応答にはストリーミングのサイズ上限を適用しない。両者とも取得したHTMLはNokogiriで解析する。

じゃんぱらは既存クローラーと同じ Playwright クライアントを使用し、スクリプトを遮断して一覧を取得する。遷移後の HTTPS ホストと描画後 HTML の10 MiB 上限を検証する。一覧の SRCODE または ITMCODE の商品グループを1出品とし、価格はグループの下限価格を保存する。個別の店舗在庫や販売状態は確認しない。

サイト固有のURL判定・取得・解析は `ProductMonitoring::Sites` のサイトクラスにまとめ、共通処理は `ProductMonitoring::Crawler` が担う。ブラウザ取得時の URL と HTML サイズの確認には `Sites::BrowserPage`、数値ページ番号の更新には `Sites::Pagination` を使う。サイトを追加するときはサイトクラスを追加し、サイトの検証条件を指定したうえで `UrlRouter::SITES` に登録する。

`SyncCrawlResults` は一覧の保存を担当し、条件に合わない結果の削除は取得時と設定更新時の両方から `CleanseCrawlResults` を呼ぶ。`DetailCandidates` が個別確認の候補選択とジョブ投入を担当する。

Yahoo!フリマはメルカリと同じ Playwright クライアントを用い、遷移後の HTTPS ホストと描画後 HTML の10 MiB 上限を検証する。更新日時の描画に必要な `paypayfleamarket.c.yimg.jp` のスクリプトを許可する。検索一覧の次ページリンクを確認してページ送りする。既存の `Crawl::YahooFleamarket` の一覧は Yahoo!オークションの検索結果を取得するため、本機能の Yahoo!フリマ検索とは取得元と DOM が異なる。

ヤフオクは Playwright で JavaScript と画像の読み込みを許可し、最終 HTTPS ホストと描画後 HTML の10 MiB 上限を検証する。画像を遮断するとサイトがサムネイルをエラー画像に置き換えるため画像の読み込みが必要。既存クローラーと同様に `abatch=1,2` で Yahoo!フリマを除き、一覧表示・100件単位のページ送りを使う。一覧の描画を待ってから HTML を Nokogiri で解析する。外部の表示変更や読み込み失敗により取得できない場合がある。

Yahoo!フリマとメルカリでは、個別ページが非2xxを返す削除済み出品を確実に判定できない。この場合は行を削除せず、再試行を使い切ると確認日時を更新し、3時間後に再び個別確認の候補になる。メルカリの2xx応答では従来どおり削除表示を判定する。

サイト側の拒否やDOMの不一致は失敗とし、成功したようなサンプル結果へ置き換えない。

ログ・エラー通知へ入力URLを流さないため、取得失敗の表示は固定文言にしている。Datadog/BugSnagの既存設定は変更しない。

## API

| 操作 | Endpoint |
| --- | --- |
| 商品計測設定の一覧・登録 | GET / POST `/api/v1/product_crawl_settings` |
| 商品計測設定の取得・更新・削除 | GET / PUT / DELETE `/api/v1/product_crawl_settings/:id` |
| 保存済みの条件で取得して保存するジョブを投入 | POST `/api/v1/product_crawl_settings/:id/sync`（202） |
| 商品計測結果（`product_crawl_setting_id` で絞り込み、`excluded=true` で除外した出品だけ） | GET `/api/v1/product_crawl_results` |
| 出品の除外・取り消し（行は消さない） | PATCH `/api/v1/product_crawl_results/:id`（`excluded: true/false`） |
| 商品相場設定の一覧・登録 | GET / POST `/api/v1/product_aggregation_settings` |
| 商品相場設定の取得・更新・削除 | GET / PUT / DELETE `/api/v1/product_aggregation_settings/:id` |
| 直近30日の集計 | POST `/api/v1/product_aggregation_settings/:id/calculate` |
| 全商品相場設定の商品日次相場 | GET `/api/v1/product_aggregation_results` |

入力検証（`ProductMonitoring::Input`）は保存と「取得して保存」で共有する。必須語・除外語は各50件/各255文字。取得と採否の判定は `ProductMonitoring::Crawler` が行う。

## 検証記録

2026-11-06時点: backend全体のspec 269件、frontend全体のテスト125件、型検査・lintは成功。実アプリでイオシスの検索結果URLから24件を取得して保存し、1件の除外で23件になることを確認した。`bought_date` を入れた検証データで、商品日次相場の平均購入価格と件数を確認した。メルカリは静的HTML方式では取得に失敗したため、ブラウザによる描画に変更し、実際の検索結果を保存できることを確認した。

## 別端末での再開

- DB追加と除外管理の変更は `20261106000001_create_product_crawl_and_aggregation_tables.rb`、`20261106000002_move_exclusions_to_product_crawl_results.rb`。リポジトリルートで `docker compose exec backend bundle exec rails db:migrate` を実行する。
- backend対象検証: `docker compose exec backend bundle exec rspec spec/requests/product_crawl_settings_spec.rb spec/requests/product_aggregation_settings_spec.rb spec/services/product_monitoring spec/sidekiq/product_monitoring`
- frontend対象検証: frontendコンテナで `npm run typecheck`、`npm run lint`、`npx vitest run tests/features/product-monitoring`。

残作業は画面設計の未決事項。
