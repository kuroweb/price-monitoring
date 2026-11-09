import { render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { beforeEach, describe, expect, it, vi } from 'vitest'

import { calculateProductAggregationSetting } from '@/features/product-monitoring/api/actions'
import type {
  ProductAggregationSetting,
  ProductCrawlResult,
} from '@/features/product-monitoring/api/types'
import ProductAggregationResultsSection from '@/features/product-monitoring/components/ProductAggregationResultsSection'

const { refresh } = vi.hoisted(() => ({ refresh: vi.fn() }))
vi.mock('next/navigation', () => ({ useRouter: () => ({ refresh }) }))
vi.mock('react-toastify', () => ({ toast: { success: vi.fn(), error: vi.fn() } }))
vi.mock('@/features/product-monitoring/api/actions', () => ({
  createProductAggregationSetting: vi.fn(),
  updateProductAggregationSetting: vi.fn(),
  destroyProductAggregationSetting: vi.fn(),
  calculateProductAggregationSetting: vi.fn(),
}))

const setting: ProductAggregationSetting = {
  id: 1,
  name: 'phone',
  requiredKeywords: ['phone'],
  excludeKeywords: ['case'],
  minPrice: null,
  maxPrice: 1000,
}

const purchase = (id: number, boughtDate: string): ProductCrawlResult => ({
  id,
  productCrawlSettingId: 1,
  platform: 'mercari',
  externalId: `m${id}`,
  name: `phone ${id}`,
  productUrl: `https://example.com/${id}`,
  thumbnailUrl: null,
  price: 300,
  buyoutPrice: null,
  sold: true,
  boughtDate,
  endDate: null,
  excludedAt: null,
})

beforeEach(() => vi.clearAllMocks())

describe('商品相場', () => {
  it('日ごとの結果を計算し、新しい日付から一覧表示すること', async () => {
    vi.mocked(calculateProductAggregationSetting).mockResolvedValue({
      data: {},
      error: null,
      status: 200,
    })
    const user = userEvent.setup()
    render(
      <ProductAggregationResultsSection
        productAggregationSetting={setting}
        productAggregationResults={[
          {
            id: 1,
            productWatchSettingId: 1,
            date: '2026-11-01',
            averagePurchasePrice: null,
            purchaseCount: 0,
          },
          {
            id: 2,
            productWatchSettingId: 1,
            date: '2026-11-02',
            averagePurchasePrice: 300,
            purchaseCount: 2,
          },
        ]}
        productAggregationPurchases={[]}
      />,
    )
    expect(screen.getByText('直近の平均購入価格').parentElement).toHaveTextContent('¥30011/2の購入')
    expect(screen.getByText('購入件数', { selector: 'p.text-xs' }).parentElement).toHaveTextContent(
      '2件',
    )
    await user.click(screen.getByRole('button', { name: '表' }))
    const rows = screen.getAllByRole('row')
    expect(rows[1]).toHaveTextContent('2026-11-02¥3002件')
    expect(rows[2]).toHaveTextContent('2026-11-01-0件')
    await user.click(screen.getByRole('button', { name: '直近30日を集計' }))
    await waitFor(() => expect(calculateProductAggregationSetting).toHaveBeenCalledWith(1))
    expect(refresh).toHaveBeenCalled()
  })

  it('表示期間に売れた相場対象の商品をカードで表示すること', async () => {
    const user = userEvent.setup()
    render(
      <ProductAggregationResultsSection
        productAggregationSetting={setting}
        productAggregationResults={Array.from({ length: 8 }, (_, index) => ({
          id: index + 1,
          productWatchSettingId: 1,
          date: `2026-11-0${index + 1}`,
          averagePurchasePrice: 300,
          purchaseCount: 1,
        }))}
        productAggregationPurchases={[
          purchase(2, '2026-11-08T12:00:00.000+09:00'),
          purchase(1, '2026-11-01T00:00:00.000+09:00'),
        ]}
      />,
    )
    const heading = screen.getByRole('heading', { name: /相場対象の商品/ })
    expect(heading).toHaveTextContent('直近30日・2件')
    expect(screen.getAllByRole('article')).toHaveLength(2)
    await user.click(screen.getByRole('button', { name: '7日' }))
    expect(heading).toHaveTextContent('直近7日・1件')
    expect(screen.getByRole('article')).toHaveTextContent('phone 2')
  })

  it('相場対象の商品を取得できなかったときも日次相場を表示し、取得失敗を伝えること', () => {
    render(
      <ProductAggregationResultsSection
        productAggregationSetting={setting}
        productAggregationResults={[
          {
            id: 1,
            productWatchSettingId: 1,
            date: '2026-11-01',
            averagePurchasePrice: 300,
            purchaseCount: 1,
          },
        ]}
        productAggregationPurchases={null}
      />,
    )
    expect(screen.getByText('購入件数', { selector: 'p.text-xs' }).parentElement).toHaveTextContent(
      '1件',
    )
    expect(
      screen.getByText('相場対象の商品を取得できませんでした。再読み込みしてください。'),
    ).toBeInTheDocument()
    expect(screen.queryByRole('article')).not.toBeInTheDocument()
  })
})
