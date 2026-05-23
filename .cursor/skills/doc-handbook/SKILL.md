---
name: doc-handbook
description: price-monitoring の handbook docs（docs/README.md、docs/databases/overview.md、 docs/backend/overview.md、docs/frontend/overview.md）をメンテする。 docs をブラッシュアップしたい、backend/frontend/databases の設計判断を書きたい、 handbook を更新したい、AI が参照しやすい docs にしたい、docs の入口や関連リンクを整理したい、 という依頼では積極的に使う。schema 由来のテーブル定義やリレーション詳細そのものは doc-er / doc-association に委譲する。
---
# Handbook ドキュメント

price-monitoring の handbook docs を、実装判断に使える状態へ保つ。
事実の写経ではなく、責務境界・置き場所・参照導線を整理する。

規約: [references/handbook-conventions.md](references/handbook-conventions.md)

## 対象ファイル

- `docs/README.md`
- `docs/databases/overview.md`
- `docs/backend/overview.md`
- `docs/frontend/overview.md`

## 作業の流れ

1. **依頼の種類を分ける**
   - handbook の入口・構成・判断基準・関連リンクの更新ならこのスキルで対応する
   - `schema.rb` 由来のテーブル定義は `doc-er`
   - FK 関係や Mermaid の更新は `doc-association`
2. **source of truth を読む**
   - handbook 全体: `docs/README.md`
   - database 設計の事実: `volumes/backend/db/schema.rb`
   - backend の責務境界: `volumes/backend/app/controllers/` `models/` `services/` `sidekiq/` `serializers/` `finders/`
   - frontend の責務境界: `volumes/frontend/app/` `features/` `components/layouts/` `lib/api/` `lib/actions/`
3. **変更対象の docs を最小スコープで更新する**
4. **必要なら関連 docs の導線をそろえる**
   - handbook の index や相互リンク
   - README の docs 導線
5. **差分を要約する**
   - 変更前の問題
   - 変更内容
   - 変更後の意図

## 判断基準

- handbook は「実装判断の基準」を書く。実装の全文説明や一般論の教科書にしない
- `docs/README.md` は入口と source of truth の線引きに集中させる
- `docs/databases/overview.md` はテーブル一覧の転記ではなく、領域の切り方と詳細 docs への導線を書く
- `docs/backend/overview.md` は Rails 一般論ではなく、この repo の責務境界を書く
- `docs/frontend/overview.md` は Next.js 一般論ではなく、この repo の責務境界を書く
- 代表コードリンクは少数に絞り、ラベルは `volumes/...` の実パスでそろえる

## やること

- handbook の見出し構成を保つ
- 判断基準、避けること、関連 docs、代表コード、更新時に確認する source of truth を整える
- 実装に合わせて責務境界の説明を更新する
- docs の相互リンクや README の導線を保守する

## やらないこと

- `schema.rb` やアプリ実装を docs の都合だけで変更しない
- `docs/databases/er.md` のテーブル定義をこのスキルで直接編集しない
- `docs/databases/association.md` の Mermaid をこのスキルで直接編集しない
- handbook に代表コードを増やしすぎない
- 一般的な技術解説へ広げすぎない

## 完了チェック

- [ ] 変更内容が handbook の責務に閉じている
- [ ] source of truth と矛盾していない
- [ ] 代表コードリンクが `volumes/...` ラベルでそろっている
- [ ] `docs/README.md` から辿れる構成が壊れていない
- [ ] schema 由来の詳細更新が必要なら `doc-er` / `doc-association` へ委譲している
