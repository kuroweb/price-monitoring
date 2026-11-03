import { render, screen, within } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { NuqsTestingAdapter } from 'nuqs/adapters/testing'
import { describe, expect, it, vi } from 'vitest'

import ProductPriceList from '@/features/products/components/ProductPriceList'
import type { ProductList, ProductPriceList as ProductPrices } from '@/lib/api'

vi.mock('next/navigation', () => ({ useRouter: () => ({ refresh: vi.fn() }) }))
vi.mock('react-toastify', () => ({ toast: { success: vi.fn(), error: vi.fn() } }))
vi.mock('@/lib/actions', () => ({ updateProduct: vi.fn() }))

const productPrices = [
  { id: 1, name: 'MacBook Air', relatedProducts: [] },
  { id: 2, name: 'iPhone 15', relatedProducts: [] },
] as unknown as ProductPrices

const products = [
  { id: 1, name: 'MacBook Air', yahooAuctionCrawlSetting: { keyword: 'MacBook Air M1' } },
  { id: 2, name: 'iPhone 15', yahooAuctionCrawlSetting: { keyword: 'iPhone 15 128GB' } },
] as unknown as ProductList['products']

describe('ProductPriceList', () => {
  it('URLに開く指定があっても未選択ならモーダルを表示しない', () => {
    render(
      <NuqsTestingAdapter searchParams='?update_product_modal=true'>
        <ProductPriceList productPrices={productPrices} products={products} categories={[]} />
      </NuqsTestingAdapter>,
    )
    expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
  })

  it('押した商品の計測設定でモーダルを開く', async () => {
    const user = userEvent.setup()
    const onUrlUpdate = vi.fn()
    const { container } = render(
      <NuqsTestingAdapter onUrlUpdate={onUrlUpdate}>
        <ProductPriceList productPrices={productPrices} products={products} categories={[]} />
      </NuqsTestingAdapter>,
    )

    expect(screen.getByRole('link', { name: 'iPhone 15' })).toHaveAttribute('href', '/products/2')

    await user.click(screen.getAllByRole('button', { name: '計測設定' })[1])

    expect(container.querySelector('.modal-toggle')).toBeChecked()
    expect(onUrlUpdate).toHaveBeenCalledWith(
      expect.objectContaining({ queryString: '?update_product_modal=true' }),
    )
    expect(
      within(screen.getByRole('group', { name: '管理コード' })).getByRole('textbox'),
    ).toHaveValue('iPhone 15')
    expect(screen.getByDisplayValue('iPhone 15 128GB')).toBeInTheDocument()
  })
})
