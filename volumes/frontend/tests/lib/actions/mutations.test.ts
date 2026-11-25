import { revalidatePath } from 'next/cache'
import { beforeEach, describe, expect, it, vi } from 'vitest'

import { createBackmarketWatchTarget, updateBackmarketWatchTarget, destroyBackmarketWatchTarget } from '@/features/backmarket/api/actions'
import { http } from '@/lib/http-client'

vi.mock('next/cache', () => ({ revalidatePath: vi.fn() }))
vi.mock('@/lib/http-client', () => ({ http: vi.fn() }))

const success = { data: null, error: null, status: 200 }

beforeEach(() => {
  vi.mocked(http).mockReset()
  vi.mocked(http).mockResolvedValue(success)
})

describe('Server Action から API と再検証への連携', () => {
  it('計測対象を作成して監視管理画面を再検証すること', async () => {
    const data = { name: 'MacBook', url: 'https://example.test/macbook', enabled: true }
    expect(await createBackmarketWatchTarget(data)).toBe(success)
    expect(http).toHaveBeenCalledWith('/api/v1/backmarket_watch_targets', { method: 'POST', data })
    expect(vi.mocked(revalidatePath).mock.calls).toEqual([['/admin/backmarket', 'page'], ['/backmarket', 'page']])
  })

  it('計測対象の無効化は PUT で送り、監視管理画面を再検証すること', async () => {
    const data = { name: 'MacBook', url: 'https://example.test/macbook', enabled: false }
    await updateBackmarketWatchTarget(3, data)
    expect(http).toHaveBeenCalledWith('/api/v1/backmarket_watch_targets/3', { method: 'PUT', data })
    expect(vi.mocked(revalidatePath).mock.calls).toEqual([['/admin/backmarket', 'page'], ['/backmarket', 'page']])
  })

  it('計測対象削除後に監視管理画面を再検証すること', async () => {
    await destroyBackmarketWatchTarget(3)
    expect(http).toHaveBeenCalledWith('/api/v1/backmarket_watch_targets/3', { method: 'DELETE' })
    expect(vi.mocked(revalidatePath).mock.calls).toEqual([['/admin/backmarket', 'page'], ['/backmarket', 'page']])
  })

  it('入力エラーを UI が判断できるようそのまま返すこと', async () => {
    const failure = {
      data: null,
      status: 422,
      error: { code: 422, message: '名前が必要です', details: [] },
    }
    vi.mocked(http).mockResolvedValue(failure)
    expect(await createBackmarketWatchTarget({ name: '', url: '', enabled: true })).toBe(failure)
  })

  it('API 呼び出しが例外になった場合は再検証せず例外を伝えること', async () => {
    vi.mocked(http).mockRejectedValue(new Error('unexpected'))
    await expect(destroyBackmarketWatchTarget(3)).rejects.toThrow('unexpected')
    expect(revalidatePath).not.toHaveBeenCalled()
  })
})
