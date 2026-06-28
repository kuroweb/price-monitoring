---
paths:
  - '**/*'
---
## 開発ワークフロー

### 開発・運用環境

- 開発環境は Docker Compose を基本とする。
- 本番環境は自宅 Kubernetes（Master 1 / Worker 3）を利用する。
- CI/CD は GitHub Actions で運用する。

### ローカル開発ワークフロー

1. 初回セットアップ: 証明書作成と `/etc/hosts` 設定を行う（README の手順に従う）。
2. イメージ準備: `docker compose build`
3. 起動: `just up`
4. 状態確認: `just ps`（起動確認） / `just logs`（エラー確認）
5. 依存関係更新: npm パッケージを追加・更新する場合はホストで `npm i` せず、`docker compose run --rm frontend npm i` を使う
6. 実装・修正: 既存の責務境界（Frontend / BFF / Batch）を維持して変更
7. 検証: 変更範囲に応じて `just rspec` などを実行
8. 終了: `just down`

### 主要コマンド

- `just up`: Docker Compose の全サービスをバックグラウンド起動
- `just down`: Docker Compose の全サービス停止とネットワーク破棄
- `just ps`: コンテナ稼働状態の確認
- `just logs`: 全サービスのログをフォロー表示
- `just restart-all`: 全サービスを再起動
- `just restart <container-name>`: 指定コンテナのみ再起動
- `just attach <container-name>`: 指定コンテナにアタッチして対話確認
- `just rspec [args...]`: Rails のテスト実行。引数で対象ファイル・行・オプションを指定可能（`spring` コンテナ経由）
- `docker compose build`: ローカル開発用イメージ再ビルド
- `docker compose run --rm frontend npm i`: frontend の npm 依存関係を Docker 経由で追加・更新する。ホストで `npm i` は実行しない
- `make build-all` / `make push-all`: デプロイ用イメージのビルド・push（主に運用向け）

### テスト実行ガイド

- 前提: `just up` 後に `spring` コンテナが起動していることを `just ps` で確認する。
- 全体実行: `just rspec`（ローカル反復向け。`spring` コンテナを利用）
- 単一ファイル実行: `just rspec spec/models/<target>_spec.rb`
- 行指定実行: `just rspec spec/models/<target>_spec.rb:42`
- 失敗時の切り分け: まず対象 spec を単体で再実行し、必要に応じて `just logs` で依存サービスの状態を見る。

### 実装時の判断基準

- まず `just ps` で実行環境を確認し、未起動なら `just up` を優先する。
- 不具合調査は `just logs` で事実確認してから修正に入る。
- frontend の依存関係更新はホスト環境ではなく `frontend` コンテナ内で行う。
- 変更対象は最小スコープに限定し、既存の責務分離（Frontend / BFF / Batch）を崩さない。
- 変更は必要最小限にし、学習目的を踏まえて可読性を優先する。
- 監視・運用影響がある変更では Datadog / BugSnag への影響も確認する。
- コマンド追加や運用変更が必要な場合は、`README.md` / `justfile` / `Makefile` の整合を保つ。
- デプロイ用の `make` タスクは、ローカル開発修正だけなら原則触らない。

### 変更後チェックリスト

- 変更ファイルが対象レイヤーに閉じているか
- ローカル実行手順に影響がある場合、関連ドキュメントを更新したか
- 必要なテストまたは最低限の動作確認を実施したか
- 監視・運用影響がある変更かどうかを確認したか
