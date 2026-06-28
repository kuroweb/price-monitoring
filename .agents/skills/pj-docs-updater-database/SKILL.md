---
name: pj-docs-updater-database
description: >-
  price-monitoring の docs/database/*.md（overview.md、er.md、association.md）をメンテする。
  overview は領域の切り方と導線、er はテーブル定義（## テーブル名 / ### カラム / ### インデックス）、
  association は PK/FK と Mermaid 線のみ。事実は volumes/backend/db/schema.rb から転記
  （編集しない）。スキーマ変更・ER 図・リレーション図・database docs 更新で使う。
  docs/backend/*.md は pj-docs-updater-backend、docs/frontend/*.md は pj-docs-updater-frontend に委譲する。
targets: ["*"]
---

# Database ドキュメント（docs/database/*.md）

`docs/database/` 配下の docs を一括で保守する。schema 由来の事実は `schema.rb` から転記し、overview は設計判断の入口として保つ。

規約:

- [references/overview-conventions.md](references/overview-conventions.md) — `overview.md`
- [references/er-conventions.md](references/er-conventions.md) — `er.md`
- [references/association-conventions.md](references/association-conventions.md) — `association.md`

## 対象ファイル

- `docs/database/overview.md` — 領域の切り方、判断基準、詳細 docs への導線
- `docs/database/er.md` — テーブル単位のカラム・インデックス（Mermaid なし）
- `docs/database/association.md` — テーブル間 PK/FK と Mermaid 線（カラム一覧なし）

## 作業の流れ

1. **依頼の種類を分ける**
   - 領域の切り方・判断基準・導線 → `overview.md`
   - テーブル追加・カラム変更・インデックス → `er.md`
   - FK 追加・変更・リレーション図 → `association.md`
   - スキーマ変更で FK が絡む → `er.md` と `association.md` を両方更新
2. **`schema.rb` を読む** — 各規約の「ソースデータ」節を参照（**編集しない**）
3. **変更対象の docs を最小スコープで更新**
4. **相互整合を確認**
   - `er.md` の FK 備考と `association.md` の線が一致
   - `overview.md` から `er.md` / `association.md` へ辿れる
   - `docs/README.md` の database 関連 Index / 使い方
5. **差分を要約**

## ファイルごとの責務

| ファイル | 書くこと | 書かないこと |
|----------|----------|--------------|
| `overview.md` | 判断基準、テーブル群の見方、関連 docs | 全カラム転記、Mermaid |
| `er.md` | カラム・インデックス表 | Mermaid、リレーション線 |
| `association.md` | PK/FK カラムと Mermaid 線 | PK/FK 以外のカラム |

## やらないこと

- `schema.rb` の編集、マイグレーション実行
- `er.md` に Mermaid を書く
- `association.md` に PK/FK 以外のカラムを書く
- `: "1:N"` などの多重度ラベル（`category_hierarchies` の役割ラベル例外は conventions 参照）
- `overview.md` をテーブル一覧の転記にする
- `docs/backend/*.md` / `docs/frontend/*.md` をこのスキルで直接編集しない

## 完了チェック

- [ ] 変更内容が対象ファイルの責務に閉じている
- [ ] `er.md` の内容が `schema.rb` と一致
- [ ] `add_foreign_key` がある列に `er.md` 備考 `FK` がある
- [ ] `association.md` の PK/FK と線が `schema.rb` の FK と一致
- [ ] `er.md` の FK 備考と `association.md` が矛盾しない
- [ ] `overview.md` の導線と判断基準が現状の schema / 設計と整合
- [ ] `docs/README.md` の database 関連 Index が壊れていない
