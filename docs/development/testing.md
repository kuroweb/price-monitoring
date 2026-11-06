# テスト

ローカルで RSpec・静的検証・frontend のテストを実行する開発者向けの手順。以下はホストのリポジトリルートで実行し、just / Docker Compose が起動中のコンテナ内でテストを実行する。先に [起動と状態確認](operations.md#起動と状態確認) で対象 service が起動していることを確認する。

## バックエンド / 認証アプリの RSpec

認証アプリのテスト DB・アセットは、先に [認証の検証準備](../auth-provider/verification.md) を行う。

```bash
just rspec-backend
just rspec-auth-provider
```

対象ファイル・行・RSpec オプションを指定できる。`<target>` と行番号は対象に置き換える。

```bash
just rspec-backend spec/models/<target>_spec.rb
just rspec-backend spec/models/<target>_spec.rb:42
```

失敗したら対象の spec だけを再実行し、必要に応じて `just logs` で依存サービスの状態を確認する。

## バックエンド / 認証アプリの静的検証

```bash
just rubocop-backend
just rubocop-auth-provider
```

対象ファイルや RuboCop のオプションを引数として渡せる。

既存の違反は各アプリの `.rubocop_todo.yml` で cop とファイルの組み合わせごとに除外している。同じファイルで同じ cop の違反が増えても検出されないため、修正時に除外を削除して再検査する。

## frontend の静的検証

```bash
docker compose exec frontend npm run lint
docker compose exec frontend npm run typecheck
```

## frontend のテスト

単体・コンポーネントテストは Vitest と React Testing Library を使う。バックエンドや認証アプリへの接続は不要。初回導入時や依存関係の更新後は、起動中の `frontend` コンテナで `docker compose exec frontend npm ci` を実行する。

```bash
just test-frontend
just test-frontend-watch
just test-frontend-coverage
```

通常実行は一度で終了し、watch は変更時に再実行する。カバレッジはターミナルと `volumes/frontend/coverage/` に出力する。未テストの実装も集計するが、導入時点ではカバレッジの下限を設けない。

対象ファイルやテスト名を絞る場合は引数を渡す。角括弧を含むパスは、シェルの展開を避けるため引用する。

```bash
just test-frontend CategoryNavigation.test.tsx
just test-frontend 'tests/features/products/[id]/lib/makePlatformMask.test.ts'
just test-frontend -t '最初のページ'
```

テストの配置と対象範囲は [Frontend のテスト方針](../frontend/index.md#テスト方針) を参照する。PR では [Frontend CI](../cicd/index.md#pull-request-の自動テスト) が lint・型検査・テストを実行する。
