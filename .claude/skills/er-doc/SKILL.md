---
name: er-doc
description: >-
  price-monitoring の docs/er.md（テーブル定義のみ）をメンテする。アソシエーション図は docs/association.md
  を担当する別スキル。構成は ## テーブル名 / ### カラム / ### インデックス。事実は volumes/backend/db/schema.rb
  から転記（編集しない）。 テーブル追加・カラム変更・スキーマドキュメント、「er.md を更新して」で使う。
---
# ER ドキュメント（docs/er.md）

テーブル単位のカラム・インデックスのみ。Mermaid やリレーション線は書かない。

規約: [references/er-conventions.md](references/er-conventions.md)

## 作業の流れ

1. **変更対象のテーブルを特定**
2. **`schema.rb` を読む** — [ソースデータ](references/er-conventions.md#ソースデータ)
3. **`docs/er.md` を更新** — `## テーブル名` と `### カラム` / `### インデックス`
4. **差分を要約**

FK を追加・変更したときは、ユーザーに `docs/association.md` の更新も必要か確認する（`association-doc` スキル）。

## やらないこと

- `schema.rb` の編集、マイグレーション実行
- `docs/association.md` の編集（依頼がない限り）
- `er.md` に Mermaid を書く

## 完了チェック

- [ ] 各テーブルに `### カラム` と `### インデックス`（または省略理由）
- [ ] 内容が `schema.rb` と一致
- [ ] `add_foreign_key` がある列に備考 `FK` がある
