import { render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { beforeEach, describe, expect, it, vi } from 'vitest'

import { setProductCrawlResultExcluded } from '@/features/product-monitoring/api/actions'
import type { ProductCrawlResult, ProductWatchSetting } from '@/features/product-monitoring/api/types'
import ProductWatchDetail from '@/features/product-monitoring/components/ProductWatchDetail'

const { refresh, toastError } = vi.hoisted(() => ({ refresh: vi.fn(), toastError: vi.fn() }))
vi.mock('next/navigation', () => ({ useRouter: () => ({ refresh }) }))
vi.mock('react-toastify', () => ({ toast: { error: toastError, success: vi.fn() } }))
vi.mock('@/features/product-monitoring/api/actions', () => ({
  setProductCrawlResultExcluded: vi.fn(),
}))
vi.mock('@/features/product-monitoring/components/ProductWatchSettingFormModal', () => ({
  default: ({ onClose }: { onClose: () => void }) => <button onClick={onClose}>編集を閉じる</button>,
}))
vi.mock('@/features/product-monitoring/components/ProductAggregationResultsSection', () => ({
  default: () => <div>相場グラフ</div>,
}))

const setting: ProductWatchSetting = {
  id: 1,
  name: 'iPad',
  enabled: false,
  discordEnabled: false,
  requiredKeywords: ['iPad'],
  excludeKeywords: ['ケース'],
  minPrice: 10000,
  maxPrice: null,
}
const listing: ProductCrawlResult = {
  id: 7, productCrawlSettingId: 1, platform: 'iosys', externalId: 'listing-1',
  name: 'iPad 128GB', productUrl: 'https://example.com/item', thumbnailUrl: null,
  price: 30000, buyoutPrice: null, sold: false, boughtDate: null, endDate: null, excludedAt: null,
}

beforeEach(() => vi.clearAllMocks())

describe('商品モニタリング詳細', () => {
  it('通知評価が停止中でも条件と相場を表示し、編集を開ける', async () => {
    render(<ProductWatchDetail setting={setting} results={[]} daily={[]} purchases={[]} discordConfigured={false} />)

    expect(screen.getByRole('heading', { name: 'iPad' })).toBeInTheDocument()
    expect(screen.getByText('最安値の通知評価：停止中')).toBeInTheDocument()
    expect(screen.getByText('ケース')).toBeInTheDocument()
    expect(screen.getByText('相場グラフ')).toBeInTheDocument()
    await userEvent.click(screen.getByRole('button', { name: '条件を編集' }))
    expect(screen.getByRole('button', { name: '編集を閉じる' })).toBeInTheDocument()
  })

  it('商品と相場の取得失敗を空データと区別する', () => {
    render(<ProductWatchDetail setting={setting} results={null} daily={null} purchases={null} discordConfigured={false} />)

    expect(screen.getByText('商品を取得できませんでした。再読み込みしてください。')).toBeInTheDocument()
    expect(screen.getByText('商品相場を取得できませんでした。再読み込みしてください。')).toBeInTheDocument()
    expect(screen.queryByText('条件に一致する販売中の商品はありません。')).not.toBeInTheDocument()
  })

  it('確認後に販売中の商品を除外し画面を更新する', async () => {
    vi.spyOn(window, 'confirm').mockReturnValueOnce(true)
    vi.mocked(setProductCrawlResultExcluded).mockResolvedValueOnce({ data: listing, status: 200, error: null })
    render(<ProductWatchDetail setting={setting} results={[listing]} daily={[]} purchases={[]} discordConfigured={false} />)

    const user = userEvent.setup()
    await user.click(screen.getByRole('button', { name: 'iPad 128GBの操作' }))
    await user.click(screen.getByRole('button', { name: '除外' }))
    await waitFor(() => expect(setProductCrawlResultExcluded).toHaveBeenCalledWith(7, true))
    expect(refresh).toHaveBeenCalled()
  })

  it('除外に失敗した場合はエラーを示し画面を更新しない', async () => {
    vi.spyOn(window, 'confirm').mockReturnValueOnce(true)
    vi.mocked(setProductCrawlResultExcluded).mockResolvedValueOnce({ data: null, status: 500, error: null })
    render(<ProductWatchDetail setting={setting} results={[listing]} daily={[]} purchases={[]} discordConfigured={false} />)

    const user = userEvent.setup()
    await user.click(screen.getByRole('button', { name: 'iPad 128GBの操作' }))
    await user.click(screen.getByRole('button', { name: '除外' }))
    await waitFor(() => expect(toastError).toHaveBeenCalledWith('除外に失敗しました'))
    expect(refresh).not.toHaveBeenCalled()
  })
})
