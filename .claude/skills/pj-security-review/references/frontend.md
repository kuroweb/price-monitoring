# Frontend（セキュリティ）

`volumes/frontend/` の変更時に [common.md](common.md) に加えて確認する。

根拠 handbook: [docs/frontend/overview.md](../../../../docs/frontend/overview.md)

## 秘密情報と env

- [ ] `NEXT_PUBLIC_*` に API secret、内部 URL、管理用 token を載せていない
- [ ] server-only の env（`NEXT_PRIVATE_*`）が Client Component / browser bundle に漏れていない
- [ ] `.env*` 実体や secret がリポジトリに含まれていない

## データフロー

- [ ] BFF 通信は `lib/api/` / `lib/http-client.ts` 経由（endpoint や header 知識の散在がない）
- [ ] Server Action / `lib/actions/` が認可を BFF に委ねず、frontend だけで完結していない
- [ ] ユーザー入力が URL path / query / request body に載る前に検証されている

## XSS

- [ ] `dangerouslySetInnerHTML`、生 HTML 挿入、未サニタイズの markdown 表示がない
- [ ] 外部 crawl 由来の商品名・説明をそのまま HTML 化していない
- [ ] URL を `href` / `src` に載せる前に scheme を制限している（`javascript:` 等）

## Server / Client 境界

- [ ] `'use client'` コンポーネントに server-only secret や内部 API 詳細を渡していない
- [ ] search params / dynamic route params の型・範囲チェックがある

## 認証連携

- [ ] cookie / session を JS から読み書きしていない（HttpOnly session 前提）
- [ ] ログイン状態の UI だけで保護しており、API 側認可を前提にしていない

## 依存関係

- [ ] 新規 npm パッケージが supply chain リスクを増やしていない（必要最小限、pin）
- [ ] 更新手順が Docker 経由（`docker compose run --rm frontend npm i`）と整合

## エラー・ログ

- [ ] client 側 console / toast に内部 stack や token が出ない
- [ ] エラー boundary が機密情報をユーザーに表示しない
