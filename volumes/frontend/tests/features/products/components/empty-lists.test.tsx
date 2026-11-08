import { render, screen } from '@testing-library/react'
import { NuqsTestingAdapter } from 'nuqs/adapters/testing'
import { describe, expect, it, vi } from 'vitest'

import ProductPriceList from '@/features/products/components/ProductPriceList'

vi.mock('next/navigation', () => ({ useRouter: () => ({ refresh: vi.fn() }) }))
vi.mock('@/features/backmarket/api/actions', () => ({ getBackmarketRecents: vi.fn(), getBackmarketWatchTargets: vi.fn(), createBackmarketWatchTarget: vi.fn(), updateBackmarketWatchTarget: vi.fn(), destroyBackmarketWatchTarget: vi.fn() }))
vi.mock('@/features/categories/api/actions', () => ({ getCategories: vi.fn(), getCategoriesStructured: vi.fn(), createCategory: vi.fn(), updateCategory: vi.fn(), destroyCategory: vi.fn() }))
vi.mock('@/features/products/api/actions', () => ({}))

describe('一覧の空状態', () => {
  it('最安値一覧が空の場合は商品追加やカテゴリ変更を案内すること', () => {
    render(
      <NuqsTestingAdapter>
        <ProductPriceList productPrices={[]} products={[]} categories={[]} />
      </NuqsTestingAdapter>,
    )
    expect(
      screen.getByText(
        '表示できる商品がありません。商品を追加するか、カテゴリを変更してください。',
      ),
    ).toBeInTheDocument()
  })
  it('商品の価格が未取得の場合は対象名と価格情報待ちを表示すること', () => {
    render(
      <NuqsTestingAdapter>
        <ProductPriceList
          productPrices={[
            {
              id: 1,
              name: 'MacBook',
              createdAt: '2026-01-01T00:00:00Z',
              updatedAt: '2026-01-01T00:00:00Z',
              relatedProducts: [],
            },
          ]}
          products={[]}
          categories={[]}
        />
      </NuqsTestingAdapter>,
    )
    expect(screen.getByRole('link', { name: 'MacBook' })).toBeInTheDocument()
    expect(screen.getByText('関連商品の価格情報はまだありません。')).toBeInTheDocument()
  })
})
