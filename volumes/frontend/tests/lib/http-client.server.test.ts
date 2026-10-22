// @vitest-environment node

import { EventEmitter } from 'events'

import { beforeEach, describe, expect, it, vi } from 'vitest'

import { http } from '@/lib/http-client'

const { httpRequest, httpsRequest } = vi.hoisted(() => ({
  httpRequest: vi.fn(),
  httpsRequest: vi.fn(),
}))

vi.mock('http', () => ({ default: { request: httpRequest } }))
vi.mock('https', () => ({ default: { request: httpsRequest } }))

beforeEach(() => {
  vi.stubEnv('NEXT_PRIVATE_API_URL', 'https://private.example.test')
  vi.stubEnv('NEXT_PUBLIC_API_URL', 'https://public.example.test')
  httpRequest.mockReset()
  httpsRequest.mockReset()
})

function respond(status: number | undefined, chunks: string[]) {
  const response = Object.assign(new EventEmitter(), { statusCode: status, setEncoding: vi.fn() })
  const request = Object.assign(new EventEmitter(), {
    write: vi.fn(),
    end: vi.fn(() => {
      for (const chunk of chunks) response.emit('data', chunk)
      response.emit('end')
    }),
  })
  const implementation = (
    _url: URL,
    _options: unknown,
    callback: (res: typeof response) => void,
  ) => {
    callback(response)
    return request
  }
  httpRequest.mockImplementation(implementation)
  httpsRequest.mockImplementation(implementation)
  return request
}

describe('http（サーバー）', () => {
  it('非公開 URL に HTTPS で接続し、分割された本文を結合して変換する', async () => {
    const request = respond(200, ['{"product_', 'id":1}'])

    expect(await http('/products', { params: { categoryId: 2 } })).toEqual({
      data: { productId: 1 },
      error: null,
      status: 200,
    })
    expect(httpsRequest.mock.calls[0][0].href).toBe(
      'https://private.example.test/products?category_id=2',
    )
    expect(httpRequest).not.toHaveBeenCalled()
    expect(request.write).not.toHaveBeenCalled()
    expect(request.end).toHaveBeenCalledOnce()
  })

  it('HTTP URL では HTTP transport に変換済みの本文を送信する', async () => {
    vi.stubEnv('NEXT_PRIVATE_API_URL', 'http://backend.test:3000')
    const request = respond(201, ['{"product_id":1}'])

    await http('/products', { method: 'POST', data: { categoryId: 2 } })

    expect(httpRequest.mock.calls[0][0].href).toBe('http://backend.test:3000/products')
    expect(httpRequest.mock.calls[0][1]).toMatchObject({
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
    })
    expect(httpsRequest).not.toHaveBeenCalled()
    expect(request.write).toHaveBeenCalledWith('{"category_id":2}')
  })

  it('本文がない 204 を正常に処理する', async () => {
    respond(204, [])
    expect(await http('/products/1', { method: 'DELETE' })).toEqual({
      data: null,
      error: null,
      status: 204,
    })
  })

  it('ステータス不明の応答を 500 として扱う', async () => {
    respond(undefined, [])
    expect(await http('/products')).toEqual({
      data: null,
      status: 500,
      error: { code: 500, message: 'Request failed.', details: [] },
    })
  })

  it('サーバー側の接続エラーをエラーレスポンスにする', async () => {
    const request = Object.assign(new EventEmitter(), {
      end: () => request.emit('error', new Error('ECONNREFUSED')),
    })
    httpsRequest.mockReturnValue(request)
    expect(await http('/products')).toEqual({
      data: null,
      status: 500,
      error: { code: 500, message: 'ECONNREFUSED', details: [] },
    })
  })
})
