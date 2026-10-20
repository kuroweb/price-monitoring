# AGENTS.md

このファイルは、このリポジトリを変更する AI エージェント向けの実行制約と判断基準の正本。
プロジェクトの目的・構成は [README](README.md)、文書の読み手・配置・正本は [文書ガイド](docs/index.md) を参照する。

## コマンドの実行場所

- 開発環境は Docker Compose を使う。アプリに対する言語ツールは、調査・バージョン確認を含め、必ず下表のコンテナで実行する。
- ホストで `ruby` / `bundle` / `rails` / `rspec` / `node` / `npm` / `npx` / `python` / `pip` などを使ってアプリを調査・実行・更新しない。読み取り目的の `bundle show` などでも lockfile や依存関係が変わり得る。
- ホストではファイルの編集・検索、Git / GitHub CLI、Docker Compose / just / make、証明書・hosts の準備を行える。ホストにアプリ用の依存関係をインストールしない。
- コマンドはリポジトリルートから Docker Compose / just 経由で実行する。実行例は [ローカル開発ガイド](docs/development/index.md) を参照する。

| 対象 | Compose service | コンテナで実行するツール |
| --- | --- | --- |
| Next.js / TypeScript | `frontend` | Node.js / npm / npx / Next.js / TypeScript / ESLint |
| Rails BFF、batch と共通の依存関係・テスト | `backend` | Ruby / Bundler / Rails / RSpec、クロール補助の Python（`/opt/curlcffi-venv/bin/python`） |
| Sidekiq の各プロセス固有の調査 | `backend-batch-1` / `backend-batch-2` / `backend-batch-3` | Ruby / Bundler / Sidekiq（アプリは `backend` と共通） |
| OIDC Provider | `auth-provider` | Ruby / Bundler / Rails / RSpec、必要な Node.js / npm |
| Playwright サーバー | `backend-playwright` | Node.js / npm / Playwright |
| Camoufox サーバー | `backend-camoufox` | Python / pip / Camoufox / Playwright |

## 作業時の判断基準

- アプリの実行・検証の前に `just ps` で状態を確認し、未起動なら `just up` を使う。初回準備は [ローカル開発ガイド](docs/development/index.md) に従う。
- 不具合調査は `just logs` などでログの事実を確認してから修正する。
- 実装前に対象レイヤーの既存実装を読み、[backend](docs/backend/index.md) / [frontend](docs/frontend/index.md) の責務境界を守る。変更は最小スコープにし、可読性を優先する。
- 認証アプリと BFF の境界・配置は [認証基盤](docs/auth-provider/index.md) を参照する。OIDC endpoint / issuer / token / scope / session / 署名鍵に影響する変更では Provider と Client の両方を確認する。
- 検証は [テスト手順](docs/development/index.md#テスト) に従い、変更範囲に応じて選ぶ。失敗時は対象だけを再実行し、依存サービスの状態を確認する。
- 監視・運用に影響する変更では Datadog / BugSnag への影響を確認する。
- 操作や構成を変えたら [文書ガイド](docs/index.md) で正本を特定して更新し、`justfile` / `Makefile` / workflow との整合を保つ。
- デプロイ用の make タスクは、ローカル開発修正だけなら原則触らない。

## 変更後チェックリスト

- 変更が対象レイヤーに閉じているか
- 手順・構成に影響がある場合、正本の文書と参照リンクを更新したか
- 必要なテストまたは最低限の動作確認を実施したか
- 監視・運用への影響を確認したか

## エージェント設定

### Rules

- 正本は本ファイル（`AGENTS.md`）。`CLAUDE.md` は `@AGENTS.md` のインポートのみとし、他ツール向けの Rules 生成物は置かない。
- 変更は `AGENTS.md` を直接編集する。

### Skills

- 正本は `.agents/skills/`（`.agents/skills/*/SKILL.md`）。変更はここを直接編集する。
- `.claude/skills` は `.agents/skills` への symlink。直接編集しない。
- `.cursor/skills` は生成物であり、git 管理しない。
