Please also reference the following rules as needed. The list below is provided in TOON format, and `@` stands for the project root directory.

rules[1]{path}:
  @.codex/memories/dev-workflow.md

# Project Overview

## 目的

- Web上の商品の最安値探索と相場把握を支援する。
- Rails / TypeScript の実践的なキャッチアップを兼ねる。
- Datadog / BugSnag を使った運用監視の学習と実運用を行う。

## システム構成

- Frontend: Next.js / TypeScript / Tailwind CSS
- Backend BFF: Rails
- Batch: Sidekiq + Playwright
- Data Store: MySQL / Redis
- 認証: OpenID Connect（実装中）

## エージェント設定

- Rules は `.rulesync/rules/` を正本とし、rulesync で管理する（`rulesync generate` で `.cursor/rules/`、`AGENTS.md`、`CLAUDE.md` などへ展開）。生成物は直接編集しない。
- Skills は `.agents/skills/` で統一管理する。各エージェントツールはここを参照する。
- Rules を変更するときは `.rulesync/rules/` を修正してから `rulesync generate` を実行する。
- 正本と生成物が矛盾する場合、Rules は `.rulesync/`、Skills は `.agents/skills/` を正とする。
