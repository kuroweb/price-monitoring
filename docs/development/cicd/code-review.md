# PR の自動レビュー

開発・運用担当者向けに、Claude Code による PR の自動レビューの起動条件と準備を解説する。

[claude-code-review.yml](../../../.github/workflows/claude-code-review.yml) で Claude Code による PR レビューを実行する。

| 起動 | 条件 | 対象 |
| --- | --- | --- |
| 自動（1 回） | PR の作成、再オープン、Draft 解除。push（`synchronize`）では動かない。Draft 中は実行しない | 実行者が `kuroweb` または `dependabot[bot]` |
| 手動（再レビュー） | PR のコメントを `@claude review` で始める。PR の最新 head を checkout してレビューする | 実行者が `kuroweb` |

- 修正を push した後の確認は、手動の再レビューで行う。
- `@claude review` で始まるコメントは [claude.yml](../../../.github/workflows/claude.yml) の汎用応答から除外し、レビューだけが動く。それ以外の `@claude` メンションは claude.yml が応答する。
- Claude Action の `allowed_bots` でも `dependabot[bot]` を明示的に許可する。
- `kuroweb/ai-manifest` の `gh-pr-review-ci` と `code-reviewing` スキルを runner にインストールし、Sonnet が PR の説明と差分をレビューする。
- レビュー結果は `claude[bot]` が PR のコメントに投稿する。同じ PR で次のレビューが始まった場合、実行中のレビューをキャンセルする。
- `issue_comment` の workflow はデフォルトブランチの定義で動く。手動の再レビューの変更は master へのマージ後に反映される。

事前にリポジトリへ [Claude GitHub App](https://github.com/apps/claude) をインストールする。Action は `github_token` を渡さず、この App のインストールトークンで投稿する。ジョブの `id-token: write` はそのトークン取得に使う。Settings → Secrets and variables → Actions に `CLAUDE_CODE_OAUTH_TOKEN` を登録する。Dependabot が起動した workflow では Actions secrets を参照できないため、Settings → Secrets and variables → Dependabot にも同名のトークンを登録する。
