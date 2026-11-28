# Frontend の責務分離

frontend を変更する開発者向けに、このプロジェクトで route / feature / data access をどう分けるかを揃えるための設計解説。
実装時は `app` を入口、`features` を機能ごとの UI と通信境界として扱う。

## 判断基準

- `app/` は route entry と page composition に絞る
- 画面固有の UI や state は `features/` に寄せる
- 共通 layout は `components/layouts/` に寄せる
- BFF 通信と response 型、server action は各機能の `api/` に寄せる
- 共通クライアントは `lib/http-client.ts`、再検証対象の path は `lib/revalidate-paths.ts` に寄せる

## 置いてよい責務

### app

- route ごとの page 定義
- search params の入口
- feature や layout の組み合わせ

### features

- 画面ごとの component
- 画面ごとの hook や小さな補助関数
- その画面だけで閉じる UI state
- 置き場所は route ではなく機能で決める。`features/<機能>/` に置き、複数の route（管理画面と閲覧画面など）から使ってよい
- 機能の中は種類で分ける。`api/`（型・API クライアント・server action）・`components/`（画面の部品）・`hooks/`・`lib/`（小さな補助関数）を置く。機能の中のファイルどうしは自由に読み込んでよい
- `features` どうしは読み込まない。機能をまたいで使うものは `components/ui/` や `lib/` に置くか、`app` で組み立てる
- どの機能にも依存しない汎用部品は `components/ui/` に置く

### features/<機能>/api と共有の土台

- 機能の通信は `features/<機能>/api/` に置く。`types.ts` に request / response の型、リソースごとのファイルに HTTP request（`lib/http-client` を使う）、`actions.ts` に server action と path revalidation を置く
- `lib/http-client` と `lib/revalidate-paths` は全機能で共有する土台として `lib/` に置く
- page や feature から直接 backend の details を広げすぎない

## 置かない責務

- `app` に画面固有の細かい UI 実装をため込まない
- `features` から直接 HTTP client の詳細を散らさない
- HTTP request に revalidation や UI 都合の処理を混ぜない
- layout 共通部品に画面固有の条件分岐を持ち込まない

## このプロジェクトでの見方

### route entry

- `app/backmarket/page.tsx` が Backmarket 計測結果の入口
- `app/product-monitoring/` が商品モニタリングの入口。`monitors/` にモニタリング設定、`crawl-settings/` に収集設定の一覧・詳細を置く。入口はモニタリング設定の一覧へリダイレクトする
- `app/admin/backmarket` が Backmarket 計測対象の管理画面の route を持つ

### feature 単位の UI

- `features/backmarket/` が計測対象の管理と直近取得画面の UI と通信を持つ
- `features/product-monitoring/` が商品モニタリングの UI を持つ。各画面から設定の登録・編集モーダルを開き、保存条件と抽出条件の入力欄はそれぞれ分ける
- page は feature を束ねる役に留める

### 通信境界

- `lib/http-client.ts` が共通 HTTP クライアント
- `features/<機能>/api/` のリソース単位のファイルで BFF 通信を閉じ、`types.ts` に型を置く
- `features/<機能>/api/actions.ts` に server action と再検証を置き、`lib/revalidate-paths.ts` に path 定数を集約する

## 避けること

- 新しい画面を足すたびに page ファイルを肥大化させる
- API 型や endpoint の知識を component 側へ散らす
- 似た UI を route ごとにコピペして feature 分割を崩す

## 管理画面の操作と状態表示

- Backmarket の計測対象一覧の操作は「…」にまとめ、計測設定・複製・削除を選べるようにする。
- Backmarket の削除では対象名を確認し、処理中は削除の再操作を防ぐ。作成・更新フォームも送信中の表示とボタンの無効化で再送信を防ぐ。
- 商品モニタリングの画面操作は [外部仕様](../../features/product-monitoring/external-spec.md) を参照する。
- API の取得失敗はエラー画面で再試行を案内し、取得成功時の空一覧と区別する。成功時に対象がなければ追加や絞り込み変更を案内する。

## 代表コード

- [`volumes/frontend/app/product-monitoring/monitors/page.tsx`](../../../volumes/frontend/app/product-monitoring/monitors/page.tsx)
- [`volumes/frontend/features/product-monitoring/components/MonitorList.tsx`](../../../volumes/frontend/features/product-monitoring/components/MonitorList.tsx)
- [`volumes/frontend/lib/http-client.ts`](../../../volumes/frontend/lib/http-client.ts)
- [`volumes/frontend/features/backmarket/api/actions.ts`](../../../volumes/frontend/features/backmarket/api/actions.ts)
- [`volumes/frontend/lib/revalidate-paths.ts`](../../../volumes/frontend/lib/revalidate-paths.ts)

## 更新時に確認する source of truth

- `volumes/frontend/app/`
- `volumes/frontend/features/`
- `volumes/frontend/components/layouts/`
- `volumes/frontend/lib/http-client.ts`
- `volumes/frontend/lib/revalidate-paths.ts`
