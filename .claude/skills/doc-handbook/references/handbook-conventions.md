# handbook docs 規約

## 対象

- `docs/README.md`
- `docs/databases/overview.md`
- `docs/backend/overview.md`
- `docs/frontend/overview.md`

`docs/databases/er.md` と `docs/databases/association.md` は詳細 docs であり、この規約の主対象ではない。

## 基本方針

- handbook は実装判断のための docs
- 事実の正本は実装と `schema.rb`
- docs は判断基準、責務境界、導線を整理する
- 結論先出しで短く書く
- 一般論ではなく、この repo に固有の構成と責務を書く

## 推奨セクション

### `docs/README.md`

- 何のための docs か
- いつ読むか
- source of truth の線引き
- index

### overview 系ページ

- 導入
- `## 判断基準`
- 必要に応じて `## 置いてよい責務` や `## このプロジェクトでの見方`
- `## 避けること`
- `## 関連 docs`
- `## 代表コード`
- `## 更新時に確認する source of truth`

## リンク規約

- handbook 内リンクは相対パスで書く
- 代表コードのラベルは説明名ではなく `volumes/...` の実パスを使う
- 代表コードは各ページ 3〜6 件程度に抑える

## source of truth

### database

- `volumes/backend/db/schema.rb`
- `volumes/backend/db/migrate/`

### backend

- `volumes/backend/app/controllers/`
- `volumes/backend/app/models/`
- `volumes/backend/app/services/`
- `volumes/backend/app/sidekiq/`
- `volumes/backend/app/serializers/`
- `volumes/backend/app/finders/`

### frontend

- `volumes/frontend/app/`
- `volumes/frontend/features/`
- `volumes/frontend/components/layouts/`
- `volumes/frontend/lib/api/`
- `volumes/frontend/lib/actions/`

## 委譲ルール

- テーブル定義の更新は `doc-er`
- Mermaid のアソシエーション更新は `doc-association`
- handbook から詳細 docs への導線を足すのはこのスキルの担当
