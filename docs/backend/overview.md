# Backend Overview

このページは Rails 一般論ではなく、このプロジェクトの BFF / batch 側でどこに何を書くかを揃えるための handbook です。
実装時は「controller で受ける」「service で組み立てる」「sidekiq で非同期化する」の境界を先に確認します。

## 判断基準

- `controllers` は HTTP の入出力、認可、パラメータ受け取り、レスポンス返却に寄せる
- 複数モデルにまたがる作成更新や業務手順は `services` に寄せる
- Active Record の永続化責務は `models` に寄せる
- 非同期実行の入口は `app/sidekiq` に寄せ、実際の処理本体は service に寄せる
- JSON の整形は serializer に寄せ、 finder は取得条件の組み立てに絞る

## 置いてよい責務

### controllers

- request params の受け取り
- finder / service 呼び出しの起点
- serializer を使った response の返却

### services

- 複数の model や setting をまとめて更新する処理
- クロール処理や同期処理の手順制御
- 集計処理の orchestration

### sidekiq

- queue 設定
- job の起動引数
- timeout や retry の制御

## 置かない責務

- controller に複雑な永続化ロジックをため込まない
- sidekiq job にクロール本体や更新本体を書かない
- serializer に検索条件や更新条件を持ち込まない
- finder を更新系 service の代わりに使わない

## このプロジェクトでの見方

### API/BFF

- `Api::V1::*Controller` が frontend からの入口
- 商品以外にも `categories` `product_prices` `backmarket_recents` `backmarket_watch_targets` など、リソース単位で controller を分ける
- `ProductFinder` のような finder が一覧取得条件を組み立てる
- `Api::*Serializer` が response shape を決める

### 認証

- `SessionsController` と `OidcTokenControl` が OIDC ログイン・トークン検証の境界
- 認可や session の扱いは controller / concern に閉じ、service へ散らさない

### 業務処理

- `Products::Creator` `Products::Updater` が商品と各種 crawl setting の更新をまとめる
- `Products::Inspector` が crawl setting 更新後の検証を持つ
- `RetrieveRelatedProducts` が相場表示用の取得処理を持つ
- `Crawl::*::Syncer` や `Crawler` がプラットフォームごとの同期処理を持つ
- `Products::CalculateDailyPurchaseSummary` が日次集計の計算を持つ

### 非同期処理

- `app/sidekiq/crawl/*` は enqueue と sync の job を置く
- `app/sidekiq/products/*` は集計など商品横断の job を置く
- job 自体は薄く保ち、実処理は `services/crawl/*` や `services/products/*` に委譲する

## 避けること

- 新しい API を追加するたびに controller へ業務手順を直書きする
- クロール対象ごとの重複ロジックを job 側へ増やす
- response shape の都合で model に presentation 寄りの責務を足す

## 関連 docs

- [`../README.md`](../README.md)
- [`../databases/overview.md`](../databases/overview.md)
- [`./rails-upgrade.md`](./rails-upgrade.md)

## 代表コード

- [`volumes/backend/app/controllers/api/v1/products_controller.rb`](../../volumes/backend/app/controllers/api/v1/products_controller.rb)
- [`volumes/backend/app/controllers/concerns/oidc_token_control.rb`](../../volumes/backend/app/controllers/concerns/oidc_token_control.rb)
- [`volumes/backend/app/services/products/creator/create_product.rb`](../../volumes/backend/app/services/products/creator/create_product.rb)
- [`volumes/backend/app/sidekiq/crawl/backmarket/sync_job.rb`](../../volumes/backend/app/sidekiq/crawl/backmarket/sync_job.rb)
- [`volumes/backend/app/services/retrieve_related_products/retriever.rb`](../../volumes/backend/app/services/retrieve_related_products/retriever.rb)

## 更新時に確認する source of truth

- `volumes/backend/app/controllers/`
- `volumes/backend/app/models/`
- `volumes/backend/app/services/`
- `volumes/backend/app/sidekiq/`
- `volumes/backend/app/serializers/`
- `volumes/backend/app/finders/`
