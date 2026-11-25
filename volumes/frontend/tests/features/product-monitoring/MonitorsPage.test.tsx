import type { ReactNode } from 'react'

import { render, screen } from '@testing-library/react'
import { beforeEach, describe, expect, it, vi } from 'vitest'

import Page from '@/app/product-monitoring/monitors/page'
import {
  getDailyMarketPrices,
  getMonitorCrawlResults,
  getMonitorSummary,
  getMonitors,
} from '@/features/product-monitoring/api/actions'
import type { Monitor } from '@/features/product-monitoring/api/types'

vi.mock('@/components/layouts/Layout', () => ({ default: ({ children }: { children: ReactNode }) => <>{children}</> }))
vi.mock('@/features/product-monitoring/api/actions', () => ({
  getMonitors: vi.fn(),
  getMonitorCrawlResults: vi.fn(),
  getMonitorSummary: vi.fn(),
  getDailyMarketPrices: vi.fn(),
}))
vi.mock('@/features/product-monitoring/components/MonitorList', () => ({
  default: ({ sections }: { sections: { crawlResults: unknown; summary: unknown }[] }) => (
    <div>{sections.map((section) => `crawlResults:${JSON.stringify(section.crawlResults)};summary:${JSON.stringify(section.summary)}`)}</div>
  ),
}))

const monitor: Monitor = {
  id: 1, name: 'iPad', enabled: false, discordEnabled: false, newestNotificationEnabled: false,
  requiredKeywords: [], negativeKeywords: [], minPrice: null, maxPrice: null,
}
const summary = { lowestPrice: 30000, latestAverageTransactionPrice: 32000 }

beforeEach(() => {
  vi.resetAllMocks()
  vi.mocked(getMonitors).mockResolvedValue({
    data: { monitors: [monitor], discordConfigured: false }, status: 200, error: null,
  })
  vi.mocked(getMonitorCrawlResults).mockResolvedValue({ data: { crawlResults: [] }, status: 200, error: null })
  vi.mocked(getMonitorSummary).mockResolvedValue({ data: summary, status: 200, error: null })
})

describe('商品モニタリング一覧ページ', () => {
  it('モニタリング設定ごとに収集結果と summary を取り、日次相場は取らない', async () => {
    render(await Page())
    expect(screen.getByText(`crawlResults:[];summary:${JSON.stringify(summary)}`)).toBeInTheDocument()
    expect(getMonitorSummary).toHaveBeenCalledWith(1)
    expect(getMonitorCrawlResults).toHaveBeenCalledWith(1)
    expect(getDailyMarketPrices).not.toHaveBeenCalled()
  })

  it('収集結果と summary の取得失敗を別々に扱う', async () => {
    vi.mocked(getMonitorSummary).mockRejectedValueOnce(new Error('network'))
    render(await Page())
    expect(screen.getByText('crawlResults:[];summary:null')).toBeInTheDocument()
  })

  it('収集結果の取得に失敗しても summary を渡す', async () => {
    vi.mocked(getMonitorCrawlResults).mockResolvedValueOnce({ data: null, status: 500, error: null })
    render(await Page())
    expect(screen.getByText(`crawlResults:null;summary:${JSON.stringify(summary)}`)).toBeInTheDocument()
  })

  it('認証失敗のクエリではログイン失敗を表示すること', async () => {
    render(await Page({ searchParams: Promise.resolve({ auth_error: '1' }) }))
    expect(screen.getByRole('alert')).toHaveTextContent('ログインに失敗しました。もう一度お試しください。')
  })
})
