import type { ReactNode } from 'react'

import { render, screen } from '@testing-library/react'
import { beforeEach, describe, expect, it, vi } from 'vitest'

import Page from '@/app/product-monitoring/monitors/[id]/page'
import {
  getDailyMarketPrices,
  getMonitorTransactions,
  getMonitorCrawlResults,
  getMonitors,
} from '@/features/product-monitoring/api/actions'
import type { Monitor } from '@/features/product-monitoring/api/types'

vi.mock('next/navigation', () => ({ notFound: () => { throw new Error('NOT_FOUND') } }))
vi.mock('@/components/layouts/Layout', () => ({ default: ({ children }: { children: ReactNode }) => <>{children}</> }))
vi.mock('@/features/product-monitoring/api/actions', () => ({
  getMonitors: vi.fn(),
  getMonitorCrawlResults: vi.fn(),
  getDailyMarketPrices: vi.fn(),
  getMonitorTransactions: vi.fn(),
}))
vi.mock('@/features/product-monitoring/components/MonitorDetail', () => ({
  default: ({ crawlResults, dailyMarketPrices, transactions }: { crawlResults: unknown; dailyMarketPrices: unknown; transactions: unknown }) => (
    <div>crawlResults:{JSON.stringify(crawlResults)};dailyMarketPrices:{JSON.stringify(dailyMarketPrices)};transactions:{JSON.stringify(transactions)}</div>
  ),
}))

const monitor: Monitor = {
  id: 1, name: 'iPad', enabled: false, discordEnabled: false, newestNotificationEnabled: false,
  requiredKeywords: [], negativeKeywords: [], minPrice: null, maxPrice: null,
}

beforeEach(() => {
  vi.resetAllMocks()
  vi.mocked(getMonitors).mockResolvedValue({
    data: { monitors: [monitor], discordConfigured: false }, status: 200, error: null,
  })
  vi.mocked(getMonitorCrawlResults).mockResolvedValue({ data: { crawlResults: [] }, status: 200, error: null })
  vi.mocked(getDailyMarketPrices).mockResolvedValue({ data: { dailyMarketPrices: [] }, status: 200, error: null })
})

describe('商品モニタリング詳細ページ', () => {
  it('不正なIDと存在しない設定を404にする', async () => {
    await expect(Page({ params: Promise.resolve({ id: 'abc' }) })).rejects.toThrow('NOT_FOUND')
    await expect(Page({ params: Promise.resolve({ id: '2' }) })).rejects.toThrow('NOT_FOUND')
  })

  it('販売中の収集結果と相場の取得失敗を部分障害として表示する', async () => {
    vi.mocked(getMonitorCrawlResults).mockRejectedValueOnce(new Error('network'))
    vi.mocked(getDailyMarketPrices).mockResolvedValueOnce({ data: null, status: 500, error: null })
    render(await Page({ params: Promise.resolve({ id: '1' }) }))
    expect(screen.getByText('crawlResults:null;dailyMarketPrices:null;transactions:[]')).toBeInTheDocument()
  })

  it('取引商品の取得に失敗しても日次相場を表示する', async () => {
    vi.mocked(getDailyMarketPrices).mockResolvedValueOnce({
      data: { dailyMarketPrices: [{ id: 2, monitorId: 1, date: '2026-11-09', averageTransactionPrice: 30000, transactionCount: 1 }] },
      status: 200, error: null,
    })
    vi.mocked(getMonitorTransactions).mockRejectedValueOnce(new Error('network'))
    render(await Page({ params: Promise.resolve({ id: '1' }) }))
    expect(screen.getByText(/dailyMarketPrices:\[.*transactions:null/)).toBeInTheDocument()
    expect(getMonitorTransactions).toHaveBeenCalledWith(1, { startDate: '2026-11-09', endDate: '2026-11-09' })
  })

  it('設定の取得自体に失敗した場合は404として扱わない', async () => {
    vi.mocked(getMonitors).mockResolvedValueOnce({ data: null, status: 500, error: null })
    await expect(Page({ params: Promise.resolve({ id: '1' }) })).rejects.toThrow('モニタリング設定を取得できませんでした')
  })

  it('古い日次相場が残っていても直近30日だけの商品を取得する', async () => {
    vi.mocked(getDailyMarketPrices).mockResolvedValueOnce({
      data: { dailyMarketPrices: [
        { id: 1, monitorId: 1, date: '2026-01-01', averageTransactionPrice: 100, transactionCount: 1 },
        { id: 2, monitorId: 1, date: '2026-10-11', averageTransactionPrice: 200, transactionCount: 1 },
        { id: 3, monitorId: 1, date: '2026-11-09', averageTransactionPrice: 300, transactionCount: 1 },
      ] }, status: 200, error: null,
    })
    vi.mocked(getMonitorTransactions).mockResolvedValueOnce({ data: { transactions: [] }, status: 200, error: null })
    render(await Page({ params: Promise.resolve({ id: '1' }) }))
    expect(getMonitorTransactions).toHaveBeenCalledWith(1, { startDate: '2026-10-11', endDate: '2026-11-09' })
    expect(screen.getByText(/2026-10-11/)).not.toHaveTextContent('2026-01-01')
  })
})
