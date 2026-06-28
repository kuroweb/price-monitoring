---
root: true
targets: ["*"]
description: "price-monitoring の基本ルール"
globs: ["**/*"]
---

# 基本ルール

## エージェント設定

- Rules は `.rulesync/rules/` を正本とし、rulesync で管理する（`rulesync generate` で `.cursor/rules/`、`AGENTS.md`、`CLAUDE.md` などへ展開）。生成物は直接編集しない。
- Skills は `.agents/skills/` で統一管理する。各エージェントツールはここを参照する。
- Rules を変更するときは `.rulesync/rules/` を修正してから `rulesync generate` を実行する。
- 正本と生成物が矛盾する場合、Rules は `.rulesync/`、Skills は `.agents/skills/` を正とする。
