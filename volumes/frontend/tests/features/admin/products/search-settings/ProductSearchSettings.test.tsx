import { render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { beforeEach, describe, expect, it, vi } from 'vitest'

import ProductSearchSettings from '@/features/admin/products/search-settings/ProductSearchSettings'
import {
  createProductSearchSetting,
  previewProductSearchSetting,
  updateProductSearchSetting,
} from '@/lib/actions'

vi.mock('@/lib/actions', () => ({
  createProductSearchSetting: vi.fn(),
  updateProductSearchSetting: vi.fn(),
  deleteProductSearchSetting: vi.fn(),
  previewProductSearchSetting: vi.fn(),
}))
const source = { url: 'https://jp.mercari.com/search?keyword=phone', enabled: true }
const draft = {
  id: 1,
  name: 'phone',
  enabled: true,
  minPrice: null,
  maxPrice: null,
  requiredKeywords: [],
  excludeKeywords: [],
  excludedListings: [],
  urls: [source],
}
beforeEach(() => vi.clearAllMocks())
describe('URL計測', () => {
  it('sends common keywords once for multiple sites and preserves typed delimiters', async () => {
    vi.mocked(createProductSearchSetting).mockResolvedValue({
      data: draft,
      error: null,
      status: 200,
    })
    const user = userEvent.setup()
    render(<ProductSearchSettings initial={[]} />)
    await user.type(screen.getByRole('textbox', { name: '名前' }), 'phone')
    await user.type(screen.getByRole('textbox', { name: '取得URL 1' }), source.url)
    await user.click(screen.getByRole('button', { name: 'URLを追加' }))
    await user.type(
      screen.getByRole('textbox', { name: '取得URL 2' }),
      'https://iosys.co.jp/items?q=phone',
    )
    await user.type(screen.getByRole('textbox', { name: /必須語/ }), 'phone, blue')
    await user.click(screen.getByRole('button', { name: '保存' }))
    await waitFor(() =>
      expect(createProductSearchSetting).toHaveBeenCalledWith(
        expect.objectContaining({
          requiredKeywords: ['phone', 'blue'],
          urls: [source, { url: 'https://iosys.co.jp/items?q=phone', enabled: true }],
        }),
      ),
    )
  })

  it('shows independent source failures and scopes individual exclusions by site', async () => {
    vi.mocked(updateProductSearchSetting).mockResolvedValue({
      data: draft,
      error: null,
      status: 200,
    })
    vi.mocked(previewProductSearchSetting).mockResolvedValue({
      data: {
        sources: [
          {
            url: source.url,
            platform: 'mercari',
            status: 'succeeded',
            error: null,
            fetchedCount: 1,
          },
          {
            url: 'https://iosys.co.jp/items?q=phone',
            platform: 'iosys',
            status: 'failed',
            error: '取得失敗',
            fetchedCount: 0,
          },
        ],
        results: [
          {
            platform: 'mercari',
            externalId: 'same',
            name: 'phone',
            price: 100,
            url: null,
            accepted: true,
            reasons: [],
          },
        ],
        fetchedCount: 1,
        acceptedCount: 1,
      },
      error: null,
      status: 200,
    })
    vi.mocked(createProductSearchSetting).mockResolvedValue({
      data: draft,
      error: null,
      status: 200,
    })
    const user = userEvent.setup()
    render(<ProductSearchSettings initial={[draft]} />)
    await user.click(screen.getByRole('button', { name: '編集・取得' }))
    await user.click(screen.getByRole('button', { name: '実際に取得して確認' }))
    expect(await screen.findByText(/iosys \/ 取得失敗/)).toBeInTheDocument()
    await user.click(screen.getByRole('button', { name: 'この計測から出品 sameを除外' }))
    expect(screen.queryByRole('region', { name: '取得結果' })).not.toBeInTheDocument()
    await user.click(screen.getByRole('button', { name: '保存' }))
    await waitFor(() =>
      expect(updateProductSearchSetting).toHaveBeenCalledWith(
        1,
        expect.objectContaining({
          excludedListings: [{ platform: 'mercari', externalId: 'same' }],
        }),
      ),
    )
  })

  it('reports request exceptions and re-enables controls', async () => {
    vi.mocked(previewProductSearchSetting).mockRejectedValue(new Error('network'))
    const user = userEvent.setup()
    render(<ProductSearchSettings initial={[draft]} />)
    await user.click(screen.getByRole('button', { name: '編集・取得' }))
    await user.click(screen.getByRole('button', { name: '実際に取得して確認' }))
    expect(await screen.findByRole('alert')).toHaveTextContent('通信に失敗しました')
    expect(screen.getByRole('button', { name: '保存' })).toBeEnabled()
  })
})
