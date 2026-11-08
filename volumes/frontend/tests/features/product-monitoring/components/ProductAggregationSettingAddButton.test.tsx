import { render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { beforeEach, describe, expect, it, vi } from 'vitest'

import { createProductAggregationSetting } from '@/features/product-monitoring/api/actions'
import type { ProductAggregationSetting } from '@/features/product-monitoring/api/types'
import ProductAggregationSettingAddButton from '@/features/product-monitoring/components/ProductAggregationSettingAddButton'

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

beforeEach(() => vi.clearAllMocks())

describe('商品相場設定', () => {
  it('計測結果の絞り込み条件を保存すること', async () => {
    vi.mocked(createProductAggregationSetting).mockResolvedValue({
      data: setting,
      error: null,
      status: 200,
    })
    const user = userEvent.setup()
    render(<ProductAggregationSettingAddButton />)
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
})
