import { render, screen } from '@testing-library/react'
import { NuqsTestingAdapter } from 'nuqs/adapters/testing'
import { describe, expect, it, vi } from 'vitest'

import BackmarketWatchTargetsTable from '@/features/backmarket/components/BackmarketWatchTargetsTable'
import CategoriesList from '@/features/categories/components/CategoriesList'
import ProductPriceList from '@/features/products/components/ProductPriceList'

vi.mock('next/navigation', () => ({ useRouter: () => ({ refresh: vi.fn() }) }))
vi.mock('@/features/backmarket/api/actions', () => ({ getBackmarketRecents: vi.fn(), getBackmarketWatchTargets: vi.fn(), createBackmarketWatchTarget: vi.fn(), updateBackmarketWatchTarget: vi.fn(), destroyBackmarketWatchTarget: vi.fn() }))
vi.mock('@/features/categories/api/actions', () => ({ getCategories: vi.fn(), getCategoriesStructured: vi.fn(), createCategory: vi.fn(), updateCategory: vi.fn(), destroyCategory: vi.fn() }))
vi.mock('@/features/products/api/actions', () => ({}))

describe('一覧の空状態', () => {
  it('カテゴリなしの場合は追加を案内する', () => {
    render(
      <NuqsTestingAdapter>
        <CategoriesList structuredCategories={[]} categories={[]} />
      </NuqsTestingAdapter>,
    )
    expect(
      screen.getByText('カテゴリはまだありません。カテゴリを追加してください。'),
    ).toBeInTheDocument()
  })
  it('Backmarket計測対象なしの場合は追加ボタンと案内を表示する', () => {
    render(<BackmarketWatchTargetsTable backmarketWatchTargets={[]} />)
    expect(
      screen.getByText('計測対象はまだありません。「計測対象を追加」から登録してください。'),
    ).toBeInTheDocument()
    expect(screen.getByRole('button', { name: '計測対象を追加' })).toBeEnabled()
  })
  it('最安値一覧が空の場合は商品追加やカテゴリ変更を案内する', () => {
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
  it('商品の価格が未取得の場合は対象名と価格情報待ちを表示する', () => {
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
