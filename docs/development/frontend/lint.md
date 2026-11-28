# Frontend の Lint の構成

frontend の lint 設定や依存を変更する開発者向けに、ESLint の構成を解説する。

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
実行方法は [ローカル開発のテスト手順](../testing.md) を参照する。
