# Business Overview
 
2026-11-15 の重点再調査で確認した範囲は reverse-engineering-timestamp.md を参照。それ以外の記述は以前の調査記録であり、今回の深い検証対象外。

Web 上の商品の最安値と相場を、自宅のホームラボで調べる。画面は Next.js、API と取得バッチは Rails、ログインは別 Rails の OIDC Provider である。

## 利用者が行うこと

- 商品モニタリングの収集設定に検索語とサイト、または追加の検索結果 URL を登録し、取得結果を見る
- 商品モニタリング設定の条件で、販売中の安い出品と日次の相場を見る
- Backmarket の監視対象を登録する

商品モニタリングの画面は `/product-monitoring`、Backmarket は `/backmarket`。収集はサイトごとに 10 分または 15 分ごと、日次相場は毎日 0 時、通知評価は毎分、Sidekiq が動かす（`volumes/backend/config/schedule.yml`）。

## 販売状態

`sold` は true・false・nil の三値。販売中のモニタリングは false のみ、相場集計は除外されず `bought_date` が期間にある行を対象にする。じゃんぱらは一覧の売り切れ表示を解析する。イオシスとじゃんぱらはそのサイトの取得元が全て成功し打ち切りがないとき、3時間以上前の消失行を売り切れにする。価格なし出品も存在判定に含む。メルカリと Yahoo!フリマは個別ページで確認する。詳細は `docs/features/product-monitoring/index.md`。
