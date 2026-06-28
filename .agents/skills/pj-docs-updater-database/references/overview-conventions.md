# docs/database/overview.md 規約

設計判断の入口。テーブル定義の転記は `er.md`、リレーション詳細は `association.md` に委ねる。

## 基本方針

- テーブル一覧を読むためではなく、どの単位でデータを分けているかを判断するためのページ
- 事実の正本は `volumes/backend/db/schema.rb`
- 結論先出しで短く書く
- 一般論ではなく、この repo に固有の構成と責務を書く

## 推奨セクション

- 導入（このページの目的）
- `## 判断基準`
- `## テーブル群の見方`（必要に応じて `###` で領域分割）
- `## 避けること`
- `## 関連 docs` — `./er.md` `./association.md` `../README.md`
- `## 代表コード` — ラベルは `volumes/...` の実パス
- `## 更新時に確認する source of truth`

## リンク規約

- handbook 内リンクは相対パス
- 代表コードは 3〜6 件程度

## ソースデータ

- `volumes/backend/db/schema.rb`
- `volumes/backend/db/migrate/`
- 必要に応じて `volumes/backend/app/models/` `services/` など代表実装

テーブル追加・領域変更時は、判断基準と「テーブル群の見方」が schema と矛盾しないか確認する。

## 委譲ルール

- `docs/backend/*.md` の更新は `pj-docs-updater-backend`
- `docs/frontend/*.md` の更新は `pj-docs-updater-frontend`
- database docs 追加時は `docs/README.md` の Index / 使い方を更新する
