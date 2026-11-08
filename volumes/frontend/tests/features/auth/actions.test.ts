import { redirect } from 'next/navigation'
import { beforeEach, describe, expect, it, vi } from 'vitest'

import { logout } from '@/features/auth/api/actions'
import { http } from '@/lib/http-client'

vi.mock('next/headers', () => ({ cookies: vi.fn(async () => ({ toString: (): string => 'session=123' })) }))
vi.mock('next/navigation', () => ({ redirect: vi.fn() }))
vi.mock('@/lib/http-client', () => ({ http: vi.fn() }))

beforeEach(() => vi.clearAllMocks())

describe('ログアウト', () => {
  it('同じ Cookie と取得した CSRF トークンを BFF に渡すこと', async () => {
    vi.mocked(http)
      .mockResolvedValueOnce({ data: { csrfToken: 'token' }, error: null, status: 200 })
      .mockResolvedValueOnce({ data: { logoutUrl: 'https://provider.example.test/oauth/logout' }, error: null, status: 200 })
    await logout()
    expect(http).toHaveBeenNthCalledWith(1, '/auth/csrf_token', { headers: { Cookie: 'session=123' } })
    expect(http).toHaveBeenNthCalledWith(2, '/logout', {
      method: 'DELETE', headers: { Cookie: 'session=123', 'X-CSRF-Token': 'token', Accept: 'application/json' },
    })
  })

  it('Provider のセッションも終了するため、BFF が返したログアウト先へ移すこと', async () => {
    vi.mocked(http)
      .mockResolvedValueOnce({ data: { csrfToken: 'token' }, error: null, status: 200 })
      .mockResolvedValueOnce({ data: { logoutUrl: 'https://provider.example.test/oauth/logout' }, error: null, status: 200 })
    await logout()
    expect(redirect).toHaveBeenCalledWith('https://provider.example.test/oauth/logout')
  })

  it('CSRF トークンを取得できなければログアウトを送信しないこと', async () => {
    vi.mocked(http).mockResolvedValueOnce({ data: null, error: { code: 500, message: 'error', details: [] }, status: 500 })
    await expect(logout()).rejects.toThrow('ログアウトできませんでした')
    expect(http).toHaveBeenCalledTimes(1)
  })
})
