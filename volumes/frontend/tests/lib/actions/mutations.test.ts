import { revalidatePath } from 'next/cache'
import { beforeEach, describe, expect, it, vi } from 'vitest'

import {
  createBackmarketWatchTarget,
  updateBackmarketWatchTarget,
  destroyBackmarketWatchTarget,
} from '@/lib/actions/backmarketWatchTargets'
import {
  createCategory,
  updateCategory,
  destroyCategory,
  getCategories,
} from '@/lib/actions/categories'
import { destroyProduct } from '@/lib/actions/products'
import { http } from '@/lib/http-client'

vi.mock('next/cache', () => ({ revalidatePath: vi.fn() }))
vi.mock('@/lib/http-client', () => ({ http: vi.fn() }))

const success = { data: null, error: null, status: 200 }

beforeEach(() => {
  vi.mocked(http).mockReset()
  vi.mocked(http).mockResolvedValue(success)
})

describe('Server Action から API と再検証への連携', () => {
  it('カテゴリ作成後にカテゴリ管理画面を再検証し、API の結果を返す', async () => {
    const data = { name: 'ノートパソコン', parentId: 1 }
    expect(await createCategory(data)).toBe(success)
    expect(http).toHaveBeenCalledWith('/api/v1/categories', { method: 'POST', data })
    expect(revalidatePath).toHaveBeenCalledExactlyOnceWith('/admin/categories', 'page')
  })

  it('カテゴリの更新は PATCH で送り、管理画面を再検証する', async () => {
    const data = { parentId: null }
    await updateCategory(2, data)
    expect(http).toHaveBeenCalledWith('/api/v1/categories/2', { method: 'PATCH', data })
    expect(revalidatePath).toHaveBeenCalledExactlyOnceWith('/admin/categories', 'page')
  })

  it('カテゴリ削除後に管理画面を再検証する', async () => {
    await destroyCategory(2)
    expect(http).toHaveBeenCalledWith('/api/v1/categories/2', { method: 'DELETE' })
    expect(revalidatePath).toHaveBeenCalledExactlyOnceWith('/admin/categories', 'page')
  })

  it('参照操作は検索条件を渡し、再検証しない', async () => {
    expect(await getCategories({ rootOnly: true })).toBe(success)
    expect(http).toHaveBeenCalledWith('/api/v1/categories', {
      method: 'GET',
      params: { rootOnly: true },
    })
    expect(revalidatePath).not.toHaveBeenCalled()
  })

  it('商品削除後は管理・公開側の関連画面を再検証する', async () => {
    await destroyProduct(4)
    expect(http).toHaveBeenCalledWith('/api/v1/products/4', { method: 'DELETE' })
    expect(vi.mocked(revalidatePath).mock.calls).toEqual([
      ['/admin/products', 'page'],
      ['/admin/products/[id]', 'page'],
      ['/admin/categories', 'page'],
      ['/products', 'page'],
      ['/products/[id]', 'page'],
      ['/products/categories/[category]', 'page'],
    ])
  })

  it('監視対象を作成して監視管理画面を再検証する', async () => {
    const data = { name: 'MacBook', url: 'https://example.test/macbook', enabled: true }
    expect(await createBackmarketWatchTarget(data)).toBe(success)
    expect(http).toHaveBeenCalledWith('/api/v1/backmarket_watch_targets', { method: 'POST', data })
    expect(revalidatePath).toHaveBeenCalledExactlyOnceWith('/admin/backmarket_watch', 'page')
  })

  it('監視対象の無効化は PUT で送り、監視管理画面を再検証する', async () => {
    const data = { name: 'MacBook', url: 'https://example.test/macbook', enabled: false }
    await updateBackmarketWatchTarget(3, data)
    expect(http).toHaveBeenCalledWith('/api/v1/backmarket_watch_targets/3', { method: 'PUT', data })
    expect(revalidatePath).toHaveBeenCalledExactlyOnceWith('/admin/backmarket_watch', 'page')
  })

  it('監視対象削除後に監視管理画面を再検証する', async () => {
    await destroyBackmarketWatchTarget(3)
    expect(http).toHaveBeenCalledWith('/api/v1/backmarket_watch_targets/3', { method: 'DELETE' })
    expect(revalidatePath).toHaveBeenCalledExactlyOnceWith('/admin/backmarket_watch', 'page')
  })

  it('入力エラーを UI が判断できるようそのまま返す', async () => {
    const failure = {
      data: null,
      status: 422,
      error: { code: 422, message: '名前が必要です', details: [] },
    }
    vi.mocked(http).mockResolvedValue(failure)
    expect(await createCategory({ name: '' })).toBe(failure)
  })

  it('API 呼び出しが例外になった場合は再検証せず例外を伝える', async () => {
    vi.mocked(http).mockRejectedValue(new Error('unexpected'))
    await expect(destroyProduct(4)).rejects.toThrow('unexpected')
    expect(revalidatePath).not.toHaveBeenCalled()
  })
})
