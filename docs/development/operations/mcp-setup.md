# 本番ログ調査用 MCP のセットアップ

Claude Code・Codex・Cursor に公式 `mcp-victorialogs` を導入する開発者向けの初回手順。任意の checkout のリポジトリルートから、ホストの端末でクライアントごとに一度実行する。k8s リポジトリの clone、just、Orca、アプリの起動は不要。

## 公式バイナリのインストール

使う AI クライアントと、ホストの `curl`・`tar`・`shasum`・`install` が必要。GitHub へのインターネット接続ができる端末で、以下を bash または zsh で実行する。macOS・Linux の arm64 / x86_64 を対象とする。

```bash
(
  set -eu
  version=v1.10.0
  case "$(uname -s)_$(uname -m)" in
    Darwin_arm64)
      asset=mcp-victorialogs_Darwin_arm64.tar.gz
      sha256=9f936e77fd972020103a05327e8e876fd7bb7dd7e584ba0757cf0f9bc0dab8df ;;
    Darwin_x86_64)
      asset=mcp-victorialogs_Darwin_x86_64.tar.gz
      sha256=a9dae6ac467b046f1b835a35bf70d47a9e8c0e1db5af8ae619578e10c85ad2ab ;;
    Linux_aarch64|Linux_arm64)
      asset=mcp-victorialogs_Linux_arm64.tar.gz
      sha256=53f719bc7aede25f99dd25fbc25de6ef21b389a90731ce3eb4e85faa35be8cf2 ;;
    Linux_x86_64)
      asset=mcp-victorialogs_Linux_x86_64.tar.gz
      sha256=5f242737901e89c4e85ebc1986b0a5eb5c9ab916425e4b00bf56746a5ed12842 ;;
    *) printf 'Unsupported OS/CPU\n' >&2; exit 1 ;;
  esac
  mcp_tmp=$(mktemp -d)
  trap 'rm -rf "$mcp_tmp"' EXIT
  curl -fsSL "https://github.com/VictoriaMetrics/mcp-victorialogs/releases/download/$version/$asset" -o "$mcp_tmp/$asset"
  (cd "$mcp_tmp" && printf '%s  %s\n' "$sha256" "$asset" | shasum -a 256 -c -)
  tar -xzf "$mcp_tmp/$asset" -C "$mcp_tmp" mcp-victorialogs
  destination="$HOME/.local/share/price-monitoring/mcp-victorialogs/$version"
  install -d "$destination"
  install -m 755 "$mcp_tmp/mcp-victorialogs" "$destination/mcp-victorialogs"
  printf 'Installed: %s\n' "$destination/mcp-victorialogs"
)
```

バージョンと SHA-256 は [公式 v1.10.0 の checksums.txt](https://github.com/VictoriaMetrics/mcp-victorialogs/releases/download/v1.10.0/checksums.txt) に合わせて固定している。チェックサム検証に失敗した場合は配置しない。同じ固定版の再インストールもこのコマンドで行える。

バイナリはユーザー領域の安定したパスに置く。登録に checkout のパスを使わないので、導入元の worktree を削除・移動しても使える。Orca の workspace 作成・起動ごとの事前準備には追加しない。

## 登録先と既存設定の確認

すべてユーザースコープで、他のプロジェクトや Orca 外からの通常起動でも有効になる。

| クライアント | 設定先 |
| --- | --- |
| Claude Code | 通常は `~/.claude.json` の `mcpServers.victorialogs`。`CLAUDE_CONFIG_DIR` を指定している場合はその配下の `.claude.json` |
| Codex | `$CODEX_HOME/config.toml`、未指定なら `~/.codex/config.toml` の `mcp_servers.victorialogs` |
| Cursor | `~/.cursor/mcp.json` の `mcpServers.victorialogs` |

追加前にユーザー設定の同名登録を確認する。以下のコマンド・引数・環境変数と一致する登録があれば、追加をスキップして導入済みとして扱う。異なる場合は目的を確認し、無断で上書き・削除しない。特に `codex mcp add` は既存登録を置き換え得るため、この確認を先に行う。設定全体には認証情報も含まれ得るので、チャットなどに転載しない。

## Claude Code のユーザー登録

未登録の場合に実行する。名前を環境変数オプションの前に置く。

```bash
claude mcp add --scope user --transport stdio victorialogs \
  -e VL_INSTANCE_ENTRYPOINT=https://victoria-logs.kuroweb.net \
  -e MCP_DISABLED_TOOLS=flags \
  -e MCP_SERVER_MODE=stdio \
  -- /usr/bin/env "$HOME/.local/share/price-monitoring/mcp-victorialogs/v1.10.0/mcp-victorialogs"
```

公式 CLI が既存の他の設定を保持してユーザースコープへ登録する。同名登録があると追加を拒否するので、エラーを理由に既存登録を消さず、内容が同じならそのまま使う。

## Codex のユーザー登録

登録の有無は次で確認できる。このコマンドは設定を表示し、MCP サーバーには接続しない。プロジェクト固有の同名設定がある場合は有効な設定が変わるので、ユーザー設定ファイルも確認する。

```bash
codex mcp get victorialogs --json
```

未登録のエラーで、ユーザー設定にも同名登録がない場合だけ追加する。

```bash
codex mcp add victorialogs \
  --env VL_INSTANCE_ENTRYPOINT=https://victoria-logs.kuroweb.net \
  --env MCP_DISABLED_TOOLS=flags \
  --env MCP_SERVER_MODE=stdio \
  -- /usr/bin/env "$HOME/.local/share/price-monitoring/mcp-victorialogs/v1.10.0/mcp-victorialogs"
```

追加後も `codex mcp get victorialogs --json` で確認する。通常の `codex` 起動で読み込まれ、専用の起動ラッパーは不要。リポジトリの AI-DLC 管理ファイルは変更しない。

## Cursor のユーザー登録

`~/.cursor/mcp.json` をエディタで開く。未作成なら以下の JSON を保存し、既存ファイルがある場合は既存の `mcpServers` に `victorialogs` だけを追記する。他のサーバーや設定は残す。同名登録があれば上記の方針で確認する。Cursor に `mcp add` があるとは仮定せず、公式のユーザー設定を使う。

次で表示した絶対パスを、JSON の `<mcp-binary-path>` に入れる。

```bash
printf '%s\n' "$HOME/.local/share/price-monitoring/mcp-victorialogs/v1.10.0/mcp-victorialogs"
```

```json
{
  "mcpServers": {
    "victorialogs": {
      "type": "stdio",
      "command": "/usr/bin/env",
      "args": ["<mcp-binary-path>"],
      "env": {
        "VL_INSTANCE_ENTRYPOINT": "https://victoria-logs.kuroweb.net",
        "MCP_DISABLED_TOOLS": "flags",
        "MCP_SERVER_MODE": "stdio"
      }
    }
  }
}
```

CLI と GUI で同じ設定を使うため、出力した絶対パスを記載する。実行ファイルのパスを `/usr/bin/env` の一つの引数にすることで、空白を含むユーザーパスでも起動できる。

## ローカル確認と次の手順

各ユーザー設定の `victorialogs` について、`command` が `/usr/bin/env`、`args` が上記の安定したバイナリパス一つで、3 つの環境変数が一致することを確認する。JSON の抜き出しには、`jq` がある端末なら次を使える。ない場合はエディタで該当エントリを確認する。

```bash
jq '.mcpServers.victorialogs' "${CLAUDE_CONFIG_DIR:-$HOME}/.claude.json"
jq '.mcpServers.victorialogs' "$HOME/.cursor/mcp.json"
codex mcp get victorialogs --json
```

ここまでの設定確認は本番への接続成功を意味しない。実際の接続、クライアントでの承認・公開ツールの確認、ログの扱いと調査方法は [本番ログの調査](production-logs.md) に従う。

不要になった場合、Claude Code は `claude mcp remove --scope user victorialogs`、Codex は `codex mcp remove victorialogs` を使う。Cursor はユーザーの JSON から `victorialogs` だけを取り除く。バイナリの削除は全クライアントの参照がなくなってから行う。

## 参照と検証範囲

- [公式 mcp-victorialogs v1.10.0](https://github.com/VictoriaMetrics/mcp-victorialogs/tree/v1.10.0): 固定配布物と環境変数。
- [Claude Code MCP](https://code.claude.com/docs/en/mcp): user scope と CLI。
- [Codex MCP](https://developers.openai.com/codex/mcp/): `mcp add` とユーザー設定。
- [Cursor MCP](https://cursor.com/docs/mcp): ユーザーの JSON 設定。
- [k8s のログ収集仕様](https://github.com/kuroweb/k8s/blob/master/docs/logging.md): 接続先・公開範囲の正本。導入手順はこのページで完結する。

2026-11-23 に macOS arm64 の隔離した HOME・ユーザー設定で、配布物の実取得、固定 SHA-256、配置と記載コマンドを確認した。Claude Code 2.1.323、Codex CLI 0.171.0、Cursor Agent 2026.11.19-f005e9d でユーザー登録を確認し、モックサーバーを使うことで本番には接続していない。導入元の checkout 削除後も、通常のクライアントコマンドで読み込めることを確認した。

実バイナリは接続先をループバックに変えた `initialize` / `tools/list` のみで確認し、公開された 12 ツールの `readOnlyHint: true` と `flags` がないことを確認した。検索ツールは呼んでいない。Cursor GUI、Linux・macOS x86_64 の実行、本番への到達性は未確認。
