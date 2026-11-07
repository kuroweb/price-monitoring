import { act, render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest'

import { destroyBackmarketWatchTarget } from '@/features/backmarket/api/actions'
import type { BackmarketWatchTarget } from '@/features/backmarket/api/types'
import BackmarketWatchTargetsTable from '@/features/backmarket/components/BackmarketWatchTargetsTable'


const { refresh, errorToast } = vi.hoisted(() => ({ refresh: vi.fn(), errorToast: vi.fn() }))
vi.mock('next/navigation', () => ({ useRouter: () => ({ refresh }) }))
vi.mock('react-toastify', () => ({ toast: { success: vi.fn(), error: errorToast } }))
vi.mock('@/features/backmarket/api/actions', () => ({ getBackmarketRecents: vi.fn(), getBackmarketWatchTargets: vi.fn(), createBackmarketWatchTarget: vi.fn(), updateBackmarketWatchTarget: vi.fn(), destroyBackmarketWatchTarget: vi.fn() }))
vi.mock('@/features/categories/api/actions', () => ({ getCategories: vi.fn(), getCategoriesStructured: vi.fn(), createCategory: vi.fn(), updateCategory: vi.fn(), destroyCategory: vi.fn() }))
vi.mock('@/features/products/api/actions', () => ({
  destroyProduct: vi.fn(),
  destroyCategory: vi.fn(),
  destroyBackmarketWatchTarget: vi.fn(),
  createProduct: vi.fn(),
  updateProduct: vi.fn(),
  createCategory: vi.fn(),
  updateCategory: vi.fn(),
  createBackmarketWatchTarget: vi.fn(),
  updateBackmarketWatchTarget: vi.fn(),
}))
const target = {
  id: 1,
  name: 'MacBook',
  url: 'https://example.test',
  enabled: true,
} as BackmarketWatchTarget
const cases = [
  {
    name: 'Backmarket',
    remove: destroyBackmarketWatchTarget,
    mount: () => render(<BackmarketWatchTargetsTable backmarketWatchTargets={[target]} />),
    target: 'MacBook',
  },
]
beforeEach(() => {
  vi.clearAllMocks()
})
afterEach(() => {
  vi.restoreAllMocks()
})

describe.each(cases)('$name: 削除', ({ remove, mount, target }) => {
  it('対象名を確認し、キャンセルなら削除しないこと', async () => {
    const confirm = vi.spyOn(window, 'confirm').mockReturnValue(false)
    mount()
    await userEvent.click(screen.getByRole('button', { name: '削除' }))
    expect(confirm).toHaveBeenCalledWith(expect.stringContaining(target))
    expect(remove).not.toHaveBeenCalled()
  })
  it('確認後は選んだ対象だけを削除すること', async () => {
    vi.spyOn(window, 'confirm').mockReturnValue(true)
    vi.mocked(remove).mockResolvedValueOnce({ data: null, error: null, status: 200 })
    mount()
    await userEvent.click(screen.getByRole('button', { name: '削除' }))
    await waitFor(() => expect(remove).toHaveBeenCalledExactlyOnceWith(1))
  })
  it('処理中の再操作を防ぎ、失敗後に再操作できること', async () => {
    vi.spyOn(window, 'confirm').mockReturnValue(true)
    let reject!: (reason: Error) => void
    vi.mocked(remove).mockImplementationOnce(
      () =>
        new Promise((_, fail) => {
          reject = fail
        }),
    )
    mount()
    const button = screen.getByRole('button', { name: '削除' })
    await userEvent.click(button)
    expect(button).toBeDisabled()
    await userEvent.click(button)
    expect(remove).toHaveBeenCalledExactlyOnceWith(1)
    await act(async () => reject(new Error('offline')))
    await waitFor(() => expect(button).toBeEnabled())
    expect(errorToast).toHaveBeenCalled()
  })
})
