---
name: pj-docs-updater-backend
description: price-monitoring の docs/backend/*.md（overview.md、rails-upgrade.md など）をメンテする。 Rails BFF / batch の責務境界・置き場所・運用手順を実装判断に使える形で保つ。 backend docs 更新、BFF 設計判断の文書化、Rails アップグレード手順の更新で使う。 docs/database/*.md は pj-docs-updater-database に委譲する。
---
# Backend ドキュメント（docs/backend/*.md）

Rails BFF / batch 側の handbook docs を、実装判断に使える状態へ保つ。
事実の写経ではなく、責務境界・置き場所・参照導線を整理する。

規約: [references/backend-conventions.md](references/backend-conventions.md)

## 対象ファイル

- `docs/backend/overview.md` — 責務境界、置いてよい/ない責務、この repo での見方
- `docs/backend/rails-upgrade.md` — Rails バージョンアップ手順
- `docs/backend/` に追加される handbook docs 全般

`docs/README.md` の Index / 使い方で backend docs を参照している箇所も、backend docs 追加・変更時に合わせて更新する。

## 作業の流れ

1. **依頼の種類を分ける**
   - 責務境界・置き場所 → `overview.md`
   - Rails アップグレード手順 → `rails-upgrade.md`
   - `docs/database/*.md` → `pj-docs-updater-database`
2. **source of truth を読む**
   - `volumes/backend/app/controllers/`
   - `volumes/backend/app/models/`
   - `volumes/backend/app/services/`
   - `volumes/backend/app/sidekiq/`
   - `volumes/backend/app/serializers/`
   - `volumes/backend/app/finders/`
3. **変更対象の docs を最小スコープで更新**
4. **導線をそろえる**
   - `docs/README.md` の Index / 使い方（backend 関連）
   - backend docs 間の相互リンク
5. **差分を要約**

## 判断基準

- Rails 一般論ではなく、この repo の BFF / batch 責務境界を書く
- 「controller で受ける」「service で組み立てる」「sidekiq で非同期化する」の境界を先に示す
- 代表コードリンクは少数に絞り、ラベルは `volumes/...` の実パスでそろえる

## やらないこと

- アプリ実装を docs の都合だけで変更しない
- `docs/database/*.md` をこのスキルで直接編集しない
- `docs/frontend/*.md` をこのスキルで直接編集しない
- 代表コードを増やしすぎない
- 一般的な Rails 解説へ広げすぎない

## 完了チェック

- [ ] 変更内容が backend docs の責務に閉じている
- [ ] source of truth と矛盾していない
- [ ] 代表コードリンクが `volumes/...` ラベルでそろっている
- [ ] `docs/README.md` の backend 関連 Index が壊れていない
- [ ] database docs の更新が必要なら `pj-docs-updater-database` へ委譲している
