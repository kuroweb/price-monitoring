import { render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { beforeEach, describe, expect, it, vi } from 'vitest'

import { setCrawlResultExcluded } from '@/features/product-monitoring/api/actions'
import type { CrawlResult, Monitor } from '@/features/product-monitoring/api/types'
import MonitorDetail from '@/features/product-monitoring/components/MonitorDetail'

const { refresh, toastError } = vi.hoisted(() => ({ refresh: vi.fn(), toastError: vi.fn() }))
vi.mock('next/navigation', () => ({ useRouter: () => ({ refresh }) }))
vi.mock('react-toastify', () => ({ toast: { error: toastError, success: vi.fn() } }))
vi.mock('@/features/product-monitoring/api/actions', () => ({
  setCrawlResultExcluded: vi.fn(),
}))
vi.mock('@/features/product-monitoring/components/MonitorFormModal', () => ({
  default: ({ onClose }: { onClose: () => void }) => <button onClick={onClose}>編集を閉じる</button>,
}))
vi.mock('@/features/product-monitoring/components/DailyMarketPriceSection', () => ({
  default: () => <div>相場グラフ</div>,
}))

const monitor: Monitor = {
  id: 1,
  name: 'iPad',
  enabled: false,
  discordEnabled: false,
  newestNotificationEnabled: false,
  requiredKeywords: ['iPad'],
  negativeKeywords: ['ケース'],
  minPrice: 10000,
  maxPrice: null,
}
const listing: CrawlResult = {
  id: 7, crawlSettingId: 1, platform: 'iosys', externalId: 'listing-1',
  name: 'iPad 128GB', productUrl: 'https://example.com/item', thumbnailUrl: null,
  price: 30000, buyoutPrice: null, sold: false, soldAt: null, endsAt: null, excludedAt: null,
}

beforeEach(() => vi.clearAllMocks())

describe('商品モニタリング詳細', () => {
  it('通知評価が停止中でも条件と相場を表示し、編集を開ける', async () => {
    render(<MonitorDetail monitor={monitor} crawlResults={[]} dailyMarketPrices={[]} transactions={[]} discordConfigured={false} />)

    expect(screen.getByRole('heading', { name: 'iPad' })).toBeInTheDocument()
    expect(screen.getByText('最安値の通知評価：停止中')).toBeInTheDocument()
    expect(screen.getByText('新着の通知評価：停止中')).toBeInTheDocument()
    expect(screen.getByText('条件に一致する収集結果はありません。')).toBeInTheDocument()
    expect(screen.getByText('ケース')).toBeInTheDocument()
    expect(screen.getByText('相場グラフ')).toBeInTheDocument()
    await userEvent.click(screen.getByRole('button', { name: '条件を編集' }))
    expect(screen.getByRole('button', { name: '編集を閉じる' })).toBeInTheDocument()
  })

  it('商品と相場の取得失敗を空データと区別する', () => {
    render(<MonitorDetail monitor={monitor} crawlResults={null} dailyMarketPrices={null} transactions={null} discordConfigured={false} />)

    expect(screen.getByText('収集結果を取得できませんでした。再読み込みしてください。')).toBeInTheDocument()
    expect(screen.getByText('日次相場を取得できませんでした。再読み込みしてください。')).toBeInTheDocument()
    expect(screen.queryByText('条件に一致する収集結果はありません。')).not.toBeInTheDocument()
  })

  it('新着通知だけが有効でも、送信先が使えないことを示す', () => {
    render(
      <MonitorDetail monitor={{ ...monitor, newestNotificationEnabled: true }} crawlResults={[]} dailyMarketPrices={[]}
        transactions={[]} discordConfigured={false} />,
    )

    expect(screen.getByText('新着の通知評価：有効')).toBeInTheDocument()
    expect(screen.getByText('Discord通知は利用できません。送信先を確認してください。')).toBeInTheDocument()
  })

  it('確認後に販売中の収集結果を除外し画面を更新する', async () => {
    vi.spyOn(window, 'confirm').mockReturnValueOnce(true)
    vi.mocked(setCrawlResultExcluded).mockResolvedValueOnce({ data: listing, status: 200, error: null })
    render(<MonitorDetail monitor={monitor} crawlResults={[listing]} dailyMarketPrices={[]} transactions={[]} discordConfigured={false} />)

    const user = userEvent.setup()
    await user.click(screen.getByRole('button', { name: 'iPad 128GBの操作' }))
    await user.click(screen.getByRole('button', { name: '除外' }))
    await waitFor(() => expect(setCrawlResultExcluded).toHaveBeenCalledWith(7, true))
    expect(refresh).toHaveBeenCalled()
  })

  it('販売状態と並びで、売れた日が古い売り切れ、売れた日が無い売り切れ、販売中、価格の前後を分ける', async () => {
    const newerOnSale = { ...listing, id: 2, name: '新しい販売中', price: 300, sold: false, soldAt: null }
    const unknown = { ...listing, id: 6, name: '状態不明', price: 250, sold: null, soldAt: null }
    const olderOnSale = { ...listing, id: 5, name: '古い販売中', price: 100, sold: false, soldAt: null }
    const oldSold = { ...listing, id: 4, name: '古い売り切れ', price: 100, sold: true, soldAt: '2026-01-01T00:00:00.000Z' }
    const undatedSold = { ...listing, id: 9, name: '日付なし売り切れ', price: 800, sold: true, soldAt: null }
    const user = userEvent.setup()
    render(
      <MonitorDetail
        monitor={monitor}
        crawlResults={[newerOnSale, unknown, olderOnSale, oldSold, undatedSold]}
        dailyMarketPrices={[]}
        transactions={[]}
        discordConfigured={false}
      />,
    )

    const expectOrder = (...expected: string[]) => {
      const articles = screen.getAllByRole('article')
      expect(articles).toHaveLength(expected.length)
      expected.forEach((name, index) => expect(articles[index]).toHaveTextContent(name))
    }

    expect(screen.getByRole('button', { name: /^すべて/ })).toHaveTextContent('5')
    expect(screen.getByRole('button', { name: /^販売中/ })).toHaveTextContent('3')
    expect(screen.getByRole('button', { name: /^売り切れ/ })).toHaveTextContent('2')
    expectOrder('新しい販売中', '状態不明', '古い販売中', '古い売り切れ', '日付なし売り切れ')

    await user.click(screen.getByRole('button', { name: /^販売中/ }))
    expectOrder('新しい販売中', '状態不明', '古い販売中')
    expect(screen.queryByText('古い売り切れ')).not.toBeInTheDocument()
    expect(screen.queryByText('日付なし売り切れ')).not.toBeInTheDocument()

    await user.click(screen.getByRole('button', { name: /^売り切れ/ }))
    expectOrder('古い売り切れ', '日付なし売り切れ')

    await user.selectOptions(screen.getByRole('combobox', { name: '並び順' }), 'price_desc')
    expectOrder('日付なし売り切れ', '古い売り切れ')

    await user.click(screen.getByRole('button', { name: /^すべて/ }))
    expectOrder('日付なし売り切れ', '新しい販売中', '状態不明', '古い販売中', '古い売り切れ')

    await user.selectOptions(screen.getByRole('combobox', { name: '並び順' }), 'price_asc')
    expectOrder('古い販売中', '古い売り切れ', '状態不明', '新しい販売中', '日付なし売り切れ')

    await user.selectOptions(screen.getByRole('combobox', { name: '並び順' }), 'newest')
    expectOrder('新しい販売中', '状態不明', '古い販売中', '古い売り切れ', '日付なし売り切れ')
  })

  it('除外に失敗した場合はエラーを示し画面を更新しない', async () => {
    vi.spyOn(window, 'confirm').mockReturnValueOnce(true)
    vi.mocked(setCrawlResultExcluded).mockResolvedValueOnce({ data: null, status: 500, error: null })
    render(<MonitorDetail monitor={monitor} crawlResults={[listing]} dailyMarketPrices={[]} transactions={[]} discordConfigured={false} />)

    const user = userEvent.setup()
    await user.click(screen.getByRole('button', { name: 'iPad 128GBの操作' }))
    await user.click(screen.getByRole('button', { name: '除外' }))
    await waitFor(() => expect(toastError).toHaveBeenCalledWith('除外に失敗しました'))
    expect(refresh).not.toHaveBeenCalled()
  })
})
