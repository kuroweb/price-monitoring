# Rails バージョンアップ

このページは、price-monitoring の Rails（BFF / batch）をメジャー・マイナー更新するときの手順をまとめた handbook です。
責務境界は [`architecture.md`](./architecture.md) を参照する。

## 判断基準

- [Upgrading Ruby on Rails](https://guides.rubyonrails.org/upgrading_ruby_on_rails.html) に沿う（`bundle update` → `app:update` → 検証）
- gem の更新と設定生成は **Docker 経由**、検証は **`just rspec`**
- マイナーバージョンは一つずつ上げ、deprecation を潰してから次へ進む
- `app:update` の生成物は正規手順の一部として残し、diff を見てから取捨選択する

## 手順

1. **前提**: `just up` で DB / Redis / `spring` が起動していることを `just ps` で確認する。
2. **Gemfile**: `volumes/backend/Gemfile` の `rails` を目標バージョンに更新する。
3. **bundle**: ホストではなくコンテナ内で更新する。

   ```bash
   docker compose run --rm backend bundle update rails
   ```

4. **app:update**: 公式の設定・ファイル更新を行う。

   ```bash
   docker compose run --rm backend bin/rails app:update
   ```

   - 既存の `config/application.rb` や `config/environments/*.rb` など、カスタムがあるファイルは **上書きせず** `n`（保持）または `d`（diff 確認）とする。
   - 一括で既存を触らず新規ファイルだけ作る場合は `--skip` を使う（`new_framework_defaults_*` や `active_storage:update` の migration など）。
   - `app:update` が生成したファイル（initializer、migration、`public/*`、`bin/*` など）は **削除しない**。不要かどうかは diff を見て判断する。
5. **framework defaults**: `config/application.rb` の `config.load_defaults` を目標バージョンに合わせる。`config/initializers/new_framework_defaults_*` が作られたら、項目は段階的にコメントを外して有効化する。
6. **migrate**: migration が増えたら実行する。

   ```bash
   docker compose run --rm backend bin/rails db:migrate
   ```

7. **検証**: テストと起動確認。

   ```bash
   just rspec
   docker compose run --rm backend bin/rails zeitwerk:check
   ```

8. **デプロイ**: 稼働中の backend / batch コンテナを再起動する（`just restart-all` など）。イメージに gem を焼いている場合は `docker compose build` も行う。

## 避けること

- GitHub 上のテンプレートを手でコピーして `app:update` の代わりにしない（差分の取りこぼしやプロジェクト固有ファイルの欠落につながる）。
- `app:update` の成果物だけを「範囲外」と判断して削除する（正規手順の一部である）。
- ホストで `bundle install` / `bundle update` する（開発環境は Docker Compose が正本）。

## 関連 docs

- [`../README.md`](../README.md)
- [`./architecture.md`](./architecture.md)
- [Upgrading Ruby on Rails](https://guides.rubyonrails.org/upgrading_ruby_on_rails.html)（外部）

## 代表コード

- [`volumes/backend/Gemfile`](../../volumes/backend/Gemfile)
- [`volumes/backend/config/application.rb`](../../volumes/backend/config/application.rb)

## 更新時に確認する source of truth

- `volumes/backend/Gemfile` / `volumes/backend/Gemfile.lock`
- `volumes/backend/config/application.rb`
- `volumes/backend/config/environments/`
- `volumes/backend/config/initializers/new_framework_defaults_*.rb`
- `volumes/backend/db/migrate/`
