import { render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { beforeEach, describe, expect, it, vi } from 'vitest'

import {
  createProductCrawlSetting,
  getProductCrawlResults,
  setProductCrawlResultExcluded,
  updateProductCrawlSetting,
} from '@/features/product-monitoring/api/actions'
import type { ProductCrawlResult, ProductCrawlSetting } from '@/features/product-monitoring/api/types'
import ProductCrawlSettings from '@/features/product-monitoring/components/ProductCrawlSettings'

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

const mercariUrl = 'https://jp.mercari.com/search?keyword=phone'
const iosysUrl = 'https://iosys.co.jp/items?q=phone'
const setting: ProductCrawlSetting = {
  id: 1,
  name: 'phone',
  enabled: true,
  searchUrls: [mercariUrl],
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

describe('商品計測設定', () => {
  it('検索 URL と共通キーワードを一つの設定に保存し、各 URL のサイトを表示すること', async () => {
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
    await user.click(screen.getByRole('button', { name: 'URLを追加' }))
    const yahooUrl = 'https://paypayfleamarket.yahoo.co.jp/search/iPad%20Pro'
    await user.type(screen.getByRole('textbox', { name: '検索結果URL 3' }), yahooUrl)
    expect(screen.getByText('メルカリ')).toBeInTheDocument()
    expect(screen.getByText('イオシス')).toBeInTheDocument()
    expect(screen.getByText('Yahoo!フリマ')).toBeInTheDocument()
    await user.type(screen.getByRole('textbox', { name: /必須語/ }), 'phone, blue')
    await user.click(screen.getByRole('button', { name: '登録' }))
    await waitFor(() =>
      expect(createProductCrawlSetting).toHaveBeenCalledWith(
        expect.objectContaining({
          searchUrls: [mercariUrl, iosysUrl, yahooUrl],
          requiredKeywords: ['phone', 'blue'],
        }),
      ),
    )
    expect(refresh).toHaveBeenCalled()
    expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
  })

  it('設定を複製して追加モーダルを開き、新しい設定として保存すること', async () => {
    vi.mocked(createProductCrawlSetting).mockResolvedValue({
      data: { ...setting, id: 2 },
      error: null,
      status: 200,
    })
    const user = userEvent.setup()
    const source = {
      ...setting,
      searchUrls: [mercariUrl, iosysUrl],
      requiredKeywords: ['phone', 'blue'],
      excludeKeywords: ['junk'],
      minPrice: 1000,
      maxPrice: 5000,
    }
    render(<ProductCrawlSettings productCrawlSettings={[source]} />)
    await user.click(screen.getByRole('button', { name: '複製' }))
    expect(screen.getByRole('heading', { name: '商品計測設定を追加' })).toBeInTheDocument()
    expect(screen.getByRole('textbox', { name: '名前' })).toHaveValue('phone（コピー）')
    expect(getProductCrawlResults).not.toHaveBeenCalled()
    await user.click(screen.getByRole('button', { name: '登録' }))
    await waitFor(() =>
      expect(createProductCrawlSetting).toHaveBeenCalledWith(
        expect.objectContaining({
          name: 'phone（コピー）',
          enabled: true,
          searchUrls: [mercariUrl, iosysUrl],
          requiredKeywords: ['phone', 'blue'],
          excludeKeywords: ['junk'],
          minPrice: 1000,
          maxPrice: 5000,
        }),
      ),
    )
    expect(updateProductCrawlSetting).not.toHaveBeenCalled()
    expect(refresh).toHaveBeenCalled()
  })

  it('複製した名前を255文字以内に収めること', async () => {
    const user = userEvent.setup()
    render(<ProductCrawlSettings productCrawlSettings={[{ ...setting, name: 'a'.repeat(255) }]} />)
    await user.click(screen.getByRole('button', { name: '複製' }))
    expect(screen.getByRole('textbox', { name: '名前' })).toHaveValue(`${'a'.repeat(250)}（コピー）`)
  })

  it('除外した出品をリンク付きで一覧表示し、その場で復元すること', async () => {
    const user = userEvent.setup()
    vi.mocked(setProductCrawlResultExcluded).mockResolvedValue({
      data: { ...result, id: 2 },
      error: null,
      status: 200,
    })
    vi.mocked(getProductCrawlResults).mockResolvedValue({
      data: {
        productCrawlResults: [1, 2, 3].map((id) => ({
          ...result,
          id,
          externalId: `item-${id}`,
          name: `Phone ${id}`,
          excludedAt: '2026-11-06T00:00:00+09:00',
        })),
      },
      error: null,
      status: 200,
    })
    render(<ProductCrawlSettings productCrawlSettings={[setting]} />)
    await user.click(screen.getByRole('button', { name: '編集' }))
    expect(getProductCrawlResults).toHaveBeenCalledWith({
      productCrawlSettingId: 1,
      excluded: true,
    })
    await user.click(await screen.findByText('除外した出品（3件）'))
    expect(screen.getByRole('link', { name: 'Phone 2' })).toHaveAttribute('href', result.productUrl)
    await user.click(screen.getByRole('button', { name: 'Phone 2の除外を取り消す' }))
    await waitFor(() => expect(setProductCrawlResultExcluded).toHaveBeenCalledWith(2, false))
    expect(screen.getByText('除外した出品（2件）')).toBeInTheDocument()
    expect(refresh).toHaveBeenCalled()
  })
})
