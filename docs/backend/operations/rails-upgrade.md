# Rails バージョンアップ

このページは、price-monitoring の Rails（BFF / batch）をメジャー・マイナー更新するときの手順をまとめた handbook です。
責務境界は [`index.md`](../index.md) を参照する。
以下のシェル例はホストのリポジトリルートから実行し、アプリの処理は `backend` コンテナ内で行う。

## 判断基準

- [Upgrading Ruby on Rails](https://guides.rubyonrails.org/upgrading_ruby_on_rails.html) に沿う（`bundle update` → `app:update` → 検証）
- gem の更新と設定生成は **Docker 経由**、検証は **`just rspec-backend`**
- マイナーバージョンは一つずつ上げ、deprecation を潰してから次へ進む
- `app:update` の生成物は正規手順の一部として残し、diff を見てから取捨選択する

## 手順

1. **前提**: [ローカル開発](../../development/index.md#初回セットアップ) に従い DB / Redis / `backend` を起動して状態を確認する。
2. **Gemfile**: `volumes/backend/Gemfile` の `rails` を目標バージョンに更新する。
3. **bundle**: ホストではなくコンテナ内で更新する。

   ```bash
   docker compose run --rm backend bundle update rails
   ```

4. **app:update**: 公式の設定・ファイル更新を行う。

   ```bash
   docker compose run --rm backend bin/rails app:update
   ```

   - 既存の `config/application.rb` や `config/environments/*.rb` など、カスタムがあるファイルは **上書きせず** `n`（保持）または `d`（diff 確認）で差分を取り込む。
   - `app:update` が生成したファイル（initializer、migration、`public/*`、`bin/*` など）は **削除しない**。不要かどうかは diff を見て判断する。
5. **framework defaults**: `config/application.rb` の `config.load_defaults` を目標バージョンに合わせる。`config/initializers/new_framework_defaults_*` が作られたら、項目は段階的にコメントを外して有効化する。
6. **migrate**: migration が増えたら実行する。

   ```bash
   docker compose run --rm backend bin/rails db:migrate
   ```

7. **検証**: [共通テスト手順](../../development/index.md#テスト) の BFF 側 RSpec と、以下の自動読み込み確認を実行する。

   ```bash
   docker compose run --rm backend bin/rails zeitwerk:check
   ```

8. **ローカルへの反映**: [日常操作](../../development/index.md#日常操作) に従い backend / batch コンテナを再起動する。イメージの再ビルドが必要なら [イメージの準備](../../development/index.md#2-イメージの準備) から行う。Integration / Production への反映は [CI/CD](../../cicd/index.md) を参照する。

## 避けること

- GitHub 上のテンプレートを手でコピーして `app:update` の代わりにしない（差分の取りこぼしやプロジェクト固有ファイルの欠落につながる）。
- `app:update` の成果物だけを「範囲外」と判断して削除する（正規手順の一部である）。
- [実行先の規約](../../../AGENTS.md#コマンドの実行場所) に反して、ホストでアプリの依存関係を操作する。

## 関連 docs

- [プロジェクト README](../../../README.md)
- [`../index.md`](../index.md)
- [Upgrading Ruby on Rails](https://guides.rubyonrails.org/upgrading_ruby_on_rails.html)（外部）

## 代表コード

- [`volumes/backend/Gemfile`](../../../volumes/backend/Gemfile)
- [`volumes/backend/config/application.rb`](../../../volumes/backend/config/application.rb)

## 更新時に確認する source of truth

- `volumes/backend/Gemfile` / `volumes/backend/Gemfile.lock`
- `volumes/backend/config/application.rb`
- `volumes/backend/config/environments/`
- `volumes/backend/config/initializers/new_framework_defaults_*.rb`
- `volumes/backend/db/migrate/`
