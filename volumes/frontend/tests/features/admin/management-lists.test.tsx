import { act, render, screen, waitFor, within } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { NuqsTestingAdapter } from 'nuqs/adapters/testing'
import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest'

import BackmarketWatchTargetsTable from '@/features/admin/backmarket-watch-targets/components/BackmarketWatchTargetsTable'
import ProductsTable from '@/features/admin/products/components/ProductsTable'
import CategoriesList from '@/features/categories/components/CategoriesList'
import { destroyBackmarketWatchTarget, destroyCategory, destroyProduct } from '@/lib/actions'
import type { BackmarketWatchTarget, Category, ProductList } from '@/lib/api'

const { refresh, errorToast } = vi.hoisted(() => ({ refresh: vi.fn(), errorToast: vi.fn() }))
vi.mock('next/navigation', () => ({ useRouter: () => ({ refresh }) }))
vi.mock('react-toastify', () => ({ toast: { success: vi.fn(), error: errorToast } }))
vi.mock('@/lib/actions', () => ({
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
const categories = [
  { id: 1, name: 'PC', parentId: null },
  { id: 2, name: 'スマートフォン', parentId: null },
] as Category[]
const products = [
  { id: 1, name: 'MacBook', category: categories[0], yahooAuctionCrawlSetting: { enabled: true } },
  {
    id: 2,
    name: 'MacBook Pro',
    category: categories[0],
    yahooAuctionCrawlSetting: { enabled: false },
  },
  { id: 3, name: 'iPhone', category: categories[1], mercariCrawlSetting: { enabled: true } },
] as unknown as ProductList['products']
const target = {
  id: 1,
  name: 'MacBook',
  url: 'https://example.test',
  enabled: true,
} as BackmarketWatchTarget
const renderProducts = () =>
  render(
    <NuqsTestingAdapter>
      <ProductsTable products={products} categories={categories} />
    </NuqsTestingAdapter>,
  )
const cases = [
  {
    name: '商品',
    remove: destroyProduct,
    mount: () =>
      render(
        <NuqsTestingAdapter>
          <ProductsTable products={[products[0]]} categories={categories} />
        </NuqsTestingAdapter>,
      ),
    target: 'MacBook',
  },
  {
    name: 'カテゴリ',
    remove: destroyCategory,
    mount: () =>
      render(
        <NuqsTestingAdapter>
          <CategoriesList
            categories={categories}
            structuredCategories={[{ ...categories[0], children: [] }]}
          />
        </NuqsTestingAdapter>,
      ),
    target: 'PC',
  },
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
  it('対象名を確認し、キャンセルなら削除しない', async () => {
    const confirm = vi.spyOn(window, 'confirm').mockReturnValue(false)
    mount()
    await userEvent.click(screen.getByRole('button', { name: '削除' }))
    expect(confirm).toHaveBeenCalledWith(expect.stringContaining(target))
    expect(remove).not.toHaveBeenCalled()
  })
  it('確認後は選んだ対象だけを削除する', async () => {
    vi.spyOn(window, 'confirm').mockReturnValue(true)
    vi.mocked(remove).mockResolvedValueOnce({ data: null, error: null, status: 200 })
    mount()
    await userEvent.click(screen.getByRole('button', { name: '削除' }))
    await waitFor(() => expect(remove).toHaveBeenCalledExactlyOnceWith(1))
  })
  it('処理中の再操作を防ぎ、失敗後に再操作できる', async () => {
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
describe('商品管理の絞り込みと設定', () => {
  it('初期状態が空なら追加方法を案内する', () => {
    render(
      <NuqsTestingAdapter>
        <ProductsTable products={[]} categories={[]} />
      </NuqsTestingAdapter>,
    )
    expect(
      screen.getByText('計測対象がありません。「計測対象を追加」から登録してください。'),
    ).toBeInTheDocument()
    expect(screen.queryByText('条件に一致する計測対象がありません。')).not.toBeInTheDocument()
  })
  it('検索・カテゴリ・計測状態を組み合わせ、リセットで全件に戻る', async () => {
    const user = userEvent.setup()
    renderProducts()
    await user.type(screen.getByRole('textbox', { name: '管理コード検索' }), 'macbook')
    await user.selectOptions(screen.getByRole('combobox', { name: 'カテゴリ' }), '1')
    await user.selectOptions(screen.getByRole('combobox', { name: '計測状態' }), 'disabled')
    expect(screen.getByRole('status')).toHaveTextContent('1件 / 全3件')
    expect(screen.getByRole('link', { name: 'MacBook Pro' })).toHaveAttribute('href', '/products/2')
    expect(screen.queryByRole('link', { name: 'MacBook' })).not.toBeInTheDocument()
    await user.selectOptions(screen.getByRole('combobox', { name: 'カテゴリ' }), '2')
    expect(screen.getByText('条件に一致する計測対象がありません。')).toBeInTheDocument()
    await user.click(screen.getByRole('button', { name: '絞り込みをリセット' }))
    expect(screen.getByRole('status')).toHaveTextContent('3件 / 全3件')
  })
  it('操作メニューから対象の計測設定を開く', async () => {
    renderProducts()
    await userEvent.click(screen.getByRole('button', { name: 'MacBookの操作' }))
    await userEvent.click(screen.getAllByRole('button', { name: '計測設定' })[0])
    const dialog = screen.getAllByRole('dialog').at(-1)!
    expect(within(dialog).getByDisplayValue('MacBook')).toBeInTheDocument()
    expect(within(dialog).getByRole('group', { name: '管理コード' })).toBeInTheDocument()
  })
})
