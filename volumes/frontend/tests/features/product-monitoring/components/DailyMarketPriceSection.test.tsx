import { render, screen, waitFor, within } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { beforeEach, describe, expect, it, vi } from 'vitest'

import { aggregateDailyMarketPrices } from '@/features/product-monitoring/api/actions'
import type {
  Monitor,
  CrawlResult,
} from '@/features/product-monitoring/api/types'
import DailyMarketPriceSection from '@/features/product-monitoring/components/DailyMarketPriceSection'

const { refresh } = vi.hoisted(() => ({ refresh: vi.fn() }))
vi.mock('next/navigation', () => ({ useRouter: () => ({ refresh }) }))
vi.mock('react-toastify', () => ({ toast: { success: vi.fn(), error: vi.fn() } }))
vi.mock('@/features/product-monitoring/api/actions', () => ({
  createMonitor: vi.fn(),
  updateMonitor: vi.fn(),
  destroyMonitor: vi.fn(),
  aggregateDailyMarketPrices: vi.fn(),
}))

const setting: Monitor = {
  id: 1,
  enabled: true, discordEnabled: false, newestNotificationEnabled: false,
  name: 'phone',
  requiredKeywords: ['phone'],
  negativeKeywords: ['case'],
  minPrice: null,
  maxPrice: 1000,
}

const purchase = (id: number, soldAt: string): CrawlResult => ({
  id,
  crawlSettingId: 1,
  platform: 'mercari',
  externalId: `m${id}`,
  name: `phone ${id}`,
  productUrl: `https://example.com/${id}`,
  thumbnailUrl: null,
  price: 300,
  buyoutPrice: null,
  sold: true,
  soldAt,
  endsAt: null,
  excludedAt: null,
})

beforeEach(() => vi.clearAllMocks())

describe('日次相場', () => {
  it('日ごとの結果を計算し、新しい日付から一覧表示すること', async () => {
    vi.mocked(aggregateDailyMarketPrices).mockResolvedValue({
      data: {},
      error: null,
      status: 200,
    })
    const user = userEvent.setup()
    render(
      <DailyMarketPriceSection
        monitor={setting}
        dailyMarketPrices={[
          {
            id: 1,
            monitorId: 1,
            date: '2026-11-01',
            averageTransactionPrice: null,
            transactionCount: 0,
          },
          {
            id: 2,
            monitorId: 1,
            date: '2026-11-02',
            averageTransactionPrice: 300,
            transactionCount: 2,
          },
        ]}
        transactions={[]}
      />,
    )
    expect(screen.getByText('直近の平均取引価格').parentElement).toHaveTextContent('¥30011/2の取引')
    expect(screen.getByText('取引件数', { selector: 'p.text-xs' }).parentElement).toHaveTextContent(
      '2件',
    )
    await user.click(screen.getByRole('button', { name: '表' }))
    const rows = screen.getAllByRole('row')
    expect(rows[1]).toHaveTextContent('2026-11-02¥3002件')
    expect(rows[2]).toHaveTextContent('2026-11-01-0件')
    await user.click(screen.getByRole('button', { name: '直近30日を集計' }))
    await waitFor(() => expect(aggregateDailyMarketPrices).toHaveBeenCalledWith(1))
    expect(refresh).toHaveBeenCalled()
  })

  it('表示期間に売れた取引をカードで表示すること', async () => {
    const user = userEvent.setup()
    render(
      <DailyMarketPriceSection
        monitor={setting}
        dailyMarketPrices={Array.from({ length: 8 }, (_, index) => ({
          id: index + 1,
          monitorId: 1,
          date: `2026-11-0${index + 1}`,
          averageTransactionPrice: 300,
          transactionCount: 1,
        }))}
        transactions={[
          purchase(2, '2026-11-08T12:00:00.000+09:00'),
          purchase(1, '2026-11-01T00:00:00.000+09:00'),
        ]}
      />,
    )
    const heading = screen.getByRole('heading', { name: /取引/ })
    expect(heading).toHaveTextContent('直近30日・2件')
    expect(screen.getAllByRole('article')).toHaveLength(2)
    await user.click(screen.getByRole('button', { name: '7日' }))
    expect(heading).toHaveTextContent('直近7日・1件')
    expect(screen.getByRole('article')).toHaveTextContent('phone 2')
  })

  it('取引を新しい順に12件ずつ切り替え、表示期間を変えると1ページ目に戻る', async () => {
    const user = userEvent.setup()
    const dates = Array.from({ length: 14 }, (_, i) => `2026-11-${String(i + 1).padStart(2, '0')}`)
    render(
      <DailyMarketPriceSection
        monitor={setting}
        dailyMarketPrices={dates.map((date, i) => ({
          id: i + 1, monitorId: 1, date, averageTransactionPrice: 300, transactionCount: 2,
        }))}
        transactions={dates.slice().reverse().flatMap((date, i) => [
          purchase(28 - i * 2, `${date}T12:00:00.000+09:00`),
          purchase(27 - i * 2, `${date}T11:00:00.000+09:00`),
        ])}
      />,
    )

    const pages = within(screen.getByRole('navigation', { name: '取引のページ' }))
    const expectCards = (count: number, firstId: number) => {
      const cards = screen.getAllByRole('article')
      expect(cards).toHaveLength(count)
      cards.forEach((card, i) => expect(within(card).getByText(`phone ${firstId - i}`)).toBeInTheDocument())
    }
    expectCards(12, 28)
    await user.click(pages.getByRole('button', { name: '次へ' }))
    expectCards(12, 16)
    await user.click(pages.getByRole('button', { name: '3ページ' }))
    expectCards(4, 4)
    expect(pages.queryByRole('button', { name: '次へ' })).not.toBeInTheDocument()
    await user.click(pages.getByRole('button', { name: '前へ' }))
    expectCards(12, 16)
    await user.click(screen.getByRole('button', { name: '7日' }))
    expectCards(12, 28)
    expect(pages.getByRole('button', { name: '1ページ' })).toHaveAttribute('aria-current', 'page')
  })

  it('取引を取得できなかったときも日次相場を表示し、取得失敗を伝えること', () => {
    render(
      <DailyMarketPriceSection
        monitor={setting}
        dailyMarketPrices={[
          {
            id: 1,
            monitorId: 1,
            date: '2026-11-01',
            averageTransactionPrice: 300,
            transactionCount: 1,
          },
        ]}
        transactions={null}
      />,
    )
    expect(screen.getByText('取引件数', { selector: 'p.text-xs' }).parentElement).toHaveTextContent(
      '1件',
    )
    expect(
      screen.getByText('取引を取得できませんでした。再読み込みしてください。'),
    ).toBeInTheDocument()
    expect(screen.queryByRole('article')).not.toBeInTheDocument()
  })
})
