import { render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { beforeEach, describe, expect, it, vi } from 'vitest'

import ProductAggregationSettings from '@/features/admin/product-aggregation-settings/components/ProductAggregationSettings'
import ProductAggregationResultsSection from '@/features/product-aggregation-results/components/ProductAggregationResultsSection'
import { calculateProductAggregationSetting, createProductAggregationSetting } from '@/lib/actions'
import type { ProductAggregationSetting } from '@/lib/api'

const { refresh } = vi.hoisted(() => ({ refresh: vi.fn() }))
vi.mock('next/navigation', () => ({ useRouter: () => ({ refresh }) }))
vi.mock('react-toastify', () => ({ toast: { success: vi.fn(), error: vi.fn() } }))
vi.mock('@/lib/actions', () => ({
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

beforeEach(() => vi.clearAllMocks())

describe('商品相場設定', () => {
  it('saves filters for crawl results', async () => {
    vi.mocked(createProductAggregationSetting).mockResolvedValue({
      data: setting,
      error: null,
      status: 200,
    })
    const user = userEvent.setup()
    render(<ProductAggregationSettings productAggregationSettings={[]} />)
    await user.click(screen.getByRole('button', { name: '商品相場設定を追加' }))
    await user.type(screen.getByRole('textbox', { name: '名前' }), 'phone')
    await user.type(screen.getByRole('textbox', { name: /必須語/ }), 'phone')
    await user.type(screen.getByRole('textbox', { name: /除外語/ }), 'case')
    await user.type(screen.getByRole('spinbutton', { name: '最高価格（円）' }), '1000')
    await user.click(screen.getByRole('button', { name: '登録' }))
    await waitFor(() =>
      expect(createProductAggregationSetting).toHaveBeenCalledWith({
        name: 'phone',
        requiredKeywords: ['phone'],
        excludeKeywords: ['case'],
        minPrice: null,
        maxPrice: 1000,
      }),
    )
  })

  it('calculates and lists daily results from the newest date', async () => {
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
            productAggregationSettingId: 1,
            date: '2026-11-01',
            averagePurchasePrice: null,
            purchaseCount: 0,
          },
          {
            id: 2,
            productAggregationSettingId: 1,
            date: '2026-11-02',
            averagePurchasePrice: 300,
            purchaseCount: 2,
          },
        ]}
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
})
