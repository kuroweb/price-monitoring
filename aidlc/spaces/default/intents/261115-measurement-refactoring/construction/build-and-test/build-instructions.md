# ビルドと環境

開発環境の準備は `docs/development/setup.md`、テストは `docs/development/testing.md` に従う。ホストのリポジトリルートから `just ps` で状態を確認し、必要なら `just up` を実行する。依存関係の準備は Compose コンテナ内で行う。Ruby の対象変更には個別のコンパイル工程はない。

今回 `just up` はイメージをビルドし backend と DB を起動したが、nginx は 8443 ポートの競合で起動しなかった。worktree のポート競合手順は `docs/development/worktree.md` を参照する。backend テストには影響しなかった。
