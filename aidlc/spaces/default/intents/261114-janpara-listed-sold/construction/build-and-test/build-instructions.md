# Build Instructions

対象: `volumes/backend`（Rails）。ビルド工程（コンパイル・バンドル）は無く、ビルドの確認は、アプリが起動してテストが読み込めること、RuboCop が通ることで行う。

## Dependency installation

- 依存関係の追加・更新は無い。`Gemfile` と lockfile は変更していない。
- ホストで `bundle` / `rails` / `rspec` を実行しない。すべて Docker Compose の `backend` コンテナで実行する（AGENTS.md の「コマンドの実行場所」）。

## Environment setup

- 状態の確認: `just ps`。未起動なら `just up`。
- テスト DB: 新しいボリュームで `backend_test` DB が無いと `NoDatabaseError` で失敗する。その場合は `just prepare`（`db:prepare`）で作る。
- 実サイトでの確認（プロキシ経由）は、起動した `backend` コンテナの `bin/rails runner` で行う。直接 IP からは取得しない。

## Build verification commands

```bash
just rubocop-backend
just rspec-backend spec/services/product_monitoring/sites/janpara_spec.rb spec/services/product_monitoring/sync_crawl_results_spec.rb
just rspec-backend
```

- 1 行目: バックエンド全体の静的検証。
- 2 行目: この修正の対象 spec（`code-generation/unit-test-instructions.md` と同じ）。
- 3 行目: 既存 suite 全体（bugfix の床「既存 suite を通したままにする」）。

## Troubleshooting

- `NoDatabaseError`（`backend_test` が無い）: `just prepare` を実行してから再実行する。
- 失敗した場合は、対象の spec だけを再実行し、必要に応じて `just logs` で依存サービスの状態を確認する。
- RuboCop の `Metrics/ClassLength` を超える場合は、`.rubocop_todo.yml` の除外を増やさず、コードを畳む。
