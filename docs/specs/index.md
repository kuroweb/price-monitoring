# 仕様

機能ごとの要件・設計を、実装前の検討から実装中の判断まで置く。機能を検討・実装する開発者と、その作業を行う AI が読む。

各機能は `specs/<機能名>/` にまとめ、`index.md` を入口にする。機能名は frontend の `features/<機能名>/` と同じにする。操作手順やテーブル定義など、実装後に定着した内容の正本は各領域の文書（[Backend](../backend/index.md)・[Frontend](../frontend/index.md)・[Database](../database/index.md)）に置き、仕様からはリンクする。

## 機能

- [商品計測と相場集計](product-monitoring/index.md) — 商品計測設定・商品計測結果・商品相場設定・商品日次相場のテーブル設計と画面設計
