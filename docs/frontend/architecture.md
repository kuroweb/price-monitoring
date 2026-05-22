# Frontend Architecture

このページは Next.js 一般論ではなく、このプロジェクトの frontend で route / feature / data access をどう分けるかを揃えるための handbook です。
実装時は `app` を入口、`features` を画面単位の UI、`lib/api` と `lib/actions` を通信境界として扱います。

## 判断基準

- `app/` は route entry と page composition に絞る
- 画面固有の UI や state は `features/` に寄せる
- 共通 layout は `components/layouts/` に寄せる
- BFF 通信は `lib/api/` に寄せる
- server action と revalidation は `lib/actions/` に寄せる

## 置いてよい責務

### app

- route ごとの page 定義
- search params の入口
- feature や layout の組み合わせ

### features

- 画面ごとの component
- 画面ごとの hook や小さな補助関数
- その画面だけで閉じる UI state

### lib/api と lib/actions

- `lib/api` には HTTP request / response の境界を置く
- `lib/actions` には server action と path revalidation を置く
- page や feature から直接 backend の details を広げすぎない

## 置かない責務

- `app` に画面固有の細かい UI 実装をため込まない
- `features` から直接 HTTP client の詳細を散らさない
- `lib/api` に revalidation や UI 都合の処理を混ぜない
- layout 共通部品に画面固有の条件分岐を持ち込まない

## このプロジェクトでの見方

### route entry

- `app/products/page.tsx` が category 付き一覧の入口
- `app/products/[id]/page.tsx` が商品詳細の入口
- `app/admin/*` が管理画面の route を持つ

### feature 単位の UI

- `features/products/` が商品一覧や詳細の UI と state を持つ
- `features/admin/` が管理画面の機能ごとの UI を持つ
- page は feature を束ねる役に留める

### 通信境界

- `lib/api/products/api.ts` のような単位で BFF 通信を閉じる
- `lib/actions/products.ts` のような単位で server action と再検証を閉じる

## 避けること

- 新しい画面を足すたびに page ファイルを肥大化させる
- API 型や endpoint の知識を component 側へ散らす
- 似た UI を route ごとにコピペして feature 分割を崩す

## 関連 docs

- [`../README.md`](../README.md)
- [`../backend/architecture.md`](../backend/architecture.md)

## 代表コード

- [`volumes/frontend/app/products/page.tsx`](../../volumes/frontend/app/products/page.tsx)
- [`volumes/frontend/features/products/components/CategoryNavigation.tsx`](../../volumes/frontend/features/products/components/CategoryNavigation.tsx)
- [`volumes/frontend/lib/actions/products.ts`](../../volumes/frontend/lib/actions/products.ts)
- [`volumes/frontend/lib/api/products/api.ts`](../../volumes/frontend/lib/api/products/api.ts)

## 更新時に確認する source of truth

- `volumes/frontend/app/`
- `volumes/frontend/features/`
- `volumes/frontend/components/layouts/`
- `volumes/frontend/lib/api/`
- `volumes/frontend/lib/actions/`
