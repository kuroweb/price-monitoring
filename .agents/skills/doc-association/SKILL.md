---
name: doc-association
description: >-
  price-monitoring の docs/databases/association.md（テーブル間リレーション）をメンテする。
  テーブル定義は docs/databases/er.md（doc-er スキル）が担当する。構成は ## 区分1 /
  ### 区分2（任意）/ Mermaid erDiagram（PK・FK と線のみ）。schema.rb を参照して整合
  （編集しない）。アソシエーション図・ER 図・リレーション図、「association.md を更新して」
  で使う。
targets: ["*"]
---

# アソシエーションドキュメント（docs/databases/association.md）

テーブル間の PK/FK 関係のみ。カラム一覧は `docs/databases/er.md` に書かない。

規約: [references/association-conventions.md](references/association-conventions.md)

## 作業の流れ

1. **対象の区分・テーブル関係を特定**
2. **`schema.rb` を読む** — [ソースデータ](references/association-conventions.md#ソースデータ)
3. **`docs/databases/association.md` を更新** — 該当 `##` / `###` 配下の Mermaid
4. **差分を要約**

テーブル定義の変更は `doc-er` スキルで `docs/databases/er.md` を更新する。

## やらないこと

- `schema.rb` の編集、マイグレーション実行
- `docs/databases/er.md` の編集（依頼がない限り）
- 図に PK/FK 以外のカラムを書く
- `: "1:N"` などの多重度ラベル

## 完了チェック

- [ ] 図の PK/FK が `schema.rb` の FK と一致
- [ ] `docs/databases/er.md` の FK 備考と矛盾しない
- [ ] 区分の見出し階層が conventions と一致
