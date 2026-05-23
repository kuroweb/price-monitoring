# Docs Handbook

この `docs/` は、price-monitoring の設計判断を共有するための handbook です。
実装前に責務境界や置き場所を確認したいときは、まずこの配下を参照します。

## 使い方

- データ構造やテーブルの事実を確認したいときは `docs/databases/` を見る
- Rails BFF の責務境界を確認したいときは `docs/backend/overview.md` を見る
- Rails のバージョンアップ手順を確認したいときは `docs/backend/rails-upgrade.md` を見る
- Next.js frontend の責務境界を確認したいときは `docs/frontend/overview.md` を見る

## Source Of Truth

- データベースの事実の正本は [`volumes/backend/db/schema.rb`](../volumes/backend/db/schema.rb)
- コードの事実の正本は `volumes/backend/` と `volumes/frontend/` 配下の実装
- この handbook は、実装先や責務分離の判断基準を整理するためのドキュメント

## Index

- [`databases/overview.md`](./databases/overview.md)
- [`databases/er.md`](./databases/er.md)
- [`databases/association.md`](./databases/association.md)
- [`backend/overview.md`](./backend/overview.md)
- [`backend/rails-upgrade.md`](./backend/rails-upgrade.md)
- [`frontend/overview.md`](./frontend/overview.md)
