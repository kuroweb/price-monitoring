Please also reference the following rules as needed. The list below is provided in TOON format, and `@` stands for the project root directory.

rules[2]:
  - path: @.codex/memories/dev-workflow.md
    description: price-monitoring の開発ワークフロー
    applyTo[1]: **/*
  - path: @.codex/memories/project-overview.md
    description: price-monitoring のプロジェクト概要
    applyTo[1]: **/*

# 基本ルール

## エージェント設定

- Rules は `.rulesync/rules/` を正本とし、rulesync で管理する（`rulesync generate` で `.cursor/rules/`、`AGENTS.md`、`CLAUDE.md` などへ展開）。生成物は直接編集しない。
- Skills は `.agents/skills/` で統一管理する。各エージェントツールはここを参照する。
- スキル名は `pj-` プレフィックスを付ける（個人スキル・プラグインスキルとの衝突回避）。
- Rules を変更するときは `.rulesync/rules/` を修正してから `rulesync generate` を実行する。
- 正本と生成物が矛盾する場合、Rules は `.rulesync/`、Skills は `.agents/skills/` を正とする。
