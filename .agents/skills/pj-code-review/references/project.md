# プロジェクト

この repo の責務境界・運用・ handbook との整合を確認する。

## システム構成

- Frontend: Next.js / TypeScript（`volumes/frontend/`）
- Backend BFF: Rails（`volumes/backend/app/controllers/` ほか）
- Batch: Sidekiq + Playwright（`volumes/backend/app/sidekiq/`）
- Data Store: MySQL / Redis
- 認証: OpenID Connect（実装中）

## 責務境界

- [ ] Frontend / BFF / Batch の境界を崩していない
- [ ] frontend が backend の内部実装に直接依存していない（`lib/api` / `lib/actions` 経由）
- [ ] BFF controller に業務手順の直書きが増えていない（service / finder / serializer へ寄せる）
- [ ] Sidekiq job が薄く、本体処理は service に委譲されている
- [ ] 変更が対象レイヤーに閉じている（他レイヤーの無関係変更が混ざっていない）

根拠 handbook:

- [docs/frontend/overview.md](../../../../docs/frontend/overview.md)
- [docs/backend/overview.md](../../../../docs/backend/overview.md)

## 実装慣習

- [ ] 新規コードが類似実装 1〜2 件のパターン（構造・命名・エラー処理・テスト配置）に揃っている
- [ ] 変更は必要最小限（過剰な抽象化・設定・階層化がない）
- [ ] Docker Compose 前提の開発手順を壊していない（ホストで `npm i` する変更を増やしていない）

## ドキュメント

- [ ] 責務境界・置き場所・運用手順に影響があるのに handbook を更新していない
- [ ] DB スキーマや関連の説明が必要なのに `docs/database/` を放置していない
- [ ] `README.md` / `justfile` / `Makefile` と手順の記述が矛盾していない

## 運用・監視

- [ ] Datadog / BugSnag への影響（新規エラー、ログ量、メトリクス）を考慮している
- [ ] バッチ・クロール変更で retry / timeout / queue 設定が妥当

## 検証

- [ ] 変更範囲に応じたテストまたは動作確認手順が示されている
- [ ] Rails 変更なら `just rspec` で実行可能な対象 spec が想定できる
- [ ] frontend 変更なら型・lint・画面確認のどれが必要か判断できる
