# Build Instructions

Ruby on Rails の BFF はイメージの中で動く。ホストで `bundle` は実行しない。

## 依存関係

イメージに入っている。この変更で Gemfile は変えていない。

## 環境

リポジトリルートで Compose を使う。データベースが空の worktree では、起動のあと `just prepare` を一度実行する。

```bash
just ps
just up
just prepare
```

## ビルド

この変更にコンパイルは無い。アプリの起動確認は `just ps` で `backend` が Up であること。

## 確認

商品計測の同期スペック:

```bash
just rspec-backend spec/services/product_monitoring/sync_crawl_results_spec.rb
```

既存の backend スイートが緑であることの確認:

```bash
just rspec-backend
```

## うまく動かないとき

`backend` が Up でないときは `just up` のあと、同じコマンドを再実行する。マイグレーションが無いときは `just prepare` を実行する。
