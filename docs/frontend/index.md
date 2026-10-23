# Frontend

このページは frontend を変更する開発者向けに、このプロジェクトで route / feature / data access をどう分けるかを揃えるための設計解説です。
実装時は `app` を入口、`features` を画面単位の UI、`lib/api` と `lib/actions` を通信境界として扱います。

## 文書の案内

- [共通のローカル開発手順](../development/index.md) — セットアップ・依存関係・静的検証
- [文書全体の索引](../index.md)

## 判断基準

- `app/` は route entry と page composition に絞る
- 画面固有の UI や state は `features/` に寄せる
- 共通 layout は `components/layouts/` に寄せる
- BFF 通信は `lib/api/` に寄せ、共通クライアントは `lib/http-client.ts` に寄せる
- response 型は `lib/api/models/` に寄せる
- server action と revalidation は `lib/actions/` に寄せ、revalidate 対象 path は `lib/revalidate-paths.ts` に寄せる

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
- `app/backmarket_recents/page.tsx` が Backmarket 直近取得の入口
- `app/admin/*` が管理画面（商品・カテゴリ・Backmarket 監視など）の route を持つ

### feature 単位の UI

- `features/products/` が商品一覧や詳細の UI と state を持つ
- `features/admin/` が管理画面の機能ごとの UI を持つ
- `features/backmarket-recents/` が Backmarket 直近取得画面の UI を持つ
- page は feature を束ねる役に留める

### 通信境界

- `lib/http-client.ts` が共通 HTTP クライアント
- `lib/api/<resource>/api.ts` の単位で BFF 通信を閉じ、`lib/api/models/` に response 型を置く
- `lib/actions/<resource>.ts` の単位で server action と再検証を閉じ、`lib/revalidate-paths.ts` に path 定数を集約する

## 避けること

- 新しい画面を足すたびに page ファイルを肥大化させる
- API 型や endpoint の知識を component 側へ散らす
- 似た UI を route ごとにコピペして feature 分割を崩す

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
実行方法は [ローカル開発のテスト手順](../development/index.md#テスト) を参照する。

## テスト方針

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

実行・watch・カバレッジ計測は [ローカル開発のテスト手順](../development/index.md#テスト)を参照する。

## 関連 docs

- [プロジェクト README](../../README.md)
- [`../backend/index.md`](../backend/index.md)

## 代表コード

- [`volumes/frontend/app/products/page.tsx`](../../volumes/frontend/app/products/page.tsx)
- [`volumes/frontend/features/products/components/CategoryNavigation.tsx`](../../volumes/frontend/features/products/components/CategoryNavigation.tsx)
- [`volumes/frontend/lib/http-client.ts`](../../volumes/frontend/lib/http-client.ts)
- [`volumes/frontend/lib/actions/products.ts`](../../volumes/frontend/lib/actions/products.ts)
- [`volumes/frontend/lib/api/products/api.ts`](../../volumes/frontend/lib/api/products/api.ts)

## 更新時に確認する source of truth

- `volumes/frontend/app/`
- `volumes/frontend/features/`
- `volumes/frontend/components/layouts/`
- `volumes/frontend/lib/http-client.ts`
- `volumes/frontend/lib/api/`
- `volumes/frontend/lib/actions/`
- `volumes/frontend/lib/revalidate-paths.ts`
