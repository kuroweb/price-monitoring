import { render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { beforeEach, describe, expect, it, vi } from 'vitest'

import ProductCrawlSettings from '@/features/admin/product-crawl-settings/components/ProductCrawlSettings'
import ProductCrawlResultsSection from '@/features/product-crawl-results/components/ProductCrawlResultsSection'
import {
  createProductCrawlSetting,
  excludeProductCrawlResult,
  previewProductCrawlSetting,
  syncProductCrawlSetting,
  updateProductCrawlSetting,
} from '@/lib/actions'
import type { ProductCrawlResult, ProductCrawlSetting } from '@/lib/api'

const { refresh } = vi.hoisted(() => ({ refresh: vi.fn() }))
vi.mock('next/navigation', () => ({ useRouter: () => ({ refresh }) }))
vi.mock('react-toastify', () => ({ toast: { success: vi.fn(), error: vi.fn() } }))
vi.mock('@/lib/actions', () => ({
  createProductCrawlSetting: vi.fn(),
  updateProductCrawlSetting: vi.fn(),
  destroyProductCrawlSetting: vi.fn(),
  previewProductCrawlSetting: vi.fn(),
  syncProductCrawlSetting: vi.fn(),
  excludeProductCrawlResult: vi.fn(),
}))

const mercariUrl = 'https://jp.mercari.com/search?keyword=phone'
const iosysUrl = 'https://iosys.co.jp/items?q=phone'
const setting: ProductCrawlSetting = {
  id: 1,
  name: 'phone',
  enabled: true,
  searchUrls: [mercariUrl],
  requiredKeywords: [],
  excludeKeywords: [],
  excludeExternalIds: [],
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
}

beforeEach(() => vi.clearAllMocks())

describe('商品計測設定', () => {
  it('saves search URLs and shared keywords in one setting and shows each URL site', async () => {
    vi.mocked(createProductCrawlSetting).mockResolvedValue({
      data: setting,
      error: null,
      status: 200,
    })
    const user = userEvent.setup()
    render(<ProductCrawlSettings productCrawlSettings={[]} />)
    await user.click(screen.getByRole('button', { name: '商品計測設定を追加' }))
    await user.type(screen.getByRole('textbox', { name: '名前' }), 'phone')
    await user.type(screen.getByRole('textbox', { name: '検索結果URL 1' }), mercariUrl)
    await user.click(screen.getByRole('button', { name: 'URLを追加' }))
    await user.type(screen.getByRole('textbox', { name: '検索結果URL 2' }), iosysUrl)
    expect(screen.getByText('メルカリ')).toBeInTheDocument()
    expect(screen.getByText('イオシス')).toBeInTheDocument()
    await user.type(screen.getByRole('textbox', { name: /必須語/ }), 'phone, blue')
    await user.click(screen.getByRole('button', { name: '登録' }))
    await waitFor(() =>
      expect(createProductCrawlSetting).toHaveBeenCalledWith(
        expect.objectContaining({
          searchUrls: [mercariUrl, iosysUrl],
          requiredKeywords: ['phone', 'blue'],
        }),
      ),
    )
    expect(refresh).toHaveBeenCalled()
    expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
  })

  it('keeps the preview while excluding a listing and saves the exclusion', async () => {
    vi.mocked(previewProductCrawlSetting).mockResolvedValue({
      data: {
        sources: [
          {
            url: mercariUrl,
            platform: 'mercari',
            status: 'failed',
            error: 'Crawl failed',
            fetchedCount: 0,
          },
        ],
        results: [
          {
            platform: 'iosys',
            externalId: 'item-1',
            name: 'Phone blue',
            price: 1200,
            productUrl: 'https://iosys.co.jp/items/item-1',
            accepted: true,
            reasons: [],
          },
        ],
        fetchedCount: 1,
        acceptedCount: 1,
      },
      error: null,
      status: 200,
    })
    vi.mocked(updateProductCrawlSetting).mockResolvedValue({
      data: setting,
      error: null,
      status: 200,
    })
    const user = userEvent.setup()
    render(<ProductCrawlSettings productCrawlSettings={[setting]} />)
    await user.click(screen.getByRole('button', { name: '編集' }))
    await user.click(screen.getByRole('button', { name: '実際に取得して確認' }))
    expect(await screen.findByText(/取得失敗/)).toBeInTheDocument()
    await user.click(screen.getByRole('button', { name: '出品 item-1 を除外' }))
    expect(screen.getByRole('region', { name: '取得結果' })).toBeInTheDocument()
    await user.click(screen.getByRole('button', { name: '更新' }))
    await waitFor(() =>
      expect(updateProductCrawlSetting).toHaveBeenCalledWith(
        1,
        expect.objectContaining({ excludeExternalIds: ['item-1'] }),
      ),
    )
  })
})

describe('商品計測結果', () => {
  it('syncs saved settings and excludes a saved result', async () => {
    vi.spyOn(window, 'confirm').mockReturnValue(true)
    vi.mocked(syncProductCrawlSetting).mockResolvedValue({
      data: { sources: [], results: [], fetchedCount: 0, acceptedCount: 0 },
      error: null,
      status: 200,
    })
    vi.mocked(excludeProductCrawlResult).mockResolvedValue({
      data: setting,
      error: null,
      status: 200,
    })
    const user = userEvent.setup()
    render(
      <ProductCrawlResultsSection productCrawlSetting={setting} productCrawlResults={[result]} />,
    )
    expect(screen.getByRole('link', { name: 'Phone blueの商品ページを開く' })).toHaveAttribute(
      'href',
      result.productUrl,
    )
    expect(screen.getByText('イオシス')).toBeInTheDocument()
    expect(screen.getByText('売り切れ')).toBeInTheDocument()
    await user.click(screen.getByRole('button', { name: '取得して保存' }))
    await waitFor(() => expect(syncProductCrawlSetting).toHaveBeenCalledWith(1))
    await user.click(screen.getByRole('button', { name: '除外' }))
    await waitFor(() => expect(excludeProductCrawlResult).toHaveBeenCalledWith(1, 'item-1'))
    expect(refresh).toHaveBeenCalledTimes(2)
  })
})
