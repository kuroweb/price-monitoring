# Frontend

`volumes/frontend/` の変更時に [common.md](common.md) に加えて確認する。

根拠 handbook: [docs/frontend/overview.md](../../../../docs/frontend/overview.md)

## 置き場所

- [ ] `app/` は route entry と page composition に留まっている
- [ ] 画面固有 UI / state は `features/` にある
- [ ] 共通 layout は `components/layouts/` にある
- [ ] BFF 通信は `lib/api/`、共通 HTTP は `lib/http-client.ts`
- [ ] response 型は `lib/api/models/`
- [ ] server action / revalidation は `lib/actions/`、path 定数は `lib/revalidate-paths.ts`

## 避けるパターン

- [ ] page ファイルの肥大化（UI ロジックの直書き）
- [ ] component から HTTP client 詳細・endpoint 知識の散在
- [ ] `lib/api` への revalidation や UI 都合の処理の混入
- [ ] route ごとの UI コピペで feature 分割が崩れている

## TypeScript / Next.js

- [ ] Server / Client Component の境界が適切（`'use client'` の乱用がない）
- [ ] 非同期データ取得の loading / error 状態が妥当
- [ ] 型が `any` で逃げていない（API response 型が models に定義されている）
- [ ] search params や dynamic route の型・バリデーションが安全

## UI / UX

- [ ] 空状態・ローディング・エラー表示がある（一覧・詳細・管理画面）
- [ ] アクセシビリティの最低限（ボタン・リンク・フォームの意味）が保たれている

## 依存関係

- [ ] npm 追加・更新は Docker 経由（`docker compose run --rm frontend npm i`）前提の手順と整合している
