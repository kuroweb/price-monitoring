import { render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { beforeEach, describe, expect, it, vi } from 'vitest'

import {
  createProductWatchSetting,
  destroyProductWatchSetting,
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
  name: 'phone',
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

  it('保存済みの最安商品とWebhook未設定を表示し、確認後に設定を削除する', async () => {
    vi.spyOn(window, 'confirm').mockReturnValue(true)
    vi.mocked(destroyProductWatchSetting).mockResolvedValue({
      data: null,
      error: null,
      status: 200,
    })
    const user = userEvent.setup()
    render(
      <ProductWatchSettings
        sections={[{ setting, results: [result] }]}
      />,
    )
    expect(screen.getByText('¥800')).toBeInTheDocument()
    await user.click(screen.getByRole('button', { name: 'phoneの操作' }))
    await user.click(screen.getByRole('button', { name: '削除' }))
    await waitFor(() => expect(destroyProductWatchSetting).toHaveBeenCalledWith(1))
  })

  it('取得失敗と一致する商品がない場合を区別する', () => {
    const { rerender } = render(
      <ProductWatchSettings sections={[{ setting, results: null }]} />,
    )
    expect(screen.getByText(/商品を取得できませんでした/)).toBeInTheDocument()
    rerender(<ProductWatchSettings sections={[{ setting, results: [] }]} />)
    expect(screen.getByText('条件に一致する販売中の商品はありません。')).toBeInTheDocument()
  })

  it('既存の条件を引き継いで新しい設定を複製する', async () => {
    vi.mocked(createProductWatchSetting).mockResolvedValue({ data: setting, error: null, status: 200 })
    const user = userEvent.setup()
    render(<ProductWatchSettings sections={[{ setting, results: [] }]} />)
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
