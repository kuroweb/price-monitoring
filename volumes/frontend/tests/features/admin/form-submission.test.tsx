import { act, render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { NuqsTestingAdapter } from 'nuqs/adapters/testing'
import { beforeEach, describe, expect, it, vi } from 'vitest'

import BackmarketWatchTargetFormModal from '@/features/admin/backmarket-watch-targets/components/BackmarketWatchTargetFormModal'
import CreateCategoryModal from '@/features/categories/components/CreateCategoryModal'
import UpdateCategoryModal from '@/features/categories/components/UpdateCategoryModal'
import CreateProductModal from '@/features/products/components/CreateProductModal'
import UpdateProductModal from '@/features/products/components/UpdateProductModal'
import {
  createBackmarketWatchTarget,
  updateBackmarketWatchTarget,
  createCategory,
  updateCategory,
  createProduct,
  updateProduct,
} from '@/lib/actions'
import type { BackmarketWatchTarget, Category, ProductList } from '@/lib/api'

vi.mock('next/navigation', () => ({ useRouter: () => ({ refresh: vi.fn() }) }))
vi.mock('react-toastify', () => ({ toast: { success: vi.fn(), error: vi.fn() } }))
vi.mock('@/lib/actions', () => ({
  createBackmarketWatchTarget: vi.fn(),
  updateBackmarketWatchTarget: vi.fn(),
  createCategory: vi.fn(),
  updateCategory: vi.fn(),
  createProduct: vi.fn(),
  updateProduct: vi.fn(),
}))
const category = { id: 1, name: 'PC', parentId: null } as Category
const product = { id: 1, name: 'MacBook', category } as ProductList['products'][number]
const target = {
  id: 1,
  name: 'MacBook',
  url: 'https://example.test',
  enabled: true,
} as BackmarketWatchTarget
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
  {
    name: 'Backmarket作成',
    save: createBackmarketWatchTarget,
    label: '登録',
    pending: '登録中…',
    mount: () => (
      <BackmarketWatchTargetFormModal isOpen mode='create' target={target} onClose={vi.fn()} />
    ),
  },
  {
    name: 'Backmarket更新',
    save: updateBackmarketWatchTarget,
    label: '更新',
    pending: '保存中…',
    mount: () => (
      <BackmarketWatchTargetFormModal isOpen mode='edit' target={target} onClose={vi.fn()} />
    ),
  },
]
beforeEach(() => {
  vi.clearAllMocks()
})
describe.each(cases)('$name: 送信中', ({ save, label, pending, mount, name }) => {
  it('処理中は再送信できず、失敗後は入力を維持して再試行できる', async () => {
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
