# 検索URLによる計測PoC

共通フィルターを一度設定し、複数サイトの検索URLを取得する操作を試すための機能。画面は `/admin/products/search-settings`。管理ナビの「URLによる計測設定」から開く。

## 操作

1. [開発手順](../development/index.md)に沿って起動・DB準備する。
2. 計測名と検索結果URLを入力する。メルカリの `/search?...`、イオシスの `/items?...` が対象。
3. 必要なら共通の価格帯・必須語・除外語を設定し、「実際に取得して確認」を押す。
4. 結果の個別出品を除外できる。設定を変更したら再取得する。
5. 「保存」で条件・URLを保存する。保存済み設定は編集・削除できる。

worktreeの接続先はルートから `just url` で確認する。言語ツールはbackend/frontendコンテナで実行する。

## 現在の範囲

- 最大5 URL、1ページにつき最大100件。全体の取得時間は45秒、1 URLは20秒を上限とする。
- 必須語はAND、除外語はOR。カンマ・改行で複数指定する。価格は上下限を含み、空欄は無制限。
- 個別除外はサイトと出品IDの組。URLをまたいで適用する。
- 各URLの失敗を個別表示し、採用件数はサイトと出品IDで重複排除する。
- 保存は既存Productと4つの子テーブルへ行う。旧ジョブは対応するサイト別設定を持つProductだけを対象とし、新URL設定を旧処理で取得しない。
- 取得結果・実行履歴は保存しない。Productが計測設定の所有者となる。
- 検索結果URLのみ対応。ページ種別の属性や選択UIは持たない。

## 取得方式と制限

URLをHTTPSの対応ホスト・検索パスに限定する。検索HTMLは名前解決した公開IPへ接続先を固定して取得し、証明書のホスト検証を行う。リダイレクトを追わず、応答は読み取り中に3 MiBで打ち切る。取得HTMLはNokogiriで解析し、ブラウザやスクリプトを実行しない。

この方式はブラウザの動的通信を前提とするページには対応できない。サイト側の拒否やDOMの不一致も失敗とし、成功したようなサンプル結果へ置き換えない。初期PoCの目的は保存・複数URL・共通条件の経路を確かめ、実サイトに必要な取得方式を見極めること。現在の取得成功状況は下の検証記録を参照する。

ログ・エラー通知へ入力URLを流さないため、取得失敗の表示は固定文言にしている。Datadog/BugSnagの既存設定は変更しない。

## API

| 操作 | Endpoint |
| --- | --- |
| 一覧 | GET `/api/v1/products/search_settings` |
| 作成 | POST `/api/v1/products/search_settings` |
| 更新 | PUT `/api/v1/products/:id/search_settings` |
| 削除 | DELETE `/api/v1/products/:id` |
| 未保存の条件で手動取得 | POST `/api/v1/products/preview` |

共通入力検証は保存と取得で共有する。必須語・除外語は各50件/各255文字、個別除外は100件。更新時に不正なURLがあってもトランザクションで旧設定を維持する。

## 検証記録

2026-11-04時点: frontend操作・既存管理一覧の15件、型検査・lintは成功。イオシスは実サイトから24件を取得し24件の採用を確認。メルカリは現在の静的HTML方式では取得失敗となる。Product統合後のbackend対象specは42件成功。新画面はHTTP 200で応答。

設計・ERは [PLAN.md](../../PLAN.md) を参照する。

## 別端末での再開

- `PLAN.md` が最新の設計方針。Productが共通条件と複数URLの所有者。URLにはサイトやページ種別を保存しない。
- DB追加は `20261104000001_add_search_settings_to_products.rb`。再開先で開発環境を準備した後、backendコンテナで `bundle exec rails db:migrate` を実行する。
- `.env`、証明書、署名鍵、コンテナ内依存はコミット対象外。[開発手順](../development/index.md)と既存worktree setupに従って準備する。
- backend対象検証: `docker compose exec backend bundle exec rspec spec/requests/product_search_settings_spec.rb spec/services/crawl/search spec/models/product_spec.rb`
- frontend対象検証: `docker compose exec frontend npm run typecheck`、`npm run lint`、`npm test -- ProductSearchSettings.test.tsx management-lists.test.tsx`（いずれもfrontendコンテナ内）。

残作業はメルカリの動的描画への対応、旧条件からの移行、取得結果の永続化・定期実行・相場集計への接続。PoCの保存・手動取得と、本体としての定期計測を区別する。先行して実行履歴や条件改訂の仕組みを増やさない。

Orcaで実装とレビューを分担した。Product統合前のレビュー指摘は修正したが、統合後の独立レビューはワーカーの利用上限により完了できていない。再開時にはProduct統合後の変更、特に既存ジョブ・更新経路への影響をレビューする。

初期のUI検討用サンプルは [work/measurement-ui.html](../../work/measurement-ui.html) に残している。これは架空データの操作見本で、最新の実装は上記のProduct設定画面を使用する。
