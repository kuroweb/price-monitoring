# ビルド手順

- `just ps` で backend、MySQL、Redis の状態を確認する。必要ならプロジェクトの初回セットアップに従い `just up` でイメージとサービスを準備する。
- Ruby の依存関係は backend イメージ内で管理する。`docker compose exec backend bundle check` で依存関係を検証する。今回の Ruby ソース変更に別のコンパイル手順はない。
- ポート競合時は `docs/development/worktree.md` に従い競合元を確認する。テスト用 DB がない場合はコンテナ内で test 環境の DB を準備する。
