# Backend

`volumes/backend/` の変更時に [common.md](common.md) に加えて確認する。

根拠 handbook: [docs/backend/overview.md](../../../../docs/backend/overview.md)

## 置き場所

- [ ] `controllers`: HTTP 入出力、認可、params、response 返却
- [ ] `services`: 複数 model にまたがる作成更新、業務手順、クロール / 同期 orchestration
- [ ] `models`: Active Record の永続化責務
- [ ] `app/sidekiq`: 非同期入口（queue、引数、timeout、retry）。本体は service へ
- [ ] `serializers`: response shape（検索条件・更新条件を持たない）
- [ ] `finders`: 取得条件の組み立て（更新系 service の代わりにしない）

## 避けるパターン

- [ ] controller への複雑な永続化ロジック
- [ ] sidekiq job へのクロール本体・更新本体の直書き
- [ ] serializer への検索条件・更新条件
- [ ] finder を更新系の代わりに使用
- [ ] response shape の都合で model に presentation 寄り責務

## API / BFF

- [ ] `Api::V1::*Controller` の責務が HTTP 境界に閉じている
- [ ] 一覧取得は finder、レスポンス組み立ては serializer に分かれている
- [ ] 破壊的 API 変更（フィールド削除・型変更）に migration や frontend 追随の言及がある

## 認証

- [ ] OIDC / session / 認可が controller / concern に閉じている
- [ ] service 層に認可ロジックが散らばっていない
- [ ] 未認証・権限不足時のレスポンスが一貫している

## Batch / クロール

- [ ] プラットフォーム固有ロジックが `services/crawl/*` 等の既存パターンに沿っている
- [ ] Playwright / 外部 API 呼び出しの timeout・retry が妥当
- [ ] job の idempotency（再実行で二重更新しない）を考慮している

## DB

- [ ] migration がロールバック可能で、既存データへの影響が説明できる
- [ ] N+1 回避（`includes` / `preload` / 適切な finder）がされている
- [ ] インデックス・ユニーク制約がクエリパターンと整合している
- [ ] スキーマ変更時に `docs/database/` 更新が必要か判断している

## テスト（RSpec）

- [ ] spec の配置・命名が既存に揃っている（`spec/models/` `spec/services/` 等）
- [ ] 外部 I/O は stub / VCR 等で既存パターンに沿って隔離されている
- [ ] job spec で perform 後の副作用が検証されている
