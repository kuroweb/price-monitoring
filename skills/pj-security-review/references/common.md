# 共通（セキュリティ）

すべてのセキュリティレビューで確認する。プロジェクト固有の文脈は [project.md](project.md) を優先する。

## 入力と出力

- [ ] 外部入力（HTTP params、body、headers、cookies、search params、ファイル、環境変数）の入口を特定している
- [ ] 入力に対する検証・正規化・許可リストがある（blacklist だけに依存していない）
- [ ] 出力エンコーディングが文脈に適切（HTML、JSON、ログ、エラーメッセージ）
- [ ] ユーザー入力を SQL / シェル / テンプレート / `eval` / 動的コード実行に渡していない

## インジェクション

- [ ] SQL インジェクション（生 SQL、文字列連結、`where("... #{param}")`）の余地がない
- [ ] コマンドインジェクション（`system`、`Open3`、シェル経由）の余地がない
- [ ] SSRF（内部 URL・メタデータ endpoint への任意 fetch）の余地がない
- [ ] パス traversal（ファイル read/write、import path）の余地がない

## 認証・認可

- [ ] 保護すべき操作に認証が必要
- [ ] 認可がリソース単位・操作単位で一貫している（IDOR、水平/垂直 privilege escalation）
- [ ] 認可チェックが controller / middleware 等の境界にあり、クライアント側だけに依存していない
- [ ] 未認証・権限不足時に情報が漏れない（404/403 の使い分け、エラー詳細）

## 秘密情報

- [ ] API key、パスワード、トークン、client secret のハードコードがない
- [ ] `.env`、設定ファイル、テスト fixture、ログ、エラーレスポンス、フロント bundle に秘密情報が載らない
- [ ] ログ・BugSnag・Datadog に PII / トークン / session 内容を出していない
- [ ] git 履歴に秘密情報を追加していない（差分に `.env` 実体が含まれていない）

## セッション・トークン

- [ ] session cookie に `HttpOnly` / `Secure` / `SameSite` が適切
- [ ] access / refresh token の保存場所が安全（localStorage への平文保存、URL クエリへの載せ方）
- [ ] ログアウト・失効・refresh 失敗時に session / token が適切に破棄される
- [ ] CSRF 対策が state-changing 操作に効いている（必要な箇所で token 検証または SameSite 等）

## 依存関係・設定

- [ ] 新規 npm gem 追加に既知の脆弱性リスクがない（必要ならバージョン固定・監査）
- [ ] 本番向けに debug / verbose error / SSL verify skip が有効になっていない
- [ ] CORS が必要最小限（`*` + credentials 等の危険な組み合わせがない）

## エラー・情報漏洩

- [ ] 本番レスポンスに stack trace、内部 path、DB エラー詳細が出ない
- [ ] 404/403/401 で存在有無・権限有無が過剰に推測できる設計になっていない（要件次第で許容）
