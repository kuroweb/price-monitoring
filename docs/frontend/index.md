# Frontend

このページは frontend を変更する開発者向けに、このプロジェクトで route / feature / data access をどう分けるかを揃えるための設計解説です。
実装時は `app` を入口、`features` を機能ごとの UI と通信境界として扱います。

## 文書の案内

- [ローカル開発](../development/index.md) — セットアップ・日常操作・テストの案内
- [商品計測・商品相場PoC](../backend/product-monitoring-poc.md) — 画面の操作と制約
- [文書全体の索引](../index.md)

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
- 商品とカテゴリの両方で使う `Category` 型は `lib/category.ts` に置き、カテゴリデータの取得は `app` で組み立てる
- page や feature から直接 backend の details を広げすぎない

## 置かない責務

- `app` に画面固有の細かい UI 実装をため込まない
- `features` から直接 HTTP client の詳細を散らさない
- HTTP request に revalidation や UI 都合の処理を混ぜない
- layout 共通部品に画面固有の条件分岐を持ち込まない

## このプロジェクトでの見方

### route entry

- `app/products/page.tsx` が category 付き一覧の入口
- `app/products/[id]/page.tsx` が商品詳細の入口
- `app/backmarket/page.tsx` が Backmarket 計測結果の入口
- `app/product-crawl-results/` と `app/product-aggregation-results/` が商品計測結果・商品相場の入口
- `app/admin/*` が管理画面（商品・カテゴリ・Backmarket 計測など）の route を持つ

### feature 単位の UI

- `features/products/` が商品一覧や詳細の UI と state を持つ
- `features/categories/` がカテゴリ管理の UI と通信を持つ
- `features/backmarket/` が計測対象の管理と直近取得画面の UI と通信を持つ
- `features/product-monitoring/` が商品計測（計測設定・計測結果・相場設定・相場）の UI を持つ。結果画面から設定の編集モーダルを開く読み込みや、2つの設定で語句・価格帯の入力欄を共有する読み込みは、同じ機能の中に収まる
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

- 商品の計測対象一覧は管理コードの部分一致検索、カテゴリ、計測状態を組み合わせて絞り込む。計測状態は6サイトの設定のいずれかが有効なら「計測中」、すべて無効なら「停止中」とする。実際のジョブの実行状態を表すものではない。
- 商品・Backmarket の一覧操作は「…」にまとめ、計測設定・複製・削除を選べるようにする。
- 商品・カテゴリ・Backmarket の削除では対象名を確認し、処理中は削除の再操作を防ぐ。作成・更新フォームも送信中の表示とボタンの無効化で再送信を防ぐ。
- API の取得失敗はエラー画面で再試行を案内し、取得成功時の空一覧と区別する。成功時に対象がなければ追加や絞り込み変更を案内する。

## Lint の構成

ESLint 10 の flat config を `volumes/frontend/eslint.config.mjs` で管理する。
`eslint-config-next` の一括設定は使わず、ESLint 10 をサポートするプラグインを直接組み合わせる。
ルールの設定と依存バージョンの正本は、それぞれこの設定ファイルと `volumes/frontend/package.json` / `package-lock.json`。

| 検査 | 担当 |
| --- | --- |
| Next.js の推奨ルールと Core Web Vitals | `@next/eslint-plugin-next` |
| React・Hooks・React Compiler の推奨検査 | `@eslint-react/eslint-plugin` |
| import の順序とグループ間の空行 | `eslint-plugin-import-x` |
| 画像の alt、ARIA、キーボード操作などの推奨検査 | `eslint-plugin-jsx-a11y-x` |
| JSX の不要な波括弧とコンポーネントの自己終了タグ | `@stylistic/eslint-plugin` |
| 型 import と未使用変数 | `typescript-eslint` |

Next.js の `core-web-vitals`、React とアクセシビリティの `recommended`、TypeScript の `recommended` を基本にする。
TypeScript ファイルには React の `recommended-typescript` も適用し、型で検査できるものは型チェックに委ねる。
JSX の変数参照は ESLint 10 のスコープ解析を使い、JavaScript の未定義名は `no-undef` で検査する。
アクセシビリティ違反も推奨設定の重要度で報告する。Next.js の画像コンポーネントは `Image` と `NextImage` の両方を alt 検査の対象にする。
プロジェクト固有の上書きは import 順序、型 import、未使用変数、JSX スタイルなどに絞り、Prettier との競合は最後の `eslint-config-prettier` で無効にする。
空の HTML 要素に自己終了タグを強制しない設定は維持する。

依存更新時は正常なコードの lint だけでなく、違反の報告と自動修正も確認する。
`tests/tooling/eslint-config.test.ts` が実際の設定を読み込み、import、React、Hooks、Next.js、アクセシビリティ、JSX の代表入力を検証する。
実行方法は [ローカル開発のテスト手順](../development/testing.md) を参照する。

## テスト方針

- Vitest の `describe`・`it`・`test` の説明文は日本語で書く。関数・コンポーネントを指す `describe` はそのまま使う。`it`・`test` は振る舞いを「〜こと」で終える
- Vitest・React Testing Library・jsdom を使い、関数と同期 component、Client Component の振る舞いを検証する
- テストは `tests/` 配下に、対象実装と同じディレクトリ構造で `*.test.ts` / `*.test.tsx` として置く。例: `features/products/components/CategoryNavigation.tsx` に対して `tests/features/products/components/CategoryNavigation.test.tsx`
- `describe` / `it` / `expect` / `vi` は `vitest` から明示的に import する。`@/` エイリアスはアプリと同じ `tsconfig.json` を参照する
- UI は role・表示文言を使って検証し、操作には `@testing-library/user-event` を使う
- 共通 setup は `tests/setup.ts` に置き、DOM matcher の登録とテストごとの DOM cleanup を行う。Next.js API の一括モックは置かず、必要な依存だけ各テストで制御する
- nuqs の URL state を操作する component は `NuqsTestingAdapter` で包み、クエリ更新を検証する。例は `Pagination.test.tsx` を参照する
- 実ネットワークや DB へ接続せず、通信が必要なテストではその境界をモックする
- 共通 HTTP クライアントはブラウザー側の `fetch` とサーバー側の `http` / `https` を分けて検証する。サーバー側テストはファイル先頭の `// @vitest-environment node` で Node 環境を指定する
- Server Action は API 関数も実行し、HTTP 境界と `next/cache` をモックして、リクエストと画面の再検証を確認する
- フォームは実際の入力・送信を通して、必須項目、送信データ、成功時の終了、失敗時の入力保持を確認する
- 非同期 Server Component、実ブラウザー上の画面遷移、OIDC 認証はこの基盤の対象外。これらを検証する E2E 基盤は未導入

実行・watch・カバレッジ計測は [ローカル開発のテスト手順](../development/testing.md)を参照する。

## 関連 docs

- [プロジェクト README](../../README.md)
- [`../backend/index.md`](../backend/index.md)

## 代表コード

- [`volumes/frontend/app/products/page.tsx`](../../volumes/frontend/app/products/page.tsx)
- [`volumes/frontend/features/products/components/CategoryNavigation.tsx`](../../volumes/frontend/features/products/components/CategoryNavigation.tsx)
- [`volumes/frontend/lib/http-client.ts`](../../volumes/frontend/lib/http-client.ts)
- [`volumes/frontend/features/products/api/actions.ts`](../../volumes/frontend/features/products/api/actions.ts)
- [`volumes/frontend/features/products/api/products.ts`](../../volumes/frontend/features/products/api/products.ts)

## 更新時に確認する source of truth

- `volumes/frontend/app/`
- `volumes/frontend/features/`
- `volumes/frontend/components/layouts/`
- `volumes/frontend/lib/http-client.ts`
- `volumes/frontend/lib/category.ts`
- `volumes/frontend/lib/revalidate-paths.ts`
