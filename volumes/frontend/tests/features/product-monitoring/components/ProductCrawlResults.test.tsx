import { render, screen, waitFor, within } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { toast } from 'react-toastify'
import { beforeEach, describe, expect, it, vi } from 'vitest'

import {
  getProductCrawlResults,
  setProductCrawlResultExcluded,
  syncProductCrawlSetting,
} from '@/features/product-monitoring/api/actions'
import type { ProductCrawlResult, ProductCrawlSetting } from '@/features/product-monitoring/api/types'
import ProductCrawlResultsDetail from '@/features/product-monitoring/components/ProductCrawlResultsDetail'
import ProductCrawlResultsSection from '@/features/product-monitoring/components/ProductCrawlResultsSection'

const { refresh } = vi.hoisted(() => ({ refresh: vi.fn() }))
vi.mock('next/navigation', () => ({ useRouter: () => ({ refresh }) }))
vi.mock('react-toastify', () => ({ toast: { success: vi.fn(), error: vi.fn() } }))
vi.mock('@/features/product-monitoring/api/actions', () => ({
  createProductCrawlSetting: vi.fn(),
  updateProductCrawlSetting: vi.fn(),
  destroyProductCrawlSetting: vi.fn(),
  syncProductCrawlSetting: vi.fn(),
  setProductCrawlResultExcluded: vi.fn(),
  getProductCrawlResults: vi.fn(),
}))

const setting: ProductCrawlSetting = {
  id: 1,
  name: 'phone',
  enabled: true,
  searchUrls: ['https://jp.mercari.com/search?keyword=phone'],
  requiredKeywords: [],
  excludeKeywords: [],
  minPrice: null,
  maxPrice: null,
}
const result: ProductCrawlResult = {
  id: 10,
  productCrawlSettingId: 1,
  platform: 'iosys',
  externalId: 'item-1',
  name: 'Phone blue',
  productUrl: 'https://iosys.co.jp/items/item-1',
  thumbnailUrl: null,
  price: 1200,
  buyoutPrice: null,
  sold: true,
  boughtDate: null,
  endDate: null,
  excludedAt: null,
}

beforeEach(() => {
  vi.clearAllMocks()
  vi.mocked(getProductCrawlResults).mockResolvedValue({
    data: { productCrawlResults: [] },
    error: null,
    status: 200,
  })
})

describe('商品計測結果', () => {
  it('syncs saved settings and excludes a saved result', async () => {
    vi.spyOn(window, 'confirm').mockReturnValue(true)
    vi.mocked(syncProductCrawlSetting).mockResolvedValue({
      data: {},
      error: null,
      status: 202,
    })
    vi.mocked(setProductCrawlResultExcluded).mockResolvedValue({
      data: result,
      error: null,
      status: 200,
    })
    const user = userEvent.setup()
    render(
      <ProductCrawlResultsDetail productCrawlSetting={setting} productCrawlResults={[result]} />,
    )
    expect(screen.getByRole('link', { name: 'Phone blueの商品ページを開く' })).toHaveAttribute(
      'href',
      result.productUrl,
    )
    expect(screen.getByText('イオシス')).toBeInTheDocument()
    const card = screen.getByRole('article')
    expect(within(card).getByText('売り切れ')).toBeInTheDocument()
    await user.click(screen.getByRole('button', { name: /^販売中/ }))
    expect(screen.queryByRole('article')).not.toBeInTheDocument()
    await user.click(screen.getByRole('button', { name: /^すべて/ }))
    await user.click(screen.getByRole('button', { name: '取得して保存' }))
    await waitFor(() => expect(syncProductCrawlSetting).toHaveBeenCalledWith(1))
    expect(toast.success).toHaveBeenCalledWith('取得を開始しました。しばらくしてから再読み込みしてください')
    await user.click(screen.getByRole('button', { name: '除外' }))
    await waitFor(() => expect(setProductCrawlResultExcluded).toHaveBeenCalledWith(10, true))
    expect(refresh).toHaveBeenCalledTimes(1)
  })
})

describe('商品計測結果の一覧', () => {
  it('shows only the newest listings, excludes one and links to the detail page', async () => {
    vi.spyOn(window, 'confirm').mockReturnValue(true)
    vi.mocked(setProductCrawlResultExcluded).mockResolvedValue({
      data: result,
      error: null,
      status: 200,
    })
    const user = userEvent.setup()
    const results = Array.from({ length: 10 }, (_, i) => ({
      ...result,
      id: i + 1,
      externalId: `item-${i + 1}`,
      name: `Phone ${i + 1}`,
    }))
    render(
      <ProductCrawlResultsSection productCrawlSetting={setting} productCrawlResults={results.slice(0, 8)} counts={[{ sold: true, count: 10 }]} />,
    )
    expect(screen.getAllByRole('article')).toHaveLength(8)
    expect(screen.getAllByRole('button', { name: /の操作$/ })).toHaveLength(8)
    expect(screen.getByRole('link', { name: /すべて見る/ })).toHaveAttribute(
      'href',
      '/product-crawl-results/1',
    )
    expect(screen.getByText('10件・販売中 0・売り切れ 10')).toBeInTheDocument()
    await user.click(screen.getByRole('button', { name: '設定を編集' }))
    expect(screen.getByRole('dialog')).toHaveTextContent('商品計測設定を更新')
    expect(screen.getByRole('textbox', { name: '名前' })).toHaveValue('phone')
    await user.click(screen.getByRole('button', { name: '閉じる' }))
    expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
    await user.click(screen.getAllByRole('button', { name: '除外' })[0])
    await waitFor(() => expect(setProductCrawlResultExcluded).toHaveBeenCalledWith(1, true))
    expect(refresh).toHaveBeenCalled()
  })
})
