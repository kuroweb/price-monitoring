import { act, render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { beforeEach, describe, expect, it, vi } from 'vitest'

import { getMonitorCrawlResults, setCrawlResultExcluded } from '@/features/product-monitoring/api/actions'
import type { CrawlResult, Monitor } from '@/features/product-monitoring/api/types'
import MonitorDetail from '@/features/product-monitoring/components/MonitorDetail'

const { refresh, toastError } = vi.hoisted(() => ({ refresh: vi.fn(), toastError: vi.fn() }))
vi.mock('next/navigation', () => ({ useRouter: () => ({ refresh }) }))
vi.mock('react-toastify', () => ({ toast: { error: toastError, success: vi.fn() } }))
vi.mock('@/features/product-monitoring/api/actions', () => ({
  setCrawlResultExcluded: vi.fn(),
  getMonitorCrawlResults: vi.fn(),
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
    render(<MonitorDetail monitor={monitor} crawlResults={[]} hasMore={false} dailyMarketPrices={[]} transactions={[]} discordConfigured={false} />)

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
    render(<MonitorDetail monitor={monitor} crawlResults={null} hasMore={false} dailyMarketPrices={null} transactions={null} discordConfigured={false} />)

    expect(screen.getByText('収集結果を取得できませんでした。再読み込みしてください。')).toBeInTheDocument()
    expect(screen.getByText('日次相場を取得できませんでした。再読み込みしてください。')).toBeInTheDocument()
    expect(screen.queryByText('条件に一致する収集結果はありません。')).not.toBeInTheDocument()
  })

  it('新着通知だけが有効でも、送信先が使えないことを示す', () => {
    render(
      <MonitorDetail monitor={{ ...monitor, newestNotificationEnabled: true }} crawlResults={[]} hasMore={false}
        dailyMarketPrices={[]} transactions={[]} discordConfigured={false} />,
    )

    expect(screen.getByText('新着の通知評価：有効')).toBeInTheDocument()
    expect(screen.getByText('Discord通知は利用できません。送信先を確認してください。')).toBeInTheDocument()
  })

  it('確認後に販売中の収集結果を除外し画面を更新する', async () => {
    vi.spyOn(window, 'confirm').mockReturnValueOnce(true)
    vi.mocked(setCrawlResultExcluded).mockResolvedValueOnce({ data: listing, status: 200, error: null })
    render(<MonitorDetail monitor={monitor} crawlResults={[listing]} hasMore={false} dailyMarketPrices={[]} transactions={[]} discordConfigured={false} />)

    const user = userEvent.setup()
    await user.click(screen.getByRole('button', { name: 'iPad 128GBの操作' }))
    await user.click(screen.getByRole('button', { name: '除外' }))
    await waitFor(() => expect(setCrawlResultExcluded).toHaveBeenCalledWith(7, true))
    expect(refresh).toHaveBeenCalled()
  })

  it('もっと見るで続きを足し、販売状態と並びを変えると先頭から取り直す', async () => {
    const result = (
      items: CrawlResult[],
      hasMore: boolean,
      cursor: { id: number; recencyAt?: string | null; price?: number } | null,
    ) => ({
      data: { crawlResults: items, perPage: 6, hasMore, cursor }, status: 200 as const, error: null,
    })
    const first = { ...listing, id: 1, name: '先頭' }
    const firstCursor = { id: 1, recencyAt: '2026-11-20T09:00:00.000+09:00' }
    const more = { ...listing, id: 2, name: '続き' }
    const soldFirst = { ...listing, id: 3, name: '売り切れの先頭', sold: true }
    const soldCursor = { id: 3, recencyAt: '2026-11-22T09:00:00.000+09:00' }
    const soldMore = { ...listing, id: 4, name: '売り切れの続き', sold: true }
    const pricey = { ...listing, id: 5, name: '高い順の先頭', price: 90_000, sold: true }
    vi.mocked(getMonitorCrawlResults)
      .mockResolvedValueOnce(result([more], false, { id: 2, recencyAt: '2026-11-21T09:00:00.000+09:00' }))
      .mockResolvedValueOnce(result([soldFirst], true, soldCursor))
      .mockResolvedValueOnce(result([soldMore], false, { id: 4, recencyAt: null }))
      .mockResolvedValueOnce(result([pricey], false, { id: 5, price: 90_000 }))
    const user = userEvent.setup()
    render(
      <MonitorDetail monitor={monitor} crawlResults={[first]} hasMore cursor={firstCursor}
        dailyMarketPrices={[]} transactions={[]} discordConfigured={false} />,
    )

    expect(screen.getByText('先頭')).toBeInTheDocument()
    expect(getMonitorCrawlResults).not.toHaveBeenCalled()

    await user.click(screen.getByRole('button', { name: 'もっと見る' }))
    await waitFor(() => expect(screen.getByText('続き')).toBeInTheDocument())
    expect(screen.getByText('先頭')).toBeInTheDocument()
    expect(getMonitorCrawlResults).toHaveBeenLastCalledWith(1, {
      saleStatus: 'all', sort: 'newest', cursor: firstCursor,
    })

    await user.click(screen.getByRole('button', { name: '売り切れ' }))
    await waitFor(() => expect(screen.getByText('売り切れの先頭')).toBeInTheDocument())
    expect(screen.queryByText('先頭')).not.toBeInTheDocument()
    expect(screen.queryByText('続き')).not.toBeInTheDocument()
    expect(getMonitorCrawlResults).toHaveBeenLastCalledWith(1, { saleStatus: 'sold', sort: 'newest' })

    await user.click(screen.getByRole('button', { name: 'もっと見る' }))
    await waitFor(() => expect(screen.getByText('売り切れの続き')).toBeInTheDocument())
    expect(screen.getByText('売り切れの先頭')).toBeInTheDocument()
    expect(getMonitorCrawlResults).toHaveBeenLastCalledWith(1, {
      saleStatus: 'sold', sort: 'newest', cursor: soldCursor,
    })

    await user.selectOptions(screen.getByRole('combobox', { name: '並び順' }), 'price_desc')
    await waitFor(() => expect(screen.getByText('高い順の先頭')).toBeInTheDocument())
    expect(screen.queryByText('売り切れの先頭')).not.toBeInTheDocument()
    expect(screen.queryByText('売り切れの続き')).not.toBeInTheDocument()
    expect(getMonitorCrawlResults).toHaveBeenLastCalledWith(1, { saleStatus: 'sold', sort: 'price_desc' })
  })

  it('もっと見るは画面にある id を足さない', async () => {
    const first = { ...listing, id: 1, name: '先頭' }
    const more = { ...listing, id: 2, name: '続き' }
    vi.mocked(getMonitorCrawlResults).mockResolvedValueOnce({
      data: {
        crawlResults: [first, more],
        perPage: 6,
        hasMore: false,
        cursor: { id: 2, recencyAt: '2026-11-21T09:00:00.000+09:00' },
      },
      status: 200,
      error: null,
    })
    const user = userEvent.setup()
    render(
      <MonitorDetail monitor={monitor} crawlResults={[first]} hasMore
        cursor={{ id: 1, recencyAt: '2026-11-20T09:00:00.000+09:00' }}
        dailyMarketPrices={[]} transactions={[]} discordConfigured={false} />,
    )

    await user.click(screen.getByRole('button', { name: 'もっと見る' }))
    await waitFor(() => expect(screen.getByText('続き')).toBeInTheDocument())
    expect(screen.getAllByText('先頭')).toHaveLength(1)
  })

  it.each(['response', 'exception'])('もっと見るが失敗しても同じカーソルで再試行できる: %s', async (failure) => {
    const cursor = { id: listing.id, recencyAt: '2026-11-20T09:00:00.000+09:00' }
    const more = { ...listing, id: 8, name: '続き' }
    if (failure === 'exception') {
      vi.mocked(getMonitorCrawlResults).mockRejectedValueOnce(new Error('network'))
    } else {
      vi.mocked(getMonitorCrawlResults).mockResolvedValueOnce({ data: null, status: 500, error: null })
  }
  vi.mocked(getMonitorCrawlResults).mockResolvedValueOnce({
      data: {
        crawlResults: [more],
        perPage: 6,
        hasMore: false,
        cursor: { id: more.id, recencyAt: '2026-11-21T09:00:00.000+09:00' },
      },
      status: 200,
      error: null,
    })
    const user = userEvent.setup()
    render(
      <MonitorDetail monitor={monitor} crawlResults={[listing]} hasMore cursor={cursor}
        dailyMarketPrices={[]} transactions={[]} discordConfigured={false} />,
    )

    await user.click(screen.getByRole('button', { name: 'もっと見る' }))
    await waitFor(() => {
      expect(screen.getByRole('alert')).toHaveTextContent('収集結果を取得できませんでした。もう一度試してください。')
    })
    expect(screen.getByRole('button', { name: 'もっと見る' })).toBeEnabled()
    expect(screen.getByText('iPad 128GB')).toBeInTheDocument()

    await user.click(screen.getByRole('button', { name: 'もっと見る' }))
    await waitFor(() => expect(screen.getByText('続き')).toBeInTheDocument())
    expect(getMonitorCrawlResults).toHaveBeenNthCalledWith(1, 1, { saleStatus: 'all', sort: 'newest', cursor })
    expect(getMonitorCrawlResults).toHaveBeenNthCalledWith(2, 1, { saleStatus: 'all', sort: 'newest', cursor })
  })

  it('再読み込み後に古い続きの応答が戻っても更新済みの表示を保つ', async () => {
    let resolve!: (value: Awaited<ReturnType<typeof getMonitorCrawlResults>>) => void
    vi.mocked(getMonitorCrawlResults).mockReturnValueOnce(new Promise((done) => { resolve = done }))
    const props = {
      monitor, crawlResults: [listing], hasMore: true,
      cursor: { id: listing.id, recencyAt: null },
      dailyMarketPrices: [], transactions: [], discordConfigured: false,
    }
    const { rerender } = render(<MonitorDetail {...props} />)
    await userEvent.click(screen.getByRole('button', { name: 'もっと見る' }))
    const refreshed = { ...listing, id: 9, name: '更新済み' }
    rerender(<MonitorDetail {...props} crawlResults={[refreshed]} hasMore={false} cursor={null} />)

    await act(async () => resolve({
      data: { crawlResults: [listing], hasMore: true, cursor: props.cursor }, status: 200, error: null,
    }))
    expect(screen.getByText('更新済み')).toBeInTheDocument()
    expect(screen.queryByText(listing.name)).not.toBeInTheDocument()
    expect(screen.queryByRole('button', { name: 'もっと見る' })).not.toBeInTheDocument()
  })

  it('除外に失敗した場合はエラーを示し画面を更新しない', async () => {
    vi.spyOn(window, 'confirm').mockReturnValueOnce(true)
    vi.mocked(setCrawlResultExcluded).mockResolvedValueOnce({ data: null, status: 500, error: null })
    render(<MonitorDetail monitor={monitor} crawlResults={[listing]} hasMore={false} dailyMarketPrices={[]} transactions={[]} discordConfigured={false} />)

    const user = userEvent.setup()
    await user.click(screen.getByRole('button', { name: 'iPad 128GBの操作' }))
    await user.click(screen.getByRole('button', { name: '除外' }))
    await waitFor(() => expect(toastError).toHaveBeenCalledWith('除外に失敗しました'))
    expect(refresh).not.toHaveBeenCalled()
  })
})
