# docs/databases/association.md 規約

リレーション専用。カラム・インデックスの一覧は `docs/databases/er.md`（`doc-er` スキル）。

## 見出し構成

```
# アソシエーション
## 区分1
### 区分2          ← 任意。不要なら省略して Mermaid を ## 直下に置く
```

| レベル | 用途 |
|--------|------|
| `## 区分1` | ドメイン大分類（例: クロール処理、相場集計） |
| `### 区分2` | 区分1内の単位（例: ヤフオク、カテゴリ） |

## テンプレート

`{区分1}` / `{区分2}` を置換。`### 区分2` が不要なら見出しを省略する。

````markdown
## {区分1}

### {区分2}

```mermaid
erDiagram
  {参照先} {
    bigint id PK
  }
  {参照元} {
    bigint id PK
    bigint {参照先}_id FK
  }
  {参照先} ||--o{ {参照元} : ""
```
````

## Mermaid の書き方

- エンティティ内は **PK・FK カラムのみ**
- `schema.rb` の `add_foreign_key` に対応する線を引く
- 関係線は Mermaid の構文上 ` : ""` が必須（空ラベル）
- 多重度ラベル（`: "1:N"` 等）は付けない
- FK のない論理関係は書かない

## 例外

### `category_hierarchies`（closure_tree）

- `schema.rb` に `add_foreign_key` はないが、図に含める
- `ancestor_id` / `descendant_id` は `categories.id` への論理 FK としてエンティティに `FK` を付け、`categories` へ線を引く
- `generations` は複合キーの一部として `PK` を付ける（サロゲート `id` なし）
- 同一テーブルへの2本の線は Mermaid 上区別が必要なため、多重度ではなく役割ラベルを付ける（例: `: "ancestor"` / `: "descendant"`）

## ソースデータ

根拠: `volumes/backend/db/schema.rb`（**編集しない**）

| 参照元 | 書き先 |
|--------|--------|
| テーブル一覧 | エンティティ名 |
| PK | エンティティ内 `PK` |
| `add_foreign_key` | エンティティ内 `FK` と線 |

整合確認: `docs/databases/er.md` の該当テーブルの `### カラム`（FK 備考）と一致させる。
