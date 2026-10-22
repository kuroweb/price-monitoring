import { beforeEach, describe, expect, it, vi } from 'vitest'

import { http } from '@/lib/http-client'

const fetchMock = vi.fn<typeof fetch>()

beforeEach(() => {
  vi.stubEnv('NEXT_PUBLIC_API_URL', 'https://public.example.test')
  vi.stubEnv('NEXT_PRIVATE_API_URL', 'https://private.example.test')
  vi.stubGlobal('fetch', fetchMock)
  fetchMock.mockReset()
})

describe('http（ブラウザー）', () => {
  it('公開 URL に GET し、未指定・null の検索条件を除いて snake_case にする', async () => {
    fetchMock.mockResolvedValue(new Response('{}'))

    await http('/api/v1/products', {
      params: {
        categoryId: 3,
        enabled: false,
        minPrice: 0,
        name: 'Mac Book',
        empty: null,
        absent: undefined,
      },
    })

    const [url, config] = fetchMock.mock.calls[0]
    expect(String(url)).toBe(
      'https://public.example.test/api/v1/products?category_id=3&enabled=false&min_price=0&name=Mac+Book',
    )
    expect(config).toEqual({
      method: 'GET',
      headers: { 'Content-Type': 'application/json' },
      body: undefined,
    })
  })

  it('ネストした送信データを変換し、指定したメソッドとヘッダーを使う', async () => {
    fetchMock.mockResolvedValue(new Response('{}', { status: 201 }))
    const data = {
      categoryId: 1,
      crawlSetting: { minPrice: 0, requiredKeywords: [{ keyword: 'Mac' }] },
    }

    const result = await http('/api/v1/products', {
      method: 'POST',
      headers: { Authorization: 'Bearer test', 'Content-Type': 'application/custom+json' },
      data,
    })

    expect(fetchMock).toHaveBeenCalledWith('https://public.example.test/api/v1/products', {
      method: 'POST',
      headers: { Authorization: 'Bearer test', 'Content-Type': 'application/custom+json' },
      body: JSON.stringify({
        category_id: 1,
        crawl_setting: { min_price: 0, required_keywords: [{ keyword: 'Mac' }] },
      }),
    })
    expect(data.crawlSetting).toEqual({ minPrice: 0, requiredKeywords: [{ keyword: 'Mac' }] })
    expect(result.status).toBe(201)
  })

  it('レスポンス内のオブジェクトと配列を再帰的に camelCase にする', async () => {
    fetchMock.mockResolvedValue(
      new Response(JSON.stringify({ product_id: 1, crawl_settings: [{ min_price: 10 }] })),
    )

    expect(await http('/products')).toEqual({
      data: { productId: 1, crawlSettings: [{ minPrice: 10 }] },
      error: null,
      status: 200,
    })
  })

  it('配列をトップレベルに持つレスポンスも変換する', async () => {
    fetchMock.mockResolvedValue(new Response('[{"product_id":1}]'))
    expect((await http('/products')).data).toEqual([{ productId: 1 }])
  })

  it.each(['[]', '[1,2]', '"text"', 'false', '0', 'null', 'not json', ''])(
    'オブジェクト以外の本文 %j を扱う',
    async (body) => {
      fetchMock.mockResolvedValue(new Response(body))
      let expected: unknown = body || null
      if (body && body !== 'not json') expected = JSON.parse(body)
      expect(await http('/products')).toEqual({ data: expected, error: null, status: 200 })
    },
  )

  it('204 では data と error を null にする', async () => {
    fetchMock.mockResolvedValue(new Response(null, { status: 204 }))
    expect(await http('/products/1', { method: 'DELETE' })).toEqual({
      data: null,
      error: null,
      status: 204,
    })
  })

  it('入力エラーのコード・メッセージ・詳細を保持する', async () => {
    fetchMock.mockResolvedValue(
      new Response(
        JSON.stringify({
          code: 1001,
          message: '入力内容を確認してください',
          details: [{ field_name: 'category_id' }],
        }),
        { status: 422 },
      ),
    )

    expect(await http('/products')).toEqual({
      data: null,
      status: 422,
      error: {
        code: 1001,
        message: '入力内容を確認してください',
        details: [{ fieldName: 'category_id' }],
      },
    })
  })

  it.each(['<html>Bad Gateway</html>', '', '{}'])(
    'エラー本文 %j に詳細がなくても HTTP ステータスを返す',
    async (body) => {
      fetchMock.mockResolvedValue(new Response(body, { status: 502 }))
      expect(await http('/products')).toEqual({
        data: null,
        status: 502,
        error: { code: 502, message: 'Request failed.', details: [] },
      })
    },
  )

  it('接続失敗を呼び出し元が処理できるエラーレスポンスにする', async () => {
    fetchMock.mockRejectedValue(new Error('Failed to fetch'))
    expect(await http('/products')).toEqual({
      data: null,
      status: 500,
      error: { code: 500, message: 'Failed to fetch', details: [] },
    })
  })

  it('HTTP エラーに付与されたステータスと詳細を保持する', async () => {
    fetchMock.mockRejectedValue(
      Object.assign(new Error('Unauthorized'), {
        status: 401,
        responseData: { code: 40101, message: 'ログインが必要です', details: [] },
      }),
    )
    expect(await http('/products')).toEqual({
      data: null,
      status: 401,
      error: { code: 40101, message: 'ログインが必要です', details: [] },
    })
  })

  it('Error 以外の例外は記録して再送出する', async () => {
    const log = vi.spyOn(console, 'error').mockImplementation(() => {})
    fetchMock.mockRejectedValue('unexpected')
    await expect(http('/products')).rejects.toThrow('Unexpected error occurred.')
    expect(log).toHaveBeenCalledWith('Error: Unexpected error occurred.')
  })
})
