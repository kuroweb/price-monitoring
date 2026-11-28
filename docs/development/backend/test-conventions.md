# Backend のテスト方針

BFF / batch の RSpec を書く開発者向けに、テストの書き方を定める。実行方法は [テスト](../testing.md) を参照する。

- RSpec の `describe`・`context`・`it`・`shared_examples` の説明文は日本語で書く。クラス・モジュール・メソッドを指す `describe` はそのまま使う。
- `it` は振る舞いを「〜こと」で終え、`context` は「〜とき」「〜場合」で条件を表す。コード上の識別子や HTTP ステータスはそのまま使ってよい。
