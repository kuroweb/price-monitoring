import { render, screen, waitFor, within } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { beforeEach, describe, expect, it, vi } from 'vitest'

import {
  createProductWatchSetting,
  destroyProductWatchSetting,
  setProductCrawlResultExcluded,
} from '@/features/product-monitoring/api/actions'
import type {
  ProductCrawlResult,
  ProductWatchSetting,
} from '@/features/product-monitoring/api/types'
import ProductWatchSettings from '@/features/product-monitoring/components/ProductWatchSettings'

const { refresh } = vi.hoisted(() => ({ refresh: vi.fn() }))
vi.mock('next/navigation', () => ({ useRouter: () => ({ refresh }) }))
vi.mock('react-toastify', () => ({ toast: { success: vi.fn(), error: vi.fn() } }))
vi.mock('@/features/product-monitoring/api/actions', () => ({
  createProductWatchSetting: vi.fn(),
  updateProductWatchSetting: vi.fn(),
  destroyProductWatchSetting: vi.fn(),
  setProductCrawlResultExcluded: vi.fn(),
}))

const setting: ProductWatchSetting = {
  id: 1,
  name: 'phone',
  enabled: true,
  discordEnabled: true,
  requiredKeywords: ['phone'],
  excludeKeywords: ['case'],
  minPrice: null,
  maxPrice: 1000,
}
const result: ProductCrawlResult = {
  id: 1,
  productCrawlSettingId: 1,
  platform: 'iosys',
  externalId: '1',
  name: 'phone listing',
  productUrl: 'https://iosys.co.jp/item/1',
  thumbnailUrl: null,
  price: 800,
  buyoutPrice: null,
  sold: false,
  boughtDate: null,
  endDate: null,
  excludedAt: null,
}

beforeEach(() => vi.clearAllMocks())

describe('商品モニタリング', () => {
  it('設定した条件と通知の指定を登録する', async () => {
    vi.mocked(createProductWatchSetting).mockResolvedValue({
      data: setting,
      error: null,
      status: 200,
    })
    const user = userEvent.setup()
    render(<ProductWatchSettings sections={[]} />)
    await user.click(screen.getByRole('button', { name: '商品モニタリング設定を追加' }))
    await user.type(screen.getByRole('textbox', { name: '名前' }), 'phone')
    await user.type(screen.getByRole('textbox', { name: /必須語/ }), 'phone')
    await user.type(screen.getByRole('textbox', { name: /除外語/ }), 'case')
    await user.type(screen.getByRole('spinbutton', { name: '最高価格（円）' }), '1000')
    await user.click(screen.getByRole('button', { name: '登録' }))
    await waitFor(() =>
      expect(createProductWatchSetting).toHaveBeenCalledWith({
        name: 'phone',
        enabled: true,
        discordEnabled: true,
        requiredKeywords: ['phone'],
        excludeKeywords: ['case'],
        minPrice: null,
        maxPrice: 1000,
      }),
    )
    expect(refresh).toHaveBeenCalled()
  })

  it('最安価格を表示し、確認後に設定を削除する', async () => {
    vi.spyOn(window, 'confirm').mockReturnValue(true)
    vi.mocked(destroyProductWatchSetting).mockResolvedValue({
      data: null,
      error: null,
      status: 200,
    })
    const user = userEvent.setup()
    render(
      <ProductWatchSettings
        sections={[{ setting, results: [result], daily: [] }]}
      />,
    )
    expect(screen.getAllByText('¥800')).toHaveLength(2)
    const menuButton = screen.getByRole('button', { name: 'phoneの操作' })
    await user.click(menuButton)
    await user.click(within(menuButton.parentElement!).getByRole('button', { name: '削除' }))
    await waitFor(() => expect(destroyProductWatchSetting).toHaveBeenCalledWith(1))
  })

  it('取得失敗と一致する商品がない場合を区別する', () => {
    const { rerender } = render(
      <ProductWatchSettings sections={[{ setting, results: null, daily: [] }]} />,
    )
    expect(screen.getByText('取得失敗')).toBeInTheDocument()
    rerender(<ProductWatchSettings sections={[{ setting, results: [], daily: [] }]} />)
    expect(screen.getByText('該当する出品なし')).toBeInTheDocument()
  })

  it('販売中の商品を価格順のプレビューで表示し、詳細へ移動できる', () => {
    const second = { ...result, id: 2, name: 'phone second', price: 900 }
    render(<ProductWatchSettings sections={[{ setting, results: [result, second], daily: [] }]} />)
    const items = within(screen.getByRole('list', { name: '販売中の商品を価格順に表示' })).getAllByRole('listitem').filter((item) => item.querySelector('a'))
    expect(items[0]).toHaveTextContent('phone listing')
    expect(items[1]).toHaveTextContent('phone second')
    expect(screen.getByRole('link', { name: 'phone' })).toHaveAttribute('href', '/product-monitoring/1')
  })

  it('商品画像の操作メニューから除外できる', async () => {
    vi.spyOn(window, 'confirm').mockReturnValue(true)
    vi.mocked(setProductCrawlResultExcluded).mockResolvedValue({ data: result, error: null, status: 200 })
    const user = userEvent.setup()
    render(<ProductWatchSettings sections={[{ setting, results: [result], daily: [] }]} />)
    await user.click(screen.getByRole('button', { name: 'phone listingの操作' }))
    await user.click(screen.getByRole('button', { name: '除外' }))
    await waitFor(() => expect(setProductCrawlResultExcluded).toHaveBeenCalledWith(result.id, true))
    expect(refresh).toHaveBeenCalled()
  })

   it('既存の条件を引き継いで新しい設定を複製する', async () => {
    vi.mocked(createProductWatchSetting).mockResolvedValue({ data: setting, error: null, status: 200 })
    const user = userEvent.setup()
    render(<ProductWatchSettings sections={[{ setting, results: [], daily: [] }]} />)
    await user.click(screen.getByRole('button', { name: 'phoneの操作' }))
    await user.click(screen.getByRole('button', { name: '複製' }))
    expect(screen.getByRole('textbox', { name: '名前' })).toHaveValue('phone（コピー）')
    expect(screen.getByRole('textbox', { name: /必須語/ })).toHaveValue('phone')
    await user.click(screen.getByRole('button', { name: '登録' }))
    await waitFor(() => expect(createProductWatchSetting).toHaveBeenCalledWith(expect.objectContaining({
      name: 'phone（コピー）', requiredKeywords: ['phone'], excludeKeywords: ['case'], maxPrice: 1000,
    })))
  })
})
