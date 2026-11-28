# Frontend のテスト方針

frontend のテストを書く開発者向けに、テストの書き方と対象範囲を定める。

- Vitest の `describe`・`it`・`test` の説明文は日本語で書く。関数・コンポーネントを指す `describe` はそのまま使う。`it`・`test` は振る舞いを「〜こと」で終える
- Vitest・React Testing Library・jsdom を使い、関数と同期 component、Client Component の振る舞いを検証する
- テストは `tests/` 配下に、対象実装と同じディレクトリ構造で `*.test.ts` / `*.test.tsx` として置く。例: `features/backmarket/components/BackmarketWatchTargetsTable.tsx` に対して `tests/features/backmarket/components/BackmarketWatchTargetsTable.test.tsx`
- `describe` / `it` / `expect` / `vi` は `vitest` から明示的に import する。`@/` エイリアスはアプリと同じ `tsconfig.json` を参照する
- UI は role・表示文言を使って検証し、操作には `@testing-library/user-event` を使う
- 共通 setup は `tests/setup.ts` に置き、DOM matcher の登録とテストごとの DOM cleanup を行う。Next.js API の一括モックは置かず、必要な依存だけ各テストで制御する
- nuqs の URL state を操作する component は `NuqsTestingAdapter` で包み、クエリ更新を検証する。例は `tests/features/product-monitoring/components/CrawlResultSearch.test.tsx` を参照する
- 実ネットワークや DB へ接続せず、通信が必要なテストではその境界をモックする
- 共通 HTTP クライアントはブラウザー側の `fetch` とサーバー側の `http` / `https` を分けて検証する。サーバー側テストはファイル先頭の `// @vitest-environment node` で Node 環境を指定する
- Server Action は API 関数も実行し、HTTP 境界と `next/cache` をモックして、リクエストと画面の再検証を確認する
- フォームは実際の入力・送信を通して、必須項目、送信データ、成功時の終了、失敗時の入力保持を確認する
- 非同期 Server Component、実ブラウザー上の画面遷移、OIDC 認証はこの基盤の対象外。これらを検証する E2E 基盤は未導入

実行・watch・カバレッジ計測は [ローカル開発のテスト手順](../testing.md)を参照する。
