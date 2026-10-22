import { act, renderHook } from '@testing-library/react'
import { NuqsTestingAdapter } from 'nuqs/adapters/testing'
import { describe, expect, it, vi } from 'vitest'

import { useOrderState } from '@/features/products/[id]/hooks/useOrderState'
import { usePageState } from '@/features/products/[id]/hooks/usePageState'
import { usePerState } from '@/features/products/[id]/hooks/usePerState'
import { usePlatformState } from '@/features/products/[id]/hooks/usePlatformState'
import { useSortState } from '@/features/products/[id]/hooks/useSortState'
import { useStatusState } from '@/features/products/[id]/hooks/useStatusState'
import { useCategoryIdState } from '@/features/products/hooks/useCategoryIdState'

describe.each([
  { key: 'page', useState: usePageState, initial: 1, selected: 3 },
  { key: 'per', useState: usePerState, initial: 100, selected: 50 },
  { key: 'category_id', useState: useCategoryIdState, initial: -1, selected: 7 },
])('数値の検索条件 $key', ({ key, useState, initial, selected }) => {
  it.each(['', `?${key}=invalid`])('未指定・不正値 %s では初期値を使う', (searchParams) => {
    const { result } = renderHook(useState, {
      wrapper: ({ children }) => (
        <NuqsTestingAdapter searchParams={searchParams}>{children}</NuqsTestingAdapter>
      ),
    })
    expect(result.current[0]).toBe(initial)
  })

  it('URL の値を読み取り、更新時は他の検索条件を保持してサーバー遷移する', async () => {
    const onUrlUpdate = vi.fn()
    const { result } = renderHook(useState, {
      wrapper: ({ children }) => (
        <NuqsTestingAdapter
          searchParams={`?${key}=${selected}&keyword=Mac`}
          onUrlUpdate={onUrlUpdate}
        >
          {children}
        </NuqsTestingAdapter>
      ),
    })
    expect(result.current[0]).toBe(selected)

    await act(async () => {
      await result.current[1](selected + 1)
    })

    expect(onUrlUpdate).toHaveBeenCalledOnce()
    const update = onUrlUpdate.mock.calls[0][0]
    expect(update.searchParams.get(key)).toBe(String(selected + 1))
    expect(update.searchParams.get('keyword')).toBe('Mac')
    expect(update.options.shallow).toBe(false)
  })
})

describe.each([
  { key: 'order', useState: useOrderState, initial: 'asc', selected: 'desc' },
  { key: 'platform', useState: usePlatformState, initial: 'all', selected: 'mercari' },
  { key: 'sort', useState: useSortState, initial: 'updated_at', selected: 'price' },
  { key: 'status', useState: useStatusState, initial: 'published', selected: 'unpublished' },
])('文字列の検索条件 $key', ({ key, useState, initial, selected }) => {
  it('クエリ未指定では初期値を使う', () => {
    const { result } = renderHook(useState, {
      wrapper: ({ children }) => <NuqsTestingAdapter>{children}</NuqsTestingAdapter>,
    })
    expect(result.current[0]).toBe(initial)
  })

  it('URL の値を読み取り、初期値へ戻すとそのクエリだけを削除する', async () => {
    const onUrlUpdate = vi.fn()
    const { result } = renderHook(useState, {
      wrapper: ({ children }) => (
        <NuqsTestingAdapter searchParams={`?${key}=${selected}&page=3`} onUrlUpdate={onUrlUpdate}>
          {children}
        </NuqsTestingAdapter>
      ),
    })
    expect(result.current[0]).toBe(selected)

    await act(async () => {
      await result.current[1](initial)
    })

    const update = onUrlUpdate.mock.calls[0][0]
    expect(update.searchParams.has(key)).toBe(false)
    expect(update.searchParams.get('page')).toBe('3')
    expect(update.options.shallow).toBe(false)
  })
})
