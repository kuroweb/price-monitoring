import { act, render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { NuqsTestingAdapter } from 'nuqs/adapters/testing'
import { beforeEach, describe, expect, it, vi } from 'vitest'



import { createProduct, updateProduct } from '@/features/products/api/actions'
import type { ProductList } from '@/features/products/api/types'
import CreateProductModal from '@/features/products/components/CreateProductModal'
import UpdateProductModal from '@/features/products/components/UpdateProductModal'
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
const product = { id: 1, name: 'MacBook', category } as ProductList['products'][number]
const cases = [
  {
    name: '商品作成',
    save: createProduct,
    label: '登録',
    pending: '登録中…',
    mount: () => (
      <NuqsTestingAdapter searchParams='?create_product_modal=true'>
        <CreateProductModal product={product} categories={[category]} />
      </NuqsTestingAdapter>
    ),
  },
  {
    name: '商品更新',
    save: updateProduct,
    label: '保存',
    pending: '保存中…',
    mount: () => (
      <NuqsTestingAdapter searchParams='?update_product_modal=true'>
        <UpdateProductModal productId={1} product={product} categories={[category]} />
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
