# API Documentation

BFF の JSON は `/api/v1`。開発時は Nginx の `location /api` が `backend:3000` へ渡す。Frontend のサーバー側は `NEXT_PRIVATE_API_URL`（Compose では `http://backend:3000`）へ直接出す。

`Api::ApplicationController` は例外を 400 / 404 / 409 / 503 の `{ error: { code, message, details } }` にそろえる。未捕捉は BugSnag へ通知し、HTTP は 503 である。会員ごとの認可フィルタは、この基底にも商品計測コントローラにも無い。レート制限の設定は見当たらない。

成功時の作成・更新の多くは 200 と JSON 本体。削除は 200 と `{}`。取得ジョブの投入だけ 202。

## 商品と従来クロール

| メソッドとパス | 役割 |
| --- | --- |
| `GET/POST /api/v1/products`、`GET/PUT/DELETE /api/v1/products/:id` | 計測対象 |
| `POST/DELETE /api/v1/products/:product_id/{yahoo_auction,mercari,iosys,janpara,pc_koubou,used_sofmap}_crawl_settings/...exclude_products` | 従来クロールの除外出品 |
| `GET/POST /api/v1/categories`、`GET/PUT/DELETE /api/v1/categories/:id` | カテゴリ |
| `GET /api/v1/categories/structured`、`GET /api/v1/categories/:id/structured_subtree` | 木 |
| `GET/POST /api/v1/backmarket_watch_targets`、`PUT/DELETE /api/v1/backmarket_watch_targets/:id` | Backmarket 監視 |
| `GET /api/v1/backmarket_recents` | 直近結果 |
| `GET /api/v1/product_prices`、`GET /api/v1/product_prices/:id` | 価格 |
| `GET /api/v1/current_user` | ログイン中の利用者 |

## 商品計測とモニタリング

| メソッドとパス | 役割 |
| --- | --- |
| `GET/POST /api/v1/product_crawl_settings` | 設定の一覧と登録 |
| `GET/PUT/DELETE /api/v1/product_crawl_settings/:id` | 取得、更新、削除 |
| `POST /api/v1/product_crawl_settings/:id/sync` | `CrawlJob` を手動投入。202 |
| `GET /api/v1/product_crawl_results` | 結果。`product_crawl_setting_id` で設定に絞る。`excluded=true` で除外行だけ |
| `PATCH /api/v1/product_crawl_results/:id` | `excluded` で `excluded_at` を立てる、または消す |
| `DELETE /api/v1/product_crawl_results/:id` | その行だけ削除 |
| `GET/POST /api/v1/product_watch_settings` | モニタリング設定 |
| `PUT/DELETE /api/v1/product_watch_settings/:id` | 更新と削除 |
| `GET /api/v1/product_watch_settings/:id/results` | 条件に合う販売中を最大 8 件 |
| `POST /api/v1/product_watch_settings/:id/calculate` | 直近 30 日を集計 |
| `GET /api/v1/product_watch_settings/:id/purchases` | `start_date` と `end_date` が必須。90 日未満 |
| `GET /api/v1/product_aggregation_results` | 日次相場 |

結果 JSON の `sold` は boolean または null。画面の絞り込みは `sold === true` を売り切れ、それ以外を販売中側に数える（`ProductCrawlResultsDetail.tsx`）。モニタリング API の results はサーバー側で `sold: false` に絞ったあと返す。

入力の共通検証は `ProductMonitoring::Input`。必須語・除外語は各 50 件、各 255 文字、と PoC 文書にある。

## 認証と健康確認

| メソッドとパス | 役割 |
| --- | --- |
| `GET /auth/:provider/callback`、`GET /auth/failure`、`GET /auth/csrf_token`、`DELETE /logout` | BFF の OIDC セッション |
| `GET /up` | Rails の health |
| `GET /sidekiq` | Sidekiq Web。ルートに Basic 認証の TODO がある |
| Provider の Doorkeeper / OpenID Connect、`GET /oauth/logout`、Devise、`GET /up` | 認証アプリ |

OIDC の issuer、client、redirect は Compose の環境変数。値は成果物に書かない。
