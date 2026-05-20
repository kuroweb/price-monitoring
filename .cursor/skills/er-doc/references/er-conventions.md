# docs/er.md 規約

テーブル定義専用。リレーション図は `docs/association.md`（`association-doc` スキル）。

## 見出し構成

```
# ER
## テーブル名
### カラム
### インデックス
```

| レベル | 用途 |
|--------|------|
| `## テーブル名` | `schema.rb` の `create_table` 名そのまま |
| `### カラム` | 全カラム |
| `### インデックス` | インデックス。無ければ「なし」または省略 |

テーブルはアルファベット順を推奨（既存ファイルの並びに合わせてもよい）。

## テンプレート

````markdown
## {テーブル名}

### カラム

| カラム | 型 | NULL | 備考 |
|--------|-----|------|------|
| id | bigint | NOT NULL | PK |
| name | string | NOT NULL |  |

### インデックス

| 名前 | カラム | 備考 |
|------|--------|------|
| index_{テーブル名}_on_name | name | unique |
````

## ソースデータ

根拠: `volumes/backend/db/schema.rb`（**編集しない**）

| 参照元 | 書き先 |
|--------|--------|
| `create_table` | `### カラム` |
| `t.index` | `### インデックス` |
| PK | 備考 `PK` |
| `add_foreign_key` / `t.references` | 備考 `FK` |

**型**

| schema.rb | er.md |
|-----------|-------|
| `bigint` | bigint |
| `string` | string |
| `text` | text |
| `integer` | integer |
| `boolean` | boolean |
| `datetime` | datetime |
| `date` | date |

- `null: false` → `NOT NULL`
- `created_at` / `updated_at` は既存の同テーブル記載に合わせる
