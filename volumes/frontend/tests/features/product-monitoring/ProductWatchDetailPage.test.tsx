import type { ReactNode } from 'react'

import { render, screen } from '@testing-library/react'
import { beforeEach, describe, expect, it, vi } from 'vitest'

import Page from '@/app/product-monitoring/[id]/page'
import {
  getAllProductAggregationResults,
  getProductAggregationPurchases,
  getProductWatchResults,
  getProductWatchSettings,
} from '@/features/product-monitoring/api/actions'
import type { ProductWatchSetting } from '@/features/product-monitoring/api/types'

vi.mock('next/navigation', () => ({ notFound: () => { throw new Error('NOT_FOUND') } }))
vi.mock('@/components/layouts/Layout', () => ({ default: ({ children }: { children: ReactNode }) => <>{children}</> }))
vi.mock('@/features/product-monitoring/api/actions', () => ({
  getProductWatchSettings: vi.fn(),
  getProductWatchResults: vi.fn(),
  getAllProductAggregationResults: vi.fn(),
  getProductAggregationPurchases: vi.fn(),
}))
vi.mock('@/features/product-monitoring/components/ProductWatchDetail', () => ({
  default: ({ results, daily, purchases }: { results: unknown; daily: unknown; purchases: unknown }) => (
    <div>results:{JSON.stringify(results)};daily:{JSON.stringify(daily)};purchases:{JSON.stringify(purchases)}</div>
  ),
}))

const setting: ProductWatchSetting = {
  id: 1, name: 'iPad', enabled: false, discordEnabled: false,
  requiredKeywords: [], excludeKeywords: [], minPrice: null, maxPrice: null,
}

beforeEach(() => {
  vi.resetAllMocks()
  vi.mocked(getProductWatchSettings).mockResolvedValue({
    data: { productWatchSettings: [setting], discordConfigured: false }, status: 200, error: null,
  })
  vi.mocked(getProductWatchResults).mockResolvedValue({ data: { productCrawlResults: [] }, status: 200, error: null })
  vi.mocked(getAllProductAggregationResults).mockResolvedValue({ data: { productAggregationResults: [] }, status: 200, error: null })
})

describe('商品モニタリング詳細ページ', () => {
  it('不正なIDと存在しない設定を404にする', async () => {
    await expect(Page({ params: Promise.resolve({ id: 'abc' }) })).rejects.toThrow('NOT_FOUND')
    await expect(Page({ params: Promise.resolve({ id: '2' }) })).rejects.toThrow('NOT_FOUND')
  })

  it('販売中の商品と相場の取得失敗を部分障害として表示する', async () => {
    vi.mocked(getProductWatchResults).mockRejectedValueOnce(new Error('network'))
    vi.mocked(getAllProductAggregationResults).mockResolvedValueOnce({ data: null, status: 500, error: null })
    render(await Page({ params: Promise.resolve({ id: '1' }) }))
    expect(screen.getByText('results:null;daily:null;purchases:[]')).toBeInTheDocument()
  })

  it('購入商品の取得に失敗しても日次相場を表示する', async () => {
    vi.mocked(getAllProductAggregationResults).mockResolvedValueOnce({
      data: { productAggregationResults: [{ id: 2, productWatchSettingId: 1, date: '2026-11-09', averagePurchasePrice: 30000, purchaseCount: 1 }] },
      status: 200, error: null,
    })
    vi.mocked(getProductAggregationPurchases).mockRejectedValueOnce(new Error('network'))
    render(await Page({ params: Promise.resolve({ id: '1' }) }))
    expect(screen.getByText(/daily:\[.*purchases:null/)).toBeInTheDocument()
    expect(getProductAggregationPurchases).toHaveBeenCalledWith(1, { startDate: '2026-11-09', endDate: '2026-11-09' })
  })

  it('設定の取得自体に失敗した場合は404として扱わない', async () => {
    vi.mocked(getProductWatchSettings).mockResolvedValueOnce({ data: null, status: 500, error: null })
    await expect(Page({ params: Promise.resolve({ id: '1' }) })).rejects.toThrow('商品モニタリング設定を取得できませんでした')
  })

  it('古い日次相場が残っていても直近30日だけの商品を取得する', async () => {
    vi.mocked(getAllProductAggregationResults).mockResolvedValueOnce({
      data: { productAggregationResults: [
        { id: 1, productWatchSettingId: 1, date: '2026-01-01', averagePurchasePrice: 100, purchaseCount: 1 },
        { id: 2, productWatchSettingId: 1, date: '2026-10-11', averagePurchasePrice: 200, purchaseCount: 1 },
        { id: 3, productWatchSettingId: 1, date: '2026-11-09', averagePurchasePrice: 300, purchaseCount: 1 },
      ] }, status: 200, error: null,
    })
    vi.mocked(getProductAggregationPurchases).mockResolvedValueOnce({ data: { productCrawlResults: [] }, status: 200, error: null })
    render(await Page({ params: Promise.resolve({ id: '1' }) }))
    expect(getProductAggregationPurchases).toHaveBeenCalledWith(1, { startDate: '2026-10-11', endDate: '2026-11-09' })
    expect(screen.getByText(/2026-10-11/)).not.toHaveTextContent('2026-01-01')
  })
})
