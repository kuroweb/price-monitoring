# 文書ガイド

文書を読む開発者・運用担当者と、文書を更新する人・AI エージェント向けに、配置・役割・正本を定める。

## 読み手と書く内容

| 配置 | 読み手 | 書く内容 | 別の文書に置く内容 |
| --- | --- | --- | --- |
| ルートの `README.md` | 初めてリポジトリを見る人、開発参加者 | 目的、技術スタック、全体構成、開発・設計・運用文書への入口 | 詳細な操作手順、AI 固有の制約 |
| ルートの `AGENTS.md` | AI エージェント | 必ず守る実行制約、言語ツールの実行先、作業・検証の判断基準、エージェント設定の正本 | 初回セットアップ全文、コマンド一覧、詳細な設計解説 |
| `docs/` | 対象領域を開発・運用する人と、その作業を行う AI | 領域別の設計解説、目的別の操作手順、参照資料。`index.md` を文書の入口とし、このファイルは索引と文書規約 | README の目的・全体構成の再掲、AI 固有の制約の複製 |
| `aidlc/` | AI-DLC で機能を検討・実装する開発者と AI | AI-DLC のルール（`spaces/default/memory/`）、チーム知識（`spaces/default/knowledge/`）、作業（intent）ごとの要件・設計・判断の記録（`spaces/default/intents/`） | 実装後に定着した操作手順・テーブル定義の正本（各領域の文書に置き、AI-DLC の記録からリンクする） |
| `volumes/*/README.md` | アプリのディレクトリから読み始める人・AI | そのアプリの識別と、ルート README・担当領域の正本文書へのリンク | 起動・テスト・デプロイ手順の複製、フレームワーク生成時の一般的な案内 |

## 領域別の入口

- [開発](development/index.md)
  - [Backend](development/backend/index.md)
  - [Frontend](development/frontend/index.md)
  - [認証](development/auth-provider/index.md)
  - [Database](development/database/index.md)
  - [CI/CD と自動レビュー](development/cicd/index.md)
- [機能](features/index.md)

## 話題ごとの正本と索引

| 話題 | 正本文書 | 種類 |
| --- | --- | --- |
| 目的・技術スタック・全体構成 | [ルート README](../README.md) | 入口・解説 |
| 商品モニタリングの用語 | [GLOSSARY.md](../GLOSSARY.md) | 用語集 |
| AI の実行制約と作業判断 | [AGENTS.md](../AGENTS.md) | エージェント向け規約 |
| 文書の配置・役割・更新規約・記述規約 | このファイル | 文書規約・索引 |
| 開発文書の入口、ローカル開発環境の構成・用語・接続先 | [開発](development/index.md) | 入口・解説 |
| 共通セットアップ、コミット前のシークレット検査、証明書・hosts、イメージ、DB の準備 | [初回セットアップ](development/setup.md) | ハウツー |
| 開発環境の操作・本番調査の手順一覧 | [日常操作](development/operations/index.md) | 入口 |
| 起動・停止・ローカルログの確認 | [ローカル環境の起動と状態確認](development/operations/local-environment.md) | ハウツー |
| アプリの依存関係の更新・調査 | [依存関係の更新・調査](development/operations/dependencies.md) | ハウツー |
| 本番ログの読み取り調査 | [本番ログの調査](development/operations/production-logs.md) | ハウツー |
| Claude Code・Codex・Cursor のログ調査用 MCP 導入 | [本番ログ調査用 MCP のセットアップ](development/operations/mcp-setup.md) | ハウツー |
| RSpec・静的検証・frontend のテスト | [テスト](development/testing.md) | ハウツー |
| Orca の worktree の setup・初期化・ポート | [Orca の worktree](development/worktree.md) | ハウツー |
| 開発ホストの環境を別の Mac から使う | [別の Mac から開発する](development/remote.md) | ハウツー |
| AI-DLC の起動・再開・知識の登録・更新 | [AI-DLC](development/ai-dlc.md) | ハウツー |
| BFF / batch の責務分離 | [Backend](development/backend/index.md) | 解説 |
| 商品モニタリングの概要 | [商品モニタリング](features/product-monitoring/index.md) | 入口 |
| 商品モニタリングの外部仕様 | [商品モニタリングの外部仕様](features/product-monitoring/external-spec.md) | 解説 |
| 商品モニタリングの API | [商品モニタリングの API](features/product-monitoring/api.md) | リファレンス |
| 商品モニタリングの内部仕様 | [商品モニタリングの内部仕様](features/product-monitoring/internal-spec.md) | 解説 |
| 商品モニタリングのオペレーション | [商品モニタリングのオペレーション](features/product-monitoring/operations.md) | ハウツー |
| 商品モニタリングの DB | [商品モニタリングの DB](features/product-monitoring/database.md) | 解説 |
| Rails 更新 | [Rails バージョンアップ](development/backend/operations/rails-upgrade.md) | ハウツー |
| BFF の seed 投入 | [Seed データの投入](development/backend/operations/seeds.md) | ハウツー |
| frontend の責務分離 | [Frontend](development/frontend/index.md) | 解説 |
| レイヤーに共通するコードの書き方（コメントなど） | [コーディング規約](development/coding-conventions.md) | リファレンス |
| Provider / Client の配置・境界 | [認証基盤](development/auth-provider/index.md) | 解説 |
| 認証固有の初回準備・クライアント登録 | [認証の初回セットアップ](development/auth-provider/setup.md) | ハウツー |
| 認証固有のテスト準備・動作確認 | [認証の検証](development/auth-provider/verification.md) | ハウツー |
| CI/CD、PR 自動レビュー、全イメージの手動デプロイ | [CI/CD と自動レビュー](development/cicd/index.md) | リファレンス |
| BFF / batch のデータ領域の分け方 | [Database](development/database/index.md) | 解説 |
| BFF / batch のカラム・インデックス | [ER](development/database/er.md) | リファレンス |
| 機能文書がまだ無い領域のテーブル間関連 | [アソシエーション](development/database/association.md) | リファレンス |

## 機能文書の設計

機能文書は、その機能を開発・運用する人が、目的、振る舞い、画面からデータの取得・保存・利用までの流れ、変更時の影響を理解するために書く。区分は外部仕様、内部仕様、API、オペレーション、DB の5つである。外部仕様は画面と通知から見える振る舞いである。内部仕様は保存、抽出、取得、ジョブの実装である。API は外部仕様ではなく、内部仕様のファイルにも混ぜない。エンドポイントごとに表と JSON 例を持つ契約として独立させる。オペレーションは手順だけを書き、仕様の本文は複製しない。DB は、その機能のテーブル定義とテーブル間の関連である。商品モニタリングのカラムとインデックスは、その DB 文書を正本とし、ER には節ごとの参照だけを残す。機能文書がまだ無い領域のカラムとインデックスは ER を正本とする。機能文書がある領域のテーブル間関連は、その機能の DB 文書を正本にする。機能の DB 文書は「アソシエーション」と「スキーマ」の二見出しをこの順で置き、表の形は [商品モニタリングの DB](features/product-monitoring/database.md) を見本にする。アソシエーションは、機能文書がまだ無い領域の関連だけを置く。短い機能は一つの index にこの順でまとめてよい。商品モニタリングは入口に加え、外部仕様、内部仕様、API、オペレーション、DB である。領域をまたぐ仕様と設計判断を正本とし、機能一覧の入口を `docs/features/index.md` に置く。すべての機能に文書や同じ章立てを先回りして作る必要はない。

| 知りたいこと | 正本と境界 |
| --- | --- |
| 機能の目的・仕様・制約、処理やデータの意味 | 機能文書。横断的な流れや、データの生成・参照・更新・削除に必要な関係を書く |
| 商品モニタリングの用語 | [GLOSSARY.md](../GLOSSARY.md) |
| 機能の操作手順 | 機能文書内、または同じ機能配下の目的別文書。仕様を複製せず、操作に必要な注意と仕様へのリンクを書く |
| Backend / Frontend の実装上の責務と共通規約 | 各レイヤーの文書。レイヤーに共通する書き方は [コーディング規約](development/coding-conventions.md)。機能固有の振る舞いは機能文書へリンクする |
| DB のカラム・インデックス・テーブル間の関連 | 商品モニタリングのカラム・インデックス・テーブル間関連は [商品モニタリングの DB](features/product-monitoring/database.md) が正本。それ以外のカラムとインデックスは [ER](development/database/er.md) が正本。機能文書がまだ無い領域の関連は [アソシエーション](development/database/association.md) に置く |
| 個別の作業時点の要件・判断・検証記録 | AI-DLC の intent。実装後の現行仕様や手順は `docs/` に置く |

コードとスキーマは実際の動作・定義の一次情報とし、現行文書と食い違う場合は実装を確認して関係する文書を更新する。図や説明中の概念上の関連は、外部キーなどの物理的な関連と区別する。

機能ディレクトリ名は機能を表す英語の kebab-case とし、`docs/features/<機能名>/index.md` に概要と子文書への入口を置く。仕様、API、取得方式、操作手順などは、独立して読む・更新する必要が生じた単位で分ける。分割後も概要から辿れるようにし、短い機能文書には不要なファイルを作らない。

### 図の使い分け

- 複数の処理やデータのつながりが文章だけでは追いにくいときは、流れの概要図や関係図を置く。機能に必要なデータ関係だけを示し、全スキーマの複製にしない。
- 順序、非同期の境界、外部連携、失敗時の分岐が理解に必要な処理にはシーケンス図を使う。全メソッド呼び出しや単純な処理まで図にする必要はない。
- 図は説明対象と範囲を明示し、文章による代替説明を添える。詳細な条件・制約は仕様本文を正本とし、図と本文が矛盾しないよう変更時に両方を確認する。Mermaid を使う場合は構文を検証する。

## 更新規約

- 一つの話題の詳細は一か所に書く。他の文書は正本の見出しへリンクする。入口の短い紹介やコマンド名の参照は許容し、同じ手順の全文は複製しない。
- 手順には前提、作業ディレクトリ、実行場所を書く。シェル例は原則リポジトリルートのホストから実行し、アプリのコマンドは Compose service を明示した Docker Compose / just 経由にする。コンテナ内コンソールの例は、そのコンテナと開始方法を書く。
- `just` の実体は [justfile](../justfile)、Compose service とマウントは [docker-compose.yml](../docker-compose.yml)、デプロイ用ビルドは [Makefile](../Makefile)、CI/CD の条件は [workflow](../.github/workflows/) を一次情報として確認する。文書では読み手に必要な使い方や理由を説明する。
- `docs/` 配下は各ディレクトリに `index.md` を置き、その領域の概要と、子文書・子ディレクトリの入口への案内を書く。領域の概要を別ファイルに分けた索引だけのページは作らない。
- 個別の操作手順や参照資料は、目的が分かる名前のファイルに置く。新規・改名した文書は親ディレクトリの `index.md` から辿れるようにし、関連文書とこの索引の参照も更新する。
- リンクは配置元からの相対パスで書く。変更後はリンク先・見出しの重複・コマンドの実行先を確認する。
- 操作手順の文書は、読み手が別の機会に単独で開く単位（初回準備・日常操作・テストなど）が増えて目的の手順を探しにくくなったら、その単位ごとのファイルに分ける。分けるかどうかは読みやすさで判断し、見出しの数だけでは決めない。手順を分けた領域の `index.md` は概要・用語・案内にする。設計解説を担う領域の `index.md` はこの限りではない。
- 見出しを変えたり手順を別ファイルへ移したりしたら、リポジトリ全体で旧リンク（`ファイル名#見出し`）を検索して参照元を直す。

## 記述規約

- 各文書の冒頭に、読み手と目的を一文で書く。手順の文書では、実行場所（ホストのリポジトリルート、別の Mac など）も書く。
- 文体は常体で、手順は「〜する」で書く。誤操作やデータ削除につながる注意と、複数の方法から一つを選んでいる手順には理由を添える（「〜なので、〜する」）。
- 見出しに番号を付けない。番号はアンカーに入るので、手順を足すと参照元のリンクが壊れる。順序は見出しの並びと本文で示す。
- コードブロックには内容に合う言語を指定する。シェルのコマンドは `bash`、言語の無い設定行（hosts など）は `text` にする。置き換える値は `<user>` のように山括弧で書き、個人のホスト名・IP・ユーザー名は書かない。
- 外部ツールの画面の項目名は、実際の表示どおりに「」で書き、確認したツールのバージョンを添える。公式文書の要約や英語表記から推測しない。
- 用語は各領域の正本に合わせる。商品モニタリングは [GLOSSARY.md](../GLOSSARY.md) を参照する。ローカル開発ではホスト・メイン・worktree・開発ホストを使い分ける。
- リンク文言はリンク先の内容を表す。入口の文書へのリンクに、そこから先の手順の名前を付けない。
- 表は項目ごとの対応や比較に、箇条書きは列挙に、番号付きリストは順に行う手順に使う。
- 太字は、データ削除など取り返しのつかない操作や誤りやすい操作の注意と、番号付き手順の各段の見出し語（「**前提**:」など）に使う。
