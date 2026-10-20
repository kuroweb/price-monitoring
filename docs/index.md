# 文書ガイド

文書を読む開発者・運用担当者と、文書を更新する人・AI エージェント向けに、配置・役割・正本を定める。

## 読み手と書く内容

| 配置 | 読み手 | 書く内容 | 別の文書に置く内容 |
| --- | --- | --- | --- |
| ルートの `README.md` | 初めてリポジトリを見る人、開発参加者 | 目的、技術スタック、全体構成、開発・設計・運用文書への入口 | 詳細な操作手順、AI 固有の制約 |
| ルートの `AGENTS.md` | AI エージェント | 必ず守る実行制約、言語ツールの実行先、作業・検証の判断基準、エージェント設定の正本 | 初回セットアップ全文、コマンド一覧、詳細な設計解説 |
| `docs/` | 対象領域を開発・運用する人と、その作業を行う AI | 領域別の設計解説、目的別の操作手順、参照資料。`index.md` を文書の入口とし、このファイルは索引と文書規約 | README の目的・全体構成の再掲、AI 固有の制約の複製 |
| `volumes/*/README.md` | アプリのディレクトリから読み始める人・AI | そのアプリの識別と、ルート README・担当領域の正本文書へのリンク | 起動・テスト・デプロイ手順の複製、フレームワーク生成時の一般的な案内 |

## 領域別の入口

- [ローカル開発](development/index.md)
- [Backend](backend/index.md)
- [Frontend](frontend/index.md)
- [認証](auth-provider/index.md)
- [Database](database/index.md)
- [CI/CD と自動レビュー](cicd/index.md)

## 話題ごとの正本と索引

| 話題 | 正本文書 | 種類 |
| --- | --- | --- |
| 目的・技術スタック・全体構成 | [ルート README](../README.md) | 入口・解説 |
| AI の実行制約と作業判断 | [AGENTS.md](../AGENTS.md) | エージェント向け規約 |
| 文書の配置・役割・参考事例 | このファイル | 文書規約・索引 |
| 共通セットアップ、証明書・hosts、起動・停止、依存関係更新、テスト | [ローカル開発](development/index.md) | ハウツー |
| BFF / batch の責務分離 | [Backend](backend/index.md) | 解説 |
| Rails 更新 | [Rails バージョンアップ](backend/operations/rails-upgrade.md) | ハウツー |
| BFF の seed 投入 | [Seed データの投入](backend/operations/seeds.md) | ハウツー |
| frontend の責務分離 | [Frontend](frontend/index.md) | 解説 |
| Provider / Client の配置・境界 | [認証基盤](auth-provider/index.md) | 解説 |
| 認証固有の初回準備・クライアント登録 | [認証の初回セットアップ](auth-provider/setup.md) | ハウツー |
| 旧 auth-provider 環境からの引き継ぎ | [既存環境の引き継ぎ](auth-provider/migration.md) | ハウツー |
| 認証固有のテスト準備・動作確認 | [認証の検証](auth-provider/verification.md) | ハウツー |
| CI/CD、PR 自動レビュー、全イメージの手動デプロイ | [CI/CD と自動レビュー](cicd/index.md) | リファレンス |
| BFF / batch のデータ領域の分け方 | [Database](database/index.md) | 解説 |
| BFF / batch のカラム・インデックス | [ER](database/er.md) | リファレンス |
| BFF / batch のテーブル間関連 | [アソシエーション](database/association.md) | リファレンス |

## 更新規約

- 一つの話題の詳細は一か所に書く。他の文書は正本の見出しへリンクする。入口の短い紹介やコマンド名の参照は許容し、同じ手順の全文は複製しない。
- 手順には前提、作業ディレクトリ、実行場所を書く。シェル例は原則リポジトリルートのホストから実行し、アプリのコマンドは Compose service を明示した Docker Compose / just 経由にする。コンテナ内コンソールの例は、そのコンテナと開始方法を書く。
- `just` の実体は [justfile](../justfile)、Compose service とマウントは [docker-compose.yml](../docker-compose.yml)、デプロイ用ビルドは [Makefile](../Makefile)、CI/CD の条件は [workflow](../.github/workflows/) を一次情報として確認する。文書では読み手に必要な使い方や理由を説明する。
- `docs/` 配下は各ディレクトリに `index.md` を置き、その領域の概要と、子文書・子ディレクトリの入口への案内を書く。領域の概要を別ファイルに分けた索引だけのページは作らない。
- 個別の操作手順や参照資料は、目的が分かる名前のファイルに置く。新規・改名した文書は親ディレクトリの `index.md` から辿れるようにし、関連文書とこの索引の参照も更新する。
- リンクは配置元からの相対パスで書く。変更後はリンク先・見出しの重複・コマンドの実行先を確認する。

## 参考事例と採用判断

Issue [#78](https://github.com/kuroweb/price-monitoring/issues/78) の整理にあたり、以下の一次資料を確認した。

| 外部事例 | 採用する考え方と理由 | 今回採用しないことと理由 |
| --- | --- | --- |
| [AGENTS.md](https://github.com/agentsmd/agents.md) | AI 向けの予測可能な入口として `AGENTS.md` に実行制約と検証の入口を置く。人向けの手順と AI が必ず守る規約を区別できる | サブディレクトリ別の `AGENTS.md` は増やさない。現状の制約はルートの実行先表と領域文書へのリンクで表現できる |
| [Claude Code memory](https://docs.anthropic.com/en/docs/claude-code/memory) | 継続的に必要な短い指示を入口に残し、詳細は必要時に参照する。`@` によるインポートを利用して `CLAUDE.md` から正本を読む | Claude 専用の規約複製や階層別の指示ファイルは作らない。他のエージェントとの食い違いを避ける。詳細文書の全文インポートも、常時読み込む量が増えるため行わない |
| [Diátaxis（Canonical の採用事例）](https://ubuntu.com/blog/diataxis-a-new-foundation-for-canonical-documentation) | チュートリアル・ハウツー・リファレンス・解説を読み手の目的で区別する。手順、事実の一覧、設計理由が混ざった箇所を分ける | 4 種類に合わせたディレクトリの全面再編や空のチュートリアルは作らない。既存リンクを保ち、現在必要なハウツー・解説・参照資料から整理する |
| [GitLab の文書構成規約](https://docs.gitlab.com/development/documentation/site_architecture/folder_structure/) | 各ディレクトリの入口に領域の紹介と子文書・子ディレクトリへのリンクを置き、親から辿れる階層にする。入口と概要の不要な分割を避け、正本へのリンクで重複を防ぐ | GitLab の入口名 `_index.md` は使わず、このリポジトリで合意した `index.md` を使う。利用者・管理者・開発者の大分類も、現状の文書は開発・運用担当者向けのため、そのまま導入しない |
