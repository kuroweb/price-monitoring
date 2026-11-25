# Backend

このページは BFF / batch を変更する開発者向けに、このプロジェクトでどこに何を書くかを揃えるための設計解説です。
実装時は「controller で受ける」「service で組み立てる」「sidekiq で非同期化する」の境界を先に確認します。

## 文書の案内

- [運用手順](operations/index.md) — Rails 更新・Seed 投入
- [商品モニタリング](../features/product-monitoring/index.md) — 入口。API は [API](../features/product-monitoring/api.md)、取得方式は [内部仕様](../features/product-monitoring/internal-spec.md)
- [ローカル開発](../development/index.md) — セットアップ・日常操作・テストの案内
- [文書全体の索引](../index.md)

## 判断基準

- `controllers` は HTTP の入出力、認可、パラメータ受け取り、レスポンス返却に寄せる
- 複数モデルにまたがる作成更新や業務手順は `services` に寄せる
- Active Record の永続化責務は `models` に寄せる
- 非同期実行の入口は `app/sidekiq` に寄せ、実際の処理本体は service に寄せる
- read 系のレスポンス組み立ては serializer に寄せ、 finder は取得条件の組み立てに絞る

## テスト方針

- RSpec の `describe`・`context`・`it`・`shared_examples` の説明文は日本語で書く。クラス・モジュール・メソッドを指す `describe` はそのまま使う。
- `it` は振る舞いを「〜こと」で終え、`context` は「〜とき」「〜場合」で条件を表す。コード上の識別子や HTTP ステータスはそのまま使ってよい。

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
- `product_monitoring` `backmarket_recents` `backmarket_watch_targets` `current_user` など、リソース単位で controller を分ける
- `Api::*Serializer` が Backmarket の response shape を決める。商品モニタリングの response は controller が組み立てる

### 認証

- Provider / Client の配置・境界と、Provider のセットアップ・運用は [認証基盤](../auth-provider/index.md) を参照する

- `SessionsController` と `OidcTokenControl` が OIDC ログイン・トークン検証の境界
- 認可や session の扱いは controller / concern に閉じ、service へ散らさない

### 業務処理

- `ProductMonitoring::CrawlSetting` `ProductMonitoring::Monitor` が収集設定とモニタリング設定の更新をまとめる
- `ProductMonitoring::Crawling` がサイトごとの取得と保存を持つ
- `ProductMonitoring::Search` `ProductMonitoring::Notification` `ProductMonitoring::Aggregation` が収集結果の検索、通知、日次相場の集計を持つ
- `Crawl::Backmarket` が Backmarket の取得と差分通知を持つ

### 非同期処理

- `app/sidekiq/product_monitoring/*` は収集、通知、日次相場の job を置く
- `app/sidekiq/crawl/backmarket/*` は Backmarket の enqueue と sync の job を置く
- job 自体は薄く保ち、実処理は `services/product_monitoring/*` や `services/crawl/backmarket/*` に委譲する

## 避けること

- 新しい API を追加するたびに controller へ業務手順を直書きする
- クロール対象ごとの重複ロジックを job 側へ増やす
- response shape の都合で model に presentation 寄りの責務を足す

## 関連 docs

- [`../../README.md`](../../README.md)
- [`../database/index.md`](../database/index.md)
- [`./operations/rails-upgrade.md`](./operations/rails-upgrade.md)
- [Seed データの投入](operations/seeds.md)

## 代表コード

- [`volumes/backend/app/controllers/api/v1/product_monitoring/crawl_settings_controller.rb`](../../volumes/backend/app/controllers/api/v1/product_monitoring/crawl_settings_controller.rb)
- [`volumes/backend/app/controllers/concerns/oidc_token_control.rb`](../../volumes/backend/app/controllers/concerns/oidc_token_control.rb)
- [`volumes/backend/app/services/product_monitoring/crawling/client.rb`](../../volumes/backend/app/services/product_monitoring/crawling/client.rb)
- [`volumes/backend/app/sidekiq/crawl/backmarket/sync_job.rb`](../../volumes/backend/app/sidekiq/crawl/backmarket/sync_job.rb)
- [`volumes/backend/app/services/crawl/backmarket/syncer.rb`](../../volumes/backend/app/services/crawl/backmarket/syncer.rb)

## 更新時に確認する source of truth

- `volumes/backend/app/controllers/`
- `volumes/backend/app/models/`
- `volumes/backend/app/services/`
- `volumes/backend/app/sidekiq/`
- `volumes/backend/app/serializers/`
