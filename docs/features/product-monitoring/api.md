# 商品モニタリングの API

呼び出し側がエンドポイントの項目と JSON を引くための契約である。外部仕様にも、内部仕様の実装解説にも混ぜない。

日時は ISO 8601 の文字列、日付は `YYYY-MM-DD`。レスポンスに `last_lowest_signature` と `newest_notified_until` は含まれない。

## `GET /api/v1/product_monitoring/crawl_settings`

保存済みの収集設定を id の新しい順に返す。

リクエストボディなし。

**200**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| crawl_settings | array | 収集設定 |
| crawl_settings[].id | integer | 収集設定の id |
| crawl_settings[].name | string | 名前。1〜255文字 |
| crawl_settings[].enabled | boolean | 取得を定期実行するか |
| crawl_settings[].search_keyword | string または null | 検索ワード。無いときは null |
| crawl_settings[].platforms | string の配列 | サイト。`mercari`、`yahoo_fleamarket`、`yahoo_auction`、`iosys`、`janpara`、`treasure_factory` |
| crawl_settings[].search_urls | string の配列 | 検索結果URL |
| crawl_settings[].required_keywords | string の配列 | 必須語 |
| crawl_settings[].negative_keywords | string の配列 | 除外語 |
| crawl_settings[].min_price | integer または null | 価格の下限。下限なしは null |
| crawl_settings[].max_price | integer または null | 価格の上限。上限なしは null |
| crawl_settings[].created_at | string | 作成日時。ISO 8601 |
| crawl_settings[].updated_at | string | 更新日時。ISO 8601 |

```json
{
  "crawl_settings": [
    {
      "id": 1,
      "name": "phone",
      "enabled": true,
      "search_keyword": "phone",
      "platforms": [
        "mercari"
      ],
      "search_urls": [
        "https://jp.mercari.com/search?keyword=phone"
      ],
      "required_keywords": [
        "phone"
      ],
      "negative_keywords": [
        "case"
      ],
      "min_price": 1000,
      "max_price": 50000,
      "created_at": "2026-11-20T09:00:00.000+09:00",
      "updated_at": "2026-11-20T09:00:00.000+09:00"
    }
  ]
}
```

## `POST /api/v1/product_monitoring/crawl_settings`

収集設定を検証して保存し、保存した収集設定を返す。

| 場所 | 名前 | 型 | 必須 | 説明 |
| --- | --- | --- | --- | --- |
| body | name | string | 必須 | 名前。1〜255文字 |
| body | enabled | boolean | 任意 | 省略時は false |
| body | search_keyword | string または null | 任意 | 255文字以内。検索ワードとサイトは両方指定するか両方空 |
| body | platforms | string の配列 | 任意 | 省略時は空。`mercari`、`yahoo_fleamarket`、`yahoo_auction`、`iosys`、`janpara`、`treasure_factory` |
| body | search_urls | string の配列 | 任意 | 省略時は空。5件まで、1件2048バイトまで。検索ワードとサイトが空なら1件以上必要 |
| body | required_keywords | string の配列 | 任意 | 省略時は空。各255文字、50件まで |
| body | negative_keywords | string の配列 | 任意 | 省略時は空。各255文字、50件まで |
| body | min_price | integer または null | 任意 | 0以上2147483647以下。省略または null は下限なし |
| body | max_price | integer または null | 任意 | 0以上2147483647以下。省略または null は上限なし。下限以下にはできない |

```json
{
  "name": "phone",
  "enabled": true,
  "search_keyword": "phone",
  "platforms": [
    "mercari"
  ],
  "search_urls": [
    "https://jp.mercari.com/search?keyword=phone"
  ],
  "required_keywords": [
    "phone"
  ],
  "negative_keywords": [
    "case"
  ],
  "min_price": 1000,
  "max_price": 50000
}
```

**200**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| id | integer | 収集設定の id |
| name | string | 名前。1〜255文字 |
| enabled | boolean | 取得を定期実行するか |
| search_keyword | string または null | 検索ワード。無いときは null |
| platforms | string の配列 | サイト。`mercari`、`yahoo_fleamarket`、`yahoo_auction`、`iosys`、`janpara`、`treasure_factory` |
| search_urls | string の配列 | 検索結果URL |
| required_keywords | string の配列 | 必須語 |
| negative_keywords | string の配列 | 除外語 |
| min_price | integer または null | 価格の下限。下限なしは null |
| max_price | integer または null | 価格の上限。上限なしは null |
| created_at | string | 作成日時。ISO 8601 |
| updated_at | string | 更新日時。ISO 8601 |

```json
{
  "id": 1,
  "name": "phone",
  "enabled": true,
  "search_keyword": "phone",
  "platforms": [
    "mercari"
  ],
  "search_urls": [
    "https://jp.mercari.com/search?keyword=phone"
  ],
  "required_keywords": [
    "phone"
  ],
  "negative_keywords": [
    "case"
  ],
  "min_price": 1000,
  "max_price": 50000,
  "created_at": "2026-11-20T09:00:00.000+09:00",
  "updated_at": "2026-11-20T09:00:00.000+09:00"
}
```

**400**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| error.code | integer | 400 |
| error.message | string | 名前が1〜255文字でない、価格が0以上2147483647以下の整数でない、最低価格が最高価格より高い、語句が文字列でないか255文字を超えるか51件以上、有効状態が true でも false でもない、ときの文言。またはサイトの値が取り得る値以外、検索結果URLが5件超・2048バイト超・重複・HTTPSの検索URLでない、ホストまたはパスが非対応、クエリが必要、検索ワードとサイトの片方だけ、検索手段が一つもない、Yahoo!フリマの検索ワードが空または `/` と制御文字を含む、イオシスの `t=g`、じゃんぱらの `KEYWORDS` が空、ときの文言 |
| error.details | array | 空配列 |

```json
{
  "error": {
    "code": 400,
    "message": "名前は1〜255文字で入力してください",
    "details": []
  }
}
```

## `GET /api/v1/product_monitoring/crawl_settings/:id`

id で指定した収集設定を返す。

| 場所 | 名前 | 型 | 必須 | 説明 |
| --- | --- | --- | --- | --- |
| path | id | integer | 必須 | 収集設定の id |

```
/api/v1/product_monitoring/crawl_settings/1
```

リクエストボディなし。

**200**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| id | integer | 収集設定の id |
| name | string | 名前。1〜255文字 |
| enabled | boolean | 取得を定期実行するか |
| search_keyword | string または null | 検索ワード。無いときは null |
| platforms | string の配列 | サイト。`mercari`、`yahoo_fleamarket`、`yahoo_auction`、`iosys`、`janpara`、`treasure_factory` |
| search_urls | string の配列 | 検索結果URL |
| required_keywords | string の配列 | 必須語 |
| negative_keywords | string の配列 | 除外語 |
| min_price | integer または null | 価格の下限。下限なしは null |
| max_price | integer または null | 価格の上限。上限なしは null |
| created_at | string | 作成日時。ISO 8601 |
| updated_at | string | 更新日時。ISO 8601 |

```json
{
  "id": 1,
  "name": "phone",
  "enabled": true,
  "search_keyword": "phone",
  "platforms": [
    "mercari"
  ],
  "search_urls": [
    "https://jp.mercari.com/search?keyword=phone"
  ],
  "required_keywords": [
    "phone"
  ],
  "negative_keywords": [
    "case"
  ],
  "min_price": 1000,
  "max_price": 50000,
  "created_at": "2026-11-20T09:00:00.000+09:00",
  "updated_at": "2026-11-20T09:00:00.000+09:00"
}
```

**404**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| error.code | integer | 404 |
| error.message | string | `Not Found.` |
| error.details | array | 空配列 |

```json
{
  "error": {
    "code": 404,
    "message": "Not Found.",
    "details": []
  }
}
```

## `PUT /api/v1/product_monitoring/crawl_settings/:id`

id で指定した収集設定を検証して保存し、保存後の収集設定を返す。必須語・除外語・価格帯を変えたときは、新しい条件に合わない保存済みの収集結果を削除する。

| 場所 | 名前 | 型 | 必須 | 説明 |
| --- | --- | --- | --- | --- |
| path | id | integer | 必須 | 収集設定の id |
| body | name | string | 必須 | 名前。1〜255文字 |
| body | enabled | boolean | 任意 | 省略時は false |
| body | search_keyword | string または null | 任意 | 255文字以内。検索ワードとサイトは両方指定するか両方空 |
| body | platforms | string の配列 | 任意 | 省略時は空。`mercari`、`yahoo_fleamarket`、`yahoo_auction`、`iosys`、`janpara`、`treasure_factory` |
| body | search_urls | string の配列 | 任意 | 省略時は空。5件まで、1件2048バイトまで。検索ワードとサイトが空なら1件以上必要 |
| body | required_keywords | string の配列 | 任意 | 省略時は空。各255文字、50件まで |
| body | negative_keywords | string の配列 | 任意 | 省略時は空。各255文字、50件まで |
| body | min_price | integer または null | 任意 | 0以上2147483647以下。省略または null は下限なし |
| body | max_price | integer または null | 任意 | 0以上2147483647以下。省略または null は上限なし。下限以下にはできない |

```json
{
  "name": "phone",
  "enabled": true,
  "search_keyword": "phone",
  "platforms": [
    "mercari"
  ],
  "search_urls": [
    "https://jp.mercari.com/search?keyword=phone"
  ],
  "required_keywords": [
    "phone"
  ],
  "negative_keywords": [
    "case"
  ],
  "min_price": 1000,
  "max_price": 50000
}
```

**200**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| id | integer | 収集設定の id |
| name | string | 名前。1〜255文字 |
| enabled | boolean | 取得を定期実行するか |
| search_keyword | string または null | 検索ワード。無いときは null |
| platforms | string の配列 | サイト。`mercari`、`yahoo_fleamarket`、`yahoo_auction`、`iosys`、`janpara`、`treasure_factory` |
| search_urls | string の配列 | 検索結果URL |
| required_keywords | string の配列 | 必須語 |
| negative_keywords | string の配列 | 除外語 |
| min_price | integer または null | 価格の下限。下限なしは null |
| max_price | integer または null | 価格の上限。上限なしは null |
| created_at | string | 作成日時。ISO 8601 |
| updated_at | string | 更新日時。ISO 8601 |

```json
{
  "id": 1,
  "name": "phone",
  "enabled": true,
  "search_keyword": "phone",
  "platforms": [
    "mercari"
  ],
  "search_urls": [
    "https://jp.mercari.com/search?keyword=phone"
  ],
  "required_keywords": [
    "phone"
  ],
  "negative_keywords": [
    "case"
  ],
  "min_price": 1000,
  "max_price": 50000,
  "created_at": "2026-11-20T09:00:00.000+09:00",
  "updated_at": "2026-11-20T09:00:00.000+09:00"
}
```

**400**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| error.code | integer | 400 |
| error.message | string | 名前が1〜255文字でない、価格が0以上2147483647以下の整数でない、最低価格が最高価格より高い、語句が文字列でないか255文字を超えるか51件以上、有効状態が true でも false でもない、ときの文言。またはサイトの値が取り得る値以外、検索結果URLが5件超・2048バイト超・重複・HTTPSの検索URLでない、ホストまたはパスが非対応、クエリが必要、検索ワードとサイトの片方だけ、検索手段が一つもない、Yahoo!フリマの検索ワードが空または `/` と制御文字を含む、イオシスの `t=g`、じゃんぱらの `KEYWORDS` が空、ときの文言 |
| error.details | array | 空配列 |

```json
{
  "error": {
    "code": 400,
    "message": "最低価格は最高価格以下にしてください",
    "details": []
  }
}
```

**404**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| error.code | integer | 404 |
| error.message | string | `Not Found.` |
| error.details | array | 空配列 |

```json
{
  "error": {
    "code": 404,
    "message": "Not Found.",
    "details": []
  }
}
```

## `DELETE /api/v1/product_monitoring/crawl_settings/:id`

id で指定した収集設定を削除する。

| 場所 | 名前 | 型 | 必須 | 説明 |
| --- | --- | --- | --- | --- |
| path | id | integer | 必須 | 収集設定の id |

```
/api/v1/product_monitoring/crawl_settings/1
```

リクエストボディなし。

**200**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| （ボディ） | object | 空オブジェクト |

```json
{}
```

**404**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| error.code | integer | 404 |
| error.message | string | `Not Found.` |
| error.details | array | 空配列 |

```json
{
  "error": {
    "code": 404,
    "message": "Not Found.",
    "details": []
  }
}
```

**400**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| error.code | integer | 400 |
| error.message | string | `Bad Request.`。削除できなかったとき |
| error.details | array | 空配列 |

```json
{
  "error": {
    "code": 400,
    "message": "Bad Request.",
    "details": []
  }
}
```

## `POST /api/v1/product_monitoring/crawl_settings/:id/sync`

保存済みの条件で取得して保存するジョブを受け付ける。取得は応答のあとで、応答の時点で完了しているとは限らない。

| 場所 | 名前 | 型 | 必須 | 説明 |
| --- | --- | --- | --- | --- |
| path | id | integer | 必須 | 収集設定の id |

```
/api/v1/product_monitoring/crawl_settings/1/sync
```

リクエストボディなし。

**202**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| （ボディ） | object | 空オブジェクト |

```json
{}
```

**404**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| error.code | integer | 404 |
| error.message | string | `Not Found.` |
| error.details | array | 空配列 |

```json
{
  "error": {
    "code": 404,
    "message": "Not Found.",
    "details": []
  }
}
```

**400**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| error.code | integer | 400 |
| error.message | string | 保存済みの検索結果URLが検索URLとして不正なときの文言 |
| error.details | array | 空配列 |

```json
{
  "error": {
    "code": 400,
    "message": "URL must be an HTTPS search URL",
    "details": []
  }
}
```

## `GET /api/v1/product_monitoring/crawl_results`

除外されていない収集結果、または除外した収集結果だけを返す。`crawl_setting_id` が無いときは収集設定ごとに id の新しい順で最大8件と、販売状態ごとの件数を返す。あるときはその収集設定の行を id の新しい順にすべて返し、`counts` は含まれない。

| 場所 | 名前 | 型 | 必須 | 説明 |
| --- | --- | --- | --- | --- |
| query | crawl_setting_id | integer | 任意 | 収集設定の id。指定するとその設定の全件 |
| query | excluded | boolean | 任意 | 真のとき除外した行だけ。`true`、`1`、`t`、`on`（大文字小文字を問わない）が真。`false`、`0`、`f`、`off` と省略が偽 |

```
/api/v1/product_monitoring/crawl_results?excluded=false
```

リクエストボディなし。

**200**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| crawl_results | array | 収集結果。`crawl_setting_id` が無いときは収集設定ごとに最大8件 |
| crawl_results[].id | integer | 収集結果の id |
| crawl_results[].crawl_setting_id | integer | 収集設定の id |
| crawl_results[].platform | string | サイト |
| crawl_results[].external_id | string | サイト上の出品ID |
| crawl_results[].name | string | 出品名 |
| crawl_results[].product_url | string | 出品URL |
| crawl_results[].thumbnail_url | string または null | サムネイルURL。無いときは null |
| crawl_results[].price | integer | 価格 |
| crawl_results[].buyout_price | integer または null | 即決価格。無いときは null |
| crawl_results[].sold | boolean または null | 売り切れなら true、販売中なら false、不明なら null |
| crawl_results[].sold_at | string または null | 売れた日。無いときは null |
| crawl_results[].ends_at | string または null | 終了日時。無いときは null |
| crawl_results[].excluded_at | string または null | 除外した日時。除外していなければ null |
| crawl_results[].created_at | string | 作成日時。ISO 8601 |
| crawl_results[].updated_at | string | 更新日時。ISO 8601 |
| crawl_results[].recency_at | string または null | 新着順の時刻。売れた日が無い売り切れは null |
| counts | array | `crawl_setting_id` が無いときだけ。販売状態ごとの件数 |
| counts[].crawl_setting_id | integer | 収集設定の id |
| counts[].sold | boolean または null | その件数の販売状態 |
| counts[].count | integer | 件数 |

```json
{
  "crawl_results": [
    {
      "id": 10,
      "crawl_setting_id": 1,
      "platform": "iosys",
      "external_id": "item-1",
      "name": "phone",
      "product_url": "https://example.com/items/item-1",
      "thumbnail_url": null,
      "price": 1200,
      "buyout_price": null,
      "sold": false,
      "sold_at": null,
      "ends_at": null,
      "excluded_at": null,
      "created_at": "2026-11-20T09:00:00.000+09:00",
      "updated_at": "2026-11-20T09:00:00.000+09:00",
      "recency_at": "2026-11-20T09:00:00.000+09:00"
    }
  ],
  "counts": [
    {
      "crawl_setting_id": 1,
      "sold": false,
      "count": 3
    }
  ]
}
```

## `PATCH /api/v1/product_monitoring/crawl_results/:id`

収集結果の行は残し、除外するか取り消す。

| 場所 | 名前 | 型 | 必須 | 説明 |
| --- | --- | --- | --- | --- |
| path | id | integer | 必須 | 収集結果の id |
| body | excluded | boolean | 必須 | 真で除外、偽で取り消し。`true`、`1`、`t`、`on`（大文字小文字を問わない）が真。`false`、`0`、`f`、`off` と省略が偽 |

```json
{
  "excluded": true
}
```

**200**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| id | integer | 収集結果の id |
| crawl_setting_id | integer | 収集設定の id |
| platform | string | サイト |
| external_id | string | サイト上の出品ID |
| name | string | 出品名 |
| product_url | string | 出品URL |
| thumbnail_url | string または null | サムネイルURL。無いときは null |
| price | integer | 価格 |
| buyout_price | integer または null | 即決価格。無いときは null |
| sold | boolean または null | 売り切れなら true、販売中なら false、不明なら null |
| sold_at | string または null | 売れた日。無いときは null |
| ends_at | string または null | 終了日時。無いときは null |
| excluded_at | string または null | 除外した日時。除外していなければ null |
| created_at | string | 作成日時。ISO 8601 |
| updated_at | string | 更新日時。ISO 8601 |
| recency_at | string または null | 新着順の時刻。売れた日が無い売り切れは null |

```json
{
  "id": 10,
  "crawl_setting_id": 1,
  "platform": "iosys",
  "external_id": "item-1",
  "name": "phone",
  "product_url": "https://example.com/items/item-1",
  "thumbnail_url": null,
  "price": 1200,
  "buyout_price": null,
  "sold": false,
  "sold_at": null,
  "ends_at": null,
  "excluded_at": "2026-11-20T09:00:00.000+09:00",
  "created_at": "2026-11-20T09:00:00.000+09:00",
  "updated_at": "2026-11-20T09:00:00.000+09:00",
  "recency_at": "2026-11-20T09:00:00.000+09:00"
}
```

**404**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| error.code | integer | 404 |
| error.message | string | `Not Found.` |
| error.details | array | 空配列 |

```json
{
  "error": {
    "code": 404,
    "message": "Not Found.",
    "details": []
  }
}
```

**503**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| error.code | integer | 503 |
| error.message | string | `Internal Server Error.`。`excluded` が無いとき |
| error.details | array | 空配列 |

```json
{
  "error": {
    "code": 503,
    "message": "Internal Server Error.",
    "details": []
  }
}
```

## `DELETE /api/v1/product_monitoring/crawl_results/:id`

指定した収集結果の行を削除する。

| 場所 | 名前 | 型 | 必須 | 説明 |
| --- | --- | --- | --- | --- |
| path | id | integer | 必須 | 収集結果の id |

```
/api/v1/product_monitoring/crawl_results/10
```

リクエストボディなし。

**200**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| （ボディ） | object | 空オブジェクト |

```json
{}
```

**404**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| error.code | integer | 404 |
| error.message | string | `Not Found.` |
| error.details | array | 空配列 |

```json
{
  "error": {
    "code": 404,
    "message": "Not Found.",
    "details": []
  }
}
```

## `GET /api/v1/product_monitoring/monitors`

保存済みのモニタリング設定を id の新しい順に返し、通知先が設定されているかも返す。

リクエストボディなし。

**200**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| monitors | array | モニタリング設定 |
| monitors[].id | integer | モニタリング設定の id |
| monitors[].name | string | 名前。1〜255文字 |
| monitors[].enabled | boolean | 最安値の通知評価を行うか |
| monitors[].discord_enabled | boolean | 通知設定の保存値 |
| monitors[].newest_notification_enabled | boolean | 新着の通知評価を行うか |
| monitors[].required_keywords | string の配列 | 必須語 |
| monitors[].negative_keywords | string の配列 | 除外語 |
| monitors[].min_price | integer または null | 価格の下限。下限なしは null |
| monitors[].max_price | integer または null | 価格の上限。上限なしは null |
| monitors[].created_at | string | 作成日時。ISO 8601 |
| monitors[].updated_at | string | 更新日時。ISO 8601 |
| discord_configured | boolean | 通知先が使える形で設定されているか |

```json
{
  "monitors": [
    {
      "id": 1,
      "name": "phone",
      "enabled": false,
      "discord_enabled": false,
      "newest_notification_enabled": false,
      "required_keywords": [
        "phone"
      ],
      "negative_keywords": [
        "case"
      ],
      "min_price": 1000,
      "max_price": 50000,
      "created_at": "2026-11-20T09:00:00.000+09:00",
      "updated_at": "2026-11-20T09:00:00.000+09:00"
    }
  ],
  "discord_configured": false
}
```

## `POST /api/v1/product_monitoring/monitors`

モニタリング設定を検証して保存し、保存した設定を返す。

| 場所 | 名前 | 型 | 必須 | 説明 |
| --- | --- | --- | --- | --- |
| body | name | string | 必須 | 名前。1〜255文字 |
| body | enabled | boolean | 任意 | 省略時は false |
| body | discord_enabled | boolean | 任意 | 省略時は false |
| body | newest_notification_enabled | boolean | 任意 | 省略時は false |
| body | required_keywords | string の配列 | 任意 | 省略時は空。各255文字、50件まで |
| body | negative_keywords | string の配列 | 任意 | 省略時は空。各255文字、50件まで |
| body | min_price | integer または null | 任意 | 0以上2147483647以下。省略または null は下限なし |
| body | max_price | integer または null | 任意 | 0以上2147483647以下。省略または null は上限なし |

```json
{
  "name": "phone",
  "enabled": false,
  "discord_enabled": false,
  "newest_notification_enabled": false,
  "required_keywords": [
    "phone"
  ],
  "negative_keywords": [
    "case"
  ],
  "min_price": 1000,
  "max_price": 50000
}
```

**200**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| id | integer | モニタリング設定の id |
| name | string | 名前。1〜255文字 |
| enabled | boolean | 最安値の通知評価を行うか |
| discord_enabled | boolean | 通知設定の保存値 |
| newest_notification_enabled | boolean | 新着の通知評価を行うか |
| required_keywords | string の配列 | 必須語 |
| negative_keywords | string の配列 | 除外語 |
| min_price | integer または null | 価格の下限。下限なしは null |
| max_price | integer または null | 価格の上限。上限なしは null |
| created_at | string | 作成日時。ISO 8601 |
| updated_at | string | 更新日時。ISO 8601 |

```json
{
  "id": 1,
  "name": "phone",
  "enabled": false,
  "discord_enabled": false,
  "newest_notification_enabled": false,
  "required_keywords": [
    "phone"
  ],
  "negative_keywords": [
    "case"
  ],
  "min_price": 1000,
  "max_price": 50000,
  "created_at": "2026-11-20T09:00:00.000+09:00",
  "updated_at": "2026-11-20T09:00:00.000+09:00"
}
```

**400**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| error.code | integer | 400 |
| error.message | string | 名前が1〜255文字でない、価格が0以上2147483647以下の整数でない、最低価格が最高価格より高い、語句が文字列でないか255文字を超えるか51件以上、有効状態が true でも false でもない、ときの文言 |
| error.details | array | 空配列 |

```json
{
  "error": {
    "code": 400,
    "message": "名前は1〜255文字で入力してください",
    "details": []
  }
}
```

## `PUT /api/v1/product_monitoring/monitors/:id`

id で指定したモニタリング設定を検証して保存し、保存後の設定を返す。抽出条件を変えたときは、それまでの日次相場を削除する。

| 場所 | 名前 | 型 | 必須 | 説明 |
| --- | --- | --- | --- | --- |
| path | id | integer | 必須 | モニタリング設定の id |
| body | name | string | 必須 | 名前。1〜255文字 |
| body | enabled | boolean | 任意 | 省略時は false |
| body | discord_enabled | boolean | 任意 | 省略時は false |
| body | newest_notification_enabled | boolean | 任意 | 省略時は false |
| body | required_keywords | string の配列 | 任意 | 省略時は空。各255文字、50件まで |
| body | negative_keywords | string の配列 | 任意 | 省略時は空。各255文字、50件まで |
| body | min_price | integer または null | 任意 | 0以上2147483647以下。省略または null は下限なし |
| body | max_price | integer または null | 任意 | 0以上2147483647以下。省略または null は上限なし |

```json
{
  "name": "phone",
  "enabled": false,
  "discord_enabled": false,
  "newest_notification_enabled": false,
  "required_keywords": [
    "phone"
  ],
  "negative_keywords": [
    "case"
  ],
  "min_price": 1000,
  "max_price": 50000
}
```

**200**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| id | integer | モニタリング設定の id |
| name | string | 名前。1〜255文字 |
| enabled | boolean | 最安値の通知評価を行うか |
| discord_enabled | boolean | 通知設定の保存値 |
| newest_notification_enabled | boolean | 新着の通知評価を行うか |
| required_keywords | string の配列 | 必須語 |
| negative_keywords | string の配列 | 除外語 |
| min_price | integer または null | 価格の下限。下限なしは null |
| max_price | integer または null | 価格の上限。上限なしは null |
| created_at | string | 作成日時。ISO 8601 |
| updated_at | string | 更新日時。ISO 8601 |

```json
{
  "id": 1,
  "name": "phone",
  "enabled": false,
  "discord_enabled": false,
  "newest_notification_enabled": false,
  "required_keywords": [
    "phone"
  ],
  "negative_keywords": [
    "case"
  ],
  "min_price": 1000,
  "max_price": 50000,
  "created_at": "2026-11-20T09:00:00.000+09:00",
  "updated_at": "2026-11-20T09:00:00.000+09:00"
}
```

**400**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| error.code | integer | 400 |
| error.message | string | 名前が1〜255文字でない、価格が0以上2147483647以下の整数でない、最低価格が最高価格より高い、語句が文字列でないか255文字を超えるか51件以上、有効状態が true でも false でもない、ときの文言 |
| error.details | array | 空配列 |

```json
{
  "error": {
    "code": 400,
    "message": "価格は0以上の整数で入力してください",
    "details": []
  }
}
```

**404**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| error.code | integer | 404 |
| error.message | string | `Not Found.` |
| error.details | array | 空配列 |

```json
{
  "error": {
    "code": 404,
    "message": "Not Found.",
    "details": []
  }
}
```

## `DELETE /api/v1/product_monitoring/monitors/:id`

id で指定したモニタリング設定と、その日次相場を削除する。

| 場所 | 名前 | 型 | 必須 | 説明 |
| --- | --- | --- | --- | --- |
| path | id | integer | 必須 | モニタリング設定の id |

```
/api/v1/product_monitoring/monitors/1
```

リクエストボディなし。

**200**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| （ボディ） | object | 空オブジェクト |

```json
{}
```

**404**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| error.code | integer | 404 |
| error.message | string | `Not Found.` |
| error.details | array | 空配列 |

```json
{
  "error": {
    "code": 404,
    "message": "Not Found.",
    "details": []
  }
}
```

## `GET /api/v1/product_monitoring/monitors/:id/crawl_results`

抽出条件に合う、除外されていない収集結果を返す。同じ出品は1件。`sale_status`、`sort`、`cursor` のいずれもないときは、新着順の最大8件で、売れた日が無い売り切れは含まない。いずれかがあるときは詳細の6件で、売れた日が無い売り切れは新着順の末尾に含む。続きはページ番号ではなく、前の最後の行のカーソルから取る。新着順のカーソルは `recency_at` と `id`。`recency_at` が空の行は、空のグループの中の `id`。価格順のカーソルは `price` と `id`。`page` は受け取らない。詳細は一度に全件を返さない。

| 場所 | 名前 | 型 | 必須 | 説明 |
| --- | --- | --- | --- | --- |
| path | id | integer | 必須 | モニタリング設定の id |
| query | sale_status | string | 任意 | 詳細の販売状態。`all`（すべて）、`on_sale`（販売中。`sold` が true でないもの）、`sold`（売り切れ）。省略時は `all`。この項目、`sort`、`cursor` のいずれかがあると詳細の6件を返す |
| query | sort | string | 任意 | 詳細の並び。`newest`（新着順。`recency_at` の降順、空は末尾、同じ位置は id の降順）、`price_asc`（価格の安い順）、`price_desc`（価格の高い順）。価格が同じときは id の降順。省略時は `newest` |
| query | cursor[id] | integer | 任意 | 続きの起点の id。前に返した `cursor.id`。無いときは先頭から |
| query | cursor[recency_at] | string | 任意 | 新着順の続き。前の最後の `recency_at`（小数秒を省略せず、そのまま送る）。空のグループの続きでは送らない |
| query | cursor[price] | integer | 任意 | 価格順の続き。前の最後の `price` |

```
/api/v1/product_monitoring/monitors/1/crawl_results?sale_status=all&sort=newest
/api/v1/product_monitoring/monitors/1/crawl_results?sale_status=all&sort=newest&cursor[id]=10&cursor[recency_at]=2026-11-20T09:00:00.000%2B09:00
```

リクエストボディなし。

**200**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| crawl_results | array | 収集結果。詳細のときは指定した並びの6件、一覧のときは新着の新しい順で最大8件 |
| crawl_results[].id | integer | 収集結果の id |
| crawl_results[].crawl_setting_id | integer | 収集設定の id |
| crawl_results[].platform | string | サイト |
| crawl_results[].external_id | string | サイト上の出品ID |
| crawl_results[].name | string | 出品名 |
| crawl_results[].product_url | string | 出品URL |
| crawl_results[].thumbnail_url | string または null | サムネイルURL。無いときは null |
| crawl_results[].price | integer | 価格 |
| crawl_results[].buyout_price | integer または null | 即決価格。無いときは null |
| crawl_results[].sold | boolean または null | 売り切れなら true、販売中なら false、不明なら null |
| crawl_results[].sold_at | string または null | 売れた日。無いときは null |
| crawl_results[].ends_at | string または null | 終了日時。無いときは null |
| crawl_results[].excluded_at | string または null | 除外した日時。除外していなければ null |
| crawl_results[].created_at | string | 作成日時。ISO 8601 |
| crawl_results[].updated_at | string | 更新日時。ISO 8601 |
| crawl_results[].recency_at | string または null | 新着順の時刻。売れた日が無い売り切れは null |
| per_page | integer | 詳細の件数。6。一覧のときは無い |
| has_more | boolean | 詳細で、同じ条件の続きがあるとき true。一覧のときは無い |
| cursor | object または null | 詳細で、この応答の最後の行の並びキーと id。結果が空のときは null。一覧のときは無い |
| cursor.id | integer | 最後の行の id |
| cursor.recency_at | string または null | 新着順のとき。売れた日が無い売り切れは null |
| cursor.price | integer | 価格順のとき |

```json
{
  "crawl_results": [
    {
      "id": 10,
      "crawl_setting_id": 1,
      "platform": "iosys",
      "external_id": "item-1",
      "name": "phone",
      "product_url": "https://example.com/items/item-1",
      "thumbnail_url": null,
      "price": 1200,
      "buyout_price": null,
      "sold": false,
      "sold_at": null,
      "ends_at": null,
      "excluded_at": null,
      "created_at": "2026-11-20T09:00:00.000+09:00",
      "updated_at": "2026-11-20T09:00:00.000+09:00",
      "recency_at": "2026-11-20T09:00:00.000+09:00"
    }
  ],
  "per_page": 6,
  "has_more": false,
  "cursor": {
    "recency_at": "2026-11-20T09:00:00.000+09:00",
    "id": 10
  }
}
```

**404**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| error.code | integer | 404 |
| error.message | string | `Not Found.` |
| error.details | array | 空配列 |

```json
{
  "error": {
    "code": 404,
    "message": "Not Found.",
    "details": []
  }
}
```

**400**

`sale_status`、`sort`、`cursor` のいずれかが不正なとき。

| 名前 | 型 | 説明 |
| --- | --- | --- |
| error.code | integer | 400 |
| error.message | string | `販売状態が不正です`、`並びが不正です`、`カーソルが不正です` のいずれか |
| error.details | array | 空配列 |

```json
{
  "error": {
    "code": 400,
    "message": "カーソルが不正です",
    "details": []
  }
}
```

## `GET /api/v1/product_monitoring/monitors/:id/summary`

販売中の最安値と、平均取引価格のある最新の日の平均取引価格を返す。一覧の8件の外も含む。該当がなければ null。

| 場所 | 名前 | 型 | 必須 | 説明 |
| --- | --- | --- | --- | --- |
| path | id | integer | 必須 | モニタリング設定の id |

```
/api/v1/product_monitoring/monitors/1/summary
```

リクエストボディなし。

**200**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| lowest_price | integer または null | 販売中の最安値 |
| latest_average_transaction_price | integer または null | 平均取引価格のある最新の日の値 |

```json
{
  "lowest_price": 300,
  "latest_average_transaction_price": 800
}
```

**404**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| error.code | integer | 404 |
| error.message | string | `Not Found.` |
| error.details | array | 空配列 |

```json
{
  "error": {
    "code": 404,
    "message": "Not Found.",
    "details": []
  }
}
```

## `POST /api/v1/product_monitoring/monitors/:id/aggregate_daily_market_prices`

今日を含む直近30日の日次相場を集計して保存する。

| 場所 | 名前 | 型 | 必須 | 説明 |
| --- | --- | --- | --- | --- |
| path | id | integer | 必須 | モニタリング設定の id |

```
/api/v1/product_monitoring/monitors/1/aggregate_daily_market_prices
```

リクエストボディなし。

**200**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| （ボディ） | object | 空オブジェクト |

```json
{}
```

**404**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| error.code | integer | 404 |
| error.message | string | `Not Found.` |
| error.details | array | 空配列 |

```json
{
  "error": {
    "code": 404,
    "message": "Not Found.",
    "details": []
  }
}
```

## `GET /api/v1/product_monitoring/monitors/:id/transactions`

抽出条件に合い、売れた日が期間内の収集結果を、売れた日の新しい順に返す。

| 場所 | 名前 | 型 | 必須 | 説明 |
| --- | --- | --- | --- | --- |
| path | id | integer | 必須 | モニタリング設定の id |
| query | start_date | string | 必須 | 開始日。`YYYY-MM-DD` |
| query | end_date | string | 必須 | 終了日。開始日以降で、開始日からの日数が90未満 |

```
/api/v1/product_monitoring/monitors/1/transactions?start_date=2026-11-01&end_date=2026-11-20
```

リクエストボディなし。

**200**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| transactions | array | 収集結果 |
| transactions[].id | integer | 収集結果の id |
| transactions[].crawl_setting_id | integer | 収集設定の id |
| transactions[].platform | string | サイト |
| transactions[].external_id | string | サイト上の出品ID |
| transactions[].name | string | 出品名 |
| transactions[].product_url | string | 出品URL |
| transactions[].thumbnail_url | string または null | サムネイルURL。無いときは null |
| transactions[].price | integer | 価格 |
| transactions[].buyout_price | integer または null | 即決価格。無いときは null |
| transactions[].sold | boolean または null | 売り切れなら true、販売中なら false、不明なら null |
| transactions[].sold_at | string または null | 売れた日。無いときは null |
| transactions[].ends_at | string または null | 終了日時。無いときは null |
| transactions[].excluded_at | string または null | 除外した日時。除外していなければ null |
| transactions[].created_at | string | 作成日時。ISO 8601 |
| transactions[].updated_at | string | 更新日時。ISO 8601 |
| transactions[].recency_at | string または null | 新着順の時刻。売れた日が無い売り切れは null |

```json
{
  "transactions": [
    {
      "id": 10,
      "crawl_setting_id": 1,
      "platform": "iosys",
      "external_id": "item-1",
      "name": "phone",
      "product_url": "https://example.com/items/item-1",
      "thumbnail_url": null,
      "price": 1200,
      "buyout_price": null,
      "sold": true,
      "sold_at": "2026-11-20T09:00:00.000+09:00",
      "ends_at": null,
      "excluded_at": null,
      "created_at": "2026-11-20T09:00:00.000+09:00",
      "updated_at": "2026-11-20T09:00:00.000+09:00",
      "recency_at": "2026-11-20T09:00:00.000+09:00"
    }
  ]
}
```

**404**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| error.code | integer | 404 |
| error.message | string | `Not Found.` |
| error.details | array | 空配列 |

```json
{
  "error": {
    "code": 404,
    "message": "Not Found.",
    "details": []
  }
}
```

**400**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| error.code | integer | 400 |
| error.message | string | `期間は開始日から90日以内で指定してください`。終了日が開始日より前、または日数が90以上のとき。日付として読めないときは解析に失敗した文言 |
| error.details | array | 空配列 |

```json
{
  "error": {
    "code": 400,
    "message": "期間は開始日から90日以内で指定してください",
    "details": []
  }
}
```

**503**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| error.code | integer | 503 |
| error.message | string | `Internal Server Error.`。`start_date` または `end_date` が無いとき |
| error.details | array | 空配列 |

```json
{
  "error": {
    "code": 503,
    "message": "Internal Server Error.",
    "details": []
  }
}
```

## `GET /api/v1/product_monitoring/daily_market_prices`

すべてのモニタリング設定の日次相場を、モニタリング設定の id と日付の順に返す。

リクエストボディなし。

**200**

| 名前 | 型 | 説明 |
| --- | --- | --- |
| daily_market_prices | array | 日次相場 |
| daily_market_prices[].id | integer | 日次相場の id |
| daily_market_prices[].date | string | 日付。`YYYY-MM-DD` |
| daily_market_prices[].average_transaction_price | integer または null | 平均取引価格。取引がなければ null |
| daily_market_prices[].transaction_count | integer | 取引件数 |
| daily_market_prices[].created_at | string | 作成日時。ISO 8601 |
| daily_market_prices[].updated_at | string | 更新日時。ISO 8601 |
| daily_market_prices[].monitor_id | integer | モニタリング設定の id |

```json
{
  "daily_market_prices": [
    {
      "id": 1,
      "date": "2026-11-20",
      "average_transaction_price": 800,
      "transaction_count": 1,
      "created_at": "2026-11-20T09:00:00.000+09:00",
      "updated_at": "2026-11-20T09:00:00.000+09:00",
      "monitor_id": 1
    }
  ]
}
```
