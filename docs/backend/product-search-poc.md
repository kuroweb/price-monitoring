# 商品計測・商品相場PoC

[商品計測と相場集計の仕様](../specs/product-monitoring/index.md) のテーブル設計を、既存の計測対象管理から独立した新しいテーブル群で試す機能。商品計測設定に複数サイトの検索結果URLと共通の追加条件を登録し、取得した商品計測結果を商品相場設定でフィルターして日ごとに集計する。管理ナビの「商品計測（PoC）」から開く。

## 操作

1. [開発手順](../development/index.md)に沿って起動・DB準備する。
2. `/admin/product-crawl-settings` の「商品計測設定を追加」または各行の「…」メニューの「編集」でモーダルを開き、名前と検索結果URLを入力する。メルカリの `/search?...`、イオシスの `/items?...` が対象。各URLの横にホスト名から判定したサイトを表示する。
3. 必要なら全URL共通の必須語・除外語・価格帯を設定する。更新モーダルでは、除外した出品を画像・名前・商品ページへのリンクつきで、件数を示して折りたたんで表示し、その場で個別に取り消せる。除外は `excluded_at` で表し、条件に一致する行は取得し直しても除外されたままになる。
4. モーダルの「登録」または「更新」で商品計測設定を保存する。
5. サイドバーの「商品計測結果」から `/product-crawl-results` を開く。商品計測設定ごとに新着8件のカードを横に並べ、カードの「…」メニューから出品を除外できる。「すべて見る」で `/product-crawl-results/:id` の詳細を開く。詳細では販売状態の絞り込みと並び替えができ、「取得して保存」で採用した出品を保存し、カードの「…」メニューから出品を除外できる。一覧と詳細の「設定を編集」で、商品計測設定の更新モーダルを開ける。
6. `/admin/product-aggregation-settings` の「商品相場設定を追加」または各行の「…」メニューの「編集」でモーダルを開き、名前・必須語・除外語・価格帯を登録する。
7. サイドバーの「商品相場」から `/product-aggregation-results` を開き、商品相場設定ごとのセクションの「直近30日を集計」で商品日次相場を計算する。直近・期間平均の購入価格と購入件数を出し、期間（7・14・30日）と表示（グラフ・表）を切り替えられる。「設定を編集」で商品相場設定の更新モーダルを開ける。

worktreeの接続先はルートから `just url` で確認する。言語ツールはbackend/frontendコンテナで実行する。

## 現在の範囲

- 取得は画面からの手動実行に加え、有効な商品計測設定を20分ごとにSidekiqで実行する。集計は画面からの手動実行に加え、全商品相場設定について毎日0時に直近30日分をSidekiqで実行する。
- 最大5 URL、1ページにつき最大100件。全体の取得時間は45秒、1 URLは20秒を上限とする。
- 必須語はAND、除外語はOR。カンマ・改行で複数指定する。価格は上下限を含み、空欄は無制限。
- 出品の除外は商品計測結果の行ごとに `excluded_at` を設定し、通常の結果表示と集計から除く。同じ設定で再取得するときは `external_id` で除外を判定する。
- 取得して保存するとき、保存済みの結果のうち現在の条件に一致しないものを、除外済みの行も含めて削除する。今回の検索結果に出なかった出品は、条件に一致していれば残す。
- 商品相場は、除外されておらず条件に一致する商品計測結果のうち、`bought_date` が集計期間に入るものを `external_id` で1件にまとめ、日ごとに平均する。
- 静的HTMLの一覧からは販売状態・売れた日時を取得しないため、新規に取得した結果には `sold`・`bought_date` が保存されない。サムネイルはイオシスの一覧の画像URL、メルカリは出品IDから組み立てたURLを保存する。実データだけでは各日の購入件数は0件になる。集計は `bought_date` を入れた検証データで確認する。

## 取得方式と制限

URLをHTTPSの対応ホスト・検索パスに限定する。検索HTMLは許可したホストへHTTPSで取得し、証明書のホスト検証を行う。リダイレクトを追わず、応答は読み取り中に3 MiBで打ち切る。取得HTMLはNokogiriで解析し、ブラウザやスクリプトを実行しない。

この方式はブラウザの動的通信を前提とするページには対応できない。サイト側の拒否やDOMの不一致も失敗とし、成功したようなサンプル結果へ置き換えない。

ログ・エラー通知へ入力URLを流さないため、取得失敗の表示は固定文言にしている。Datadog/BugSnagの既存設定は変更しない。

## API

| 操作 | Endpoint |
| --- | --- |
| 商品計測設定の一覧・登録 | GET / POST `/api/v1/product_crawl_settings` |
| 商品計測設定の取得・更新・削除 | GET / PUT / DELETE `/api/v1/product_crawl_settings/:id` |
| 保存済みの条件で取得して保存 | POST `/api/v1/product_crawl_settings/:id/sync` |
| 商品計測結果（`product_crawl_setting_id` で絞り込み、`excluded=true` で除外した出品だけ） | GET `/api/v1/product_crawl_results` |
| 出品の除外・取り消し（行は消さない） | PATCH `/api/v1/product_crawl_results/:id`（`excluded: true/false`） |
| 商品相場設定の一覧・登録 | GET / POST `/api/v1/product_aggregation_settings` |
| 商品相場設定の取得・更新・削除 | GET / PUT / DELETE `/api/v1/product_aggregation_settings/:id` |
| 直近30日の集計 | POST `/api/v1/product_aggregation_settings/:id/calculate` |
| 全商品相場設定の商品日次相場 | GET `/api/v1/product_aggregation_results` |

入力検証（`Crawl::Search::Input`）は保存と「取得して保存」で共有する。必須語・除外語は各50件/各255文字。取得と採否の判定は `Crawl::Search::Crawler` が行う。

## 検証記録

2026-11-06時点: backend全体のspec 269件、frontend全体のテスト125件、型検査・lintは成功。実アプリでイオシスの検索結果URLから24件を取得して保存し、1件の除外で23件になることを確認した。メルカリは静的HTML方式では取得失敗となる。`bought_date` を入れた検証データで、商品日次相場の平均購入価格と件数を確認した。

## 別端末での再開

- DB追加と除外管理の変更は `20261106000001_create_product_crawl_and_aggregation_tables.rb`、`20261106000002_move_exclusions_to_product_crawl_results.rb`。リポジトリルートで `docker compose exec backend bundle exec rails db:migrate` を実行する。
- backend対象検証: `docker compose exec backend bundle exec rspec spec/requests/product_crawl_settings_spec.rb spec/requests/product_aggregation_settings_spec.rb spec/services/product_crawl_settings spec/services/product_aggregation_settings spec/services/crawl/search`
- frontend対象検証: frontendコンテナで `npm run typecheck`、`npm run lint`、`npx vitest run tests/features/product-monitoring`。

残作業はメルカリの動的描画への対応、販売状態・売れた日時の取得、画面設計の未決事項。
