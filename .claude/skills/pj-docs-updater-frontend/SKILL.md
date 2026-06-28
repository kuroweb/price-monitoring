---
name: pj-docs-updater-frontend
description: >-
  price-monitoring の docs/frontend/*.md（overview.md など）をメンテする。 Next.js frontend
  の route / feature / data access の責務境界を実装判断に使える形で保つ。 frontend docs
  更新、画面構成・通信境界の設計判断の文書化で使う。
---
# Frontend ドキュメント（docs/frontend/*.md）

Next.js frontend 側の handbook docs を、実装判断に使える状態へ保つ。
事実の写経ではなく、責務境界・置き場所・参照導線を整理する。

規約: [references/frontend-conventions.md](references/frontend-conventions.md)

## 対象ファイル

- `docs/frontend/overview.md` — route / feature / lib の責務境界
- `docs/frontend/` に追加される handbook docs 全般

`docs/README.md` の Index / 使い方で frontend docs を参照している箇所も、frontend docs 追加・変更時に合わせて更新する。

## 作業の流れ

1. **依頼の種類を分ける**
   - 責務境界・置き場所 → `overview.md`
   - `docs/backend/*.md` → `pj-docs-updater-backend`
   - `docs/database/*.md` → `pj-docs-updater-database`
2. **source of truth を読む**
   - `volumes/frontend/app/`
   - `volumes/frontend/features/`
   - `volumes/frontend/components/layouts/`
   - `volumes/frontend/lib/http-client.ts`
   - `volumes/frontend/lib/api/`
   - `volumes/frontend/lib/actions/`
   - `volumes/frontend/lib/revalidate-paths.ts`
3. **変更対象の docs を最小スコープで更新**
4. **導線をそろえる**
   - `docs/README.md` の Index / 使い方（frontend 関連）
   - frontend docs 間の相互リンク
5. **差分を要約**

## 判断基準

- Next.js 一般論ではなく、この repo の route / feature / data access 境界を書く
- `app` を入口、`features` を画面単位 UI、`lib/api` と `lib/actions` を通信境界として扱う
- 代表コードリンクは少数に絞り、ラベルは `volumes/...` の実パスでそろえる

## やらないこと

- アプリ実装を docs の都合だけで変更しない
- `docs/backend/*.md` をこのスキルで直接編集しない
- `docs/database/*.md` をこのスキルで直接編集しない
- 代表コードを増やしすぎない
- 一般的な Next.js 解説へ広げすぎない

## 完了チェック

- [ ] 変更内容が frontend docs の責務に閉じている
- [ ] source of truth と矛盾していない
- [ ] 代表コードリンクが `volumes/...` ラベルでそろっている
- [ ] `docs/README.md` の frontend 関連 Index が壊れていない
