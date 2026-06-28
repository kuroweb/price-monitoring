# Backend（セキュリティ）

`volumes/backend/` の変更時に [common.md](common.md) に加えて確認する。

根拠 handbook: [docs/backend/overview.md](../../../../docs/backend/overview.md)

## API / BFF

- [ ] `Api::V1::*Controller` の各 action に必要な認証・認可がある（現状未実装の場合は「意図的に公開」と説明できるか）
- [ ] Strong Parameters / 明示的な permit で mass assignment を防いでいる
- [ ] finder / scope にユーザー入力がそのまま SQL フラグメントとして入っていない
- [ ] serializer が内部フィールド（token、内部 ID、運用メモ）を不必要に返していない
- [ ] 破壊的操作（destroy、exclude 追加）が IDOR になっていない

## 認証（OIDC / Session）

- [ ] `ApplicationController` / `SessionsController` / `OidcTokenControl` の変更が session 固定・token 漏洩を招かない
- [ ] `reset_session` がログイン成功時に呼ばれている（session fixation 対策）
- [ ] token refresh 失敗時に session が破棄され、古い token で操作できない
- [ ] `skip_before_action :verify_authenticity_token` の scope が callback のみに限定されている
- [ ] OmniAuth / OIDC の `state` / `nonce` / redirect URI が設定どおり

## Session Store

- [ ] `session_store.rb` の `secure` / `httponly` / `same_site` / `expire_after` が環境に適切
- [ ] Redis session の namespace / URL が他環境と混線しない

## Batch / Sidekiq

- [ ] job にユーザー制御可能な文字列をそのまま Playwright / shell / ファイル path に渡していない
- [ ] job の perform が認可なしで任意リソースを更新しない（enqueue 側の信頼境界）
- [ ] retry / timeout が DoS や外部サイトへの過剰アクセスを招かない
- [ ] Sidekiq Web / Cron UI の認可が本番要件を満たす

## DB / Active Record

- [ ] migration で権限・デフォルト値・NOT NULL がデータ漏洩や不正状態を生まない
- [ ] 生 SQL（`execute`、`find_by_sql`）にバインドパラメータを使っている
- [ ] ユニーク制約・外部キーが整合性攻撃（二重作成、孤児レコード）を防ぐ

## 外部通信

- [ ] Faraday / Net::HTTP の timeout が設定されている
- [ ] 外部 URL は許可リストまたは固定 endpoint（SSRF 対策）
- [ ] レスポンス body をログに全文出していない（token 含む可能性）

## エラー処理

- [ ] `Api::ApplicationController` の rescue が本番で内部情報を返していない
- [ ] `exception.full_message` が client 向け JSON に載らない（ログのみ）

## テスト

- [ ] 認証・認可の regression spec がある（追加・変更時）
- [ ] 未認証 / 他ユーザーリソースへのアクセス拒否を検証している
