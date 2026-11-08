import { act, render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { NuqsTestingAdapter } from 'nuqs/adapters/testing'
import { beforeEach, describe, expect, it, vi } from 'vitest'


import { createCategory, updateCategory } from '@/features/categories/api/actions'
import CreateCategoryModal from '@/features/categories/components/CreateCategoryModal'
import UpdateCategoryModal from '@/features/categories/components/UpdateCategoryModal'
import type { Category } from '@/lib/category'

vi.mock('next/navigation', () => ({ useRouter: () => ({ refresh: vi.fn() }) }))
vi.mock('react-toastify', () => ({ toast: { success: vi.fn(), error: vi.fn() } }))
vi.mock('@/features/backmarket/api/actions', () => ({ getBackmarketRecents: vi.fn(), getBackmarketWatchTargets: vi.fn(), createBackmarketWatchTarget: vi.fn(), updateBackmarketWatchTarget: vi.fn(), destroyBackmarketWatchTarget: vi.fn() }))
vi.mock('@/features/categories/api/actions', () => ({ getCategories: vi.fn(), getCategoriesStructured: vi.fn(), createCategory: vi.fn(), updateCategory: vi.fn(), destroyCategory: vi.fn() }))
vi.mock('@/features/products/api/actions', () => ({
  createBackmarketWatchTarget: vi.fn(),
  updateBackmarketWatchTarget: vi.fn(),
  createCategory: vi.fn(),
  updateCategory: vi.fn(),
  createProduct: vi.fn(),
  updateProduct: vi.fn(),
}))
const category = { id: 1, name: 'PC', parentId: null } as Category
const cases = [
  {
    name: 'カテゴリ作成',
    save: createCategory,
    label: '登録',
    pending: '登録中…',
    mount: () => (
      <NuqsTestingAdapter searchParams='?create_category_modal=true'>
        <CreateCategoryModal categories={[]} />
      </NuqsTestingAdapter>
    ),
  },
  {
    name: 'カテゴリ更新',
    save: updateCategory,
    label: '更新',
    pending: '保存中…',
    mount: () => (
      <NuqsTestingAdapter searchParams='?update_category_modal=true'>
        <UpdateCategoryModal category={category} categories={[]} />
      </NuqsTestingAdapter>
    ),
  },
]
beforeEach(() => {
  vi.clearAllMocks()
})
describe.each(cases)('$name: 送信中', ({ save, label, pending, mount, name }) => {
  it('処理中は再送信できず、失敗後は入力を維持して再試行できること', async () => {
    let reject!: (error: Error) => void
    vi.mocked(save).mockImplementationOnce(
      () =>
        new Promise<never>((_, fail) => {
          reject = fail
        }),
    )
    render(mount())
    if (name === 'カテゴリ作成') await userEvent.type(screen.getByRole('textbox'), 'PC')
    await userEvent.click(screen.getByRole('button', { name: label }))
    const button = await screen.findByRole('button', { name: pending })
    expect(button).toBeDisabled()
    await userEvent.click(button)
    expect(save).toHaveBeenCalledOnce()
    await act(async () => reject(new Error('offline')))
    await waitFor(() => expect(screen.getByRole('button', { name: label })).toBeEnabled())
    expect(
      screen.getByDisplayValue(name.startsWith('カテゴリ') ? 'PC' : 'MacBook'),
    ).toBeInTheDocument()
  })
})
