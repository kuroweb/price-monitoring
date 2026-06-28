# docs/backend/*.md 規約

## 対象

- `docs/backend/overview.md`
- `docs/backend/rails-upgrade.md`
- `docs/backend/` 配下に追加される handbook docs

`docs/database/*.md` は `docs-updater-database` スキルの対象。

## 基本方針

- backend docs は実装判断のための handbook
- 事実の正本は `volumes/backend/` 配下の実装
- docs は判断基準、責務境界、導線を整理する
- 結論先出しで短く書く
- Rails 一般論ではなく、この repo に固有の構成と責務を書く

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

### 手順系 docs（例: `rails-upgrade.md`）

- 導入（何のための手順か）
- `## 判断基準`
- `## 手順`
- `## 避けること`（必要に応じて）
- `## 関連 docs`
- `## 更新時に確認する source of truth`

## リンク規約

- docs 内リンクは相対パス
- 代表コードのラベルは `volumes/...` の実パス
- 代表コードは各ページ 3〜6 件程度

## source of truth

- `volumes/backend/app/controllers/`
- `volumes/backend/app/models/`
- `volumes/backend/app/services/`
- `volumes/backend/app/sidekiq/`
- `volumes/backend/app/serializers/`
- `volumes/backend/app/finders/`
- `volumes/backend/Gemfile`（Rails アップグレード手順向け）

## 委譲ルール

- `docs/database/*.md` の更新は `docs-updater-database`
- `docs/frontend/*.md` の更新は `docs-updater-frontend`
- backend docs 追加時は `docs/README.md` の Index / 使い方を更新する
