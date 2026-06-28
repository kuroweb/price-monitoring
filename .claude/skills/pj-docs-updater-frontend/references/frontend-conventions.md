# docs/frontend/*.md 規約

## 対象

- `docs/frontend/overview.md`
- `docs/frontend/` 配下に追加される handbook docs

## 基本方針

- frontend docs は実装判断のための handbook
- 事実の正本は `volumes/frontend/` 配下の実装
- docs は判断基準、責務境界、導線を整理する
- 結論先出しで短く書く
- Next.js 一般論ではなく、この repo に固有の構成と責務を書く

## 推奨セクション

### `overview.md`

- 導入
- `## 判断基準`
- `## 置いてよい責務` / `## 置かない責務`（必要に応じて）
- `## このプロジェクトでの見方`
- `## 避けること`
- `## 関連 docs`
- `## 代表コード`
- `## 更新時に確認する source of truth`

## リンク規約

- docs 内リンクは相対パス
- 代表コードのラベルは `volumes/...` の実パス
- 代表コードは各ページ 3〜6 件程度

## source of truth

- `volumes/frontend/app/`
- `volumes/frontend/features/`
- `volumes/frontend/components/layouts/`
- `volumes/frontend/lib/http-client.ts`
- `volumes/frontend/lib/api/`
- `volumes/frontend/lib/actions/`
- `volumes/frontend/lib/revalidate-paths.ts`

## 委譲ルール

- `docs/backend/*.md` の更新は `pj-docs-updater-backend`
- `docs/database/*.md` の更新は `pj-docs-updater-database`
- frontend docs 追加時は `docs/README.md` の Index / 使い方を更新する
