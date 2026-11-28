# Database

BFF / batch のデータ設計を変更する開発者向けに、どの単位でデータを分けているかを解説するページです。Provider の DB は対象外です。
カラムとインデックスは [ER](er.md)、機能文書がまだ無い領域のテーブル間関連は [アソシエーション](association.md) に置きます。このページでは領域の切り方だけを扱います。商品モニタリングのテーブル定義と関連は [商品モニタリングの DB](../../features/product-monitoring/database.md) を参照します。

## 文書の案内

- [カラム・インデックス](er.md)
- [テーブル間関連](association.md) — 機能文書がまだ無い領域
- [商品モニタリング](../../features/product-monitoring/external-spec.md) — 収集結果とモニタリング・集計の振る舞い
- [商品モニタリングの DB](../../features/product-monitoring/database.md) — この機能のテーブル定義とテーブル間の関連
- [文書全体の索引](../../README.md)

## 判断基準

- 商品モニタリングは独立したテーブル群を使う。テーブル定義と関連は[商品モニタリングの DB](../../features/product-monitoring/database.md)、振る舞いは[商品モニタリングの外部仕様](../../features/product-monitoring/external-spec.md)を参照する
- Backmarket の監視対象と取得結果は、商品モニタリングの収集設定とは別テーブルに分ける
- 日次集計のような派生データは、元データと別テーブルに分けて保存する
- `users` は商品・クロール領域と分離する

## テーブル群の見方

### 商品モニタリング

- 収集設定、収集結果、モニタリング設定、日次相場は商品モニタリングのテーブル群に置く
- テーブル定義と関連は[商品モニタリングの DB](../../features/product-monitoring/database.md)を参照する

### Backmarket 監視

- `backmarket_watch_targets` が監視対象、`backmarket_watch_results` が取得結果を持つ
- 商品モニタリングの収集設定・収集結果とは別パターンとして扱う

### 認証

- `users` は OpenID Connect 連携用の identity を持つ（商品・クロール領域とは分離する）

### 集計データ

- 商品モニタリングの日次相場は `product_monitoring_daily_market_prices`。定義は[商品モニタリングの DB](../../features/product-monitoring/database.md)を参照する
- 元データの更新と集計の更新を分離したいので、集計結果は別テーブルにする

## 避けること

- 商品モニタリングと Backmarket の取得結果を同じテーブルに混ぜない
- 集計済みの値で元データを上書きしない

## 関連 docs

- [`er.md`](er.md)
- [`association.md`](association.md)
- [プロジェクト README](../../../README.md)

## 代表コード

- [`volumes/backend/db/schema.rb`](../../../volumes/backend/db/schema.rb)
- [`volumes/backend/app/models/backmarket_watch_target.rb`](../../../volumes/backend/app/models/backmarket_watch_target.rb)
- [`volumes/backend/app/controllers/api/v1/backmarket_watch_targets_controller.rb`](../../../volumes/backend/app/controllers/api/v1/backmarket_watch_targets_controller.rb)

## 更新時に確認する source of truth

- [`volumes/backend/db/schema.rb`](../../../volumes/backend/db/schema.rb)
- `volumes/backend/db/migrate/`
