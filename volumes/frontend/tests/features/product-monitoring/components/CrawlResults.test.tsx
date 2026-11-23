import { render, screen, waitFor, within } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { toast } from 'react-toastify'
import { beforeEach, describe, expect, it, vi } from 'vitest'

import {
  getCrawlResults,
  destroyCrawlResult,
  setCrawlResultExcluded,
  syncCrawlSetting,
} from '@/features/product-monitoring/api/actions'
import type {
  CrawlResult,
  CrawlSetting,
} from '@/features/product-monitoring/api/types'
import CrawlSettingDetail from '@/features/product-monitoring/components/CrawlSettingDetail'
import CrawlSettingSection from '@/features/product-monitoring/components/CrawlSettingSection'

const { refresh } = vi.hoisted(() => ({ refresh: vi.fn() }))
vi.mock('next/navigation', () => ({ useRouter: () => ({ refresh }) }))
vi.mock('react-toastify', () => ({ toast: { success: vi.fn(), error: vi.fn() } }))
vi.mock('@/features/product-monitoring/api/actions', () => ({
  createCrawlSetting: vi.fn(),
  updateCrawlSetting: vi.fn(),
  destroyCrawlSetting: vi.fn(),
  destroyCrawlResult: vi.fn(),
  syncCrawlSetting: vi.fn(),
  setCrawlResultExcluded: vi.fn(),
  getCrawlResults: vi.fn(),
}))

const setting: CrawlSetting = {
  id: 1,
  name: 'phone',
  enabled: true,
  searchKeyword: null,
  platforms: [],
  searchUrls: ['https://jp.mercari.com/search?searchKeyword=phone'],
  requiredKeywords: [],
  negativeKeywords: [],
  minPrice: null,
  maxPrice: null,
}
const result: CrawlResult = {
  id: 10,
  crawlSettingId: 1,
  platform: 'iosys',
  externalId: 'item-1',
  name: 'Phone blue',
  productUrl: 'https://iosys.co.jp/items/item-1',
  thumbnailUrl: null,
  price: 1200,
  buyoutPrice: null,
  sold: true,
  soldAt: null,
  endsAt: null,
  excludedAt: null,
}

beforeEach(() => {
  vi.clearAllMocks()
  vi.mocked(getCrawlResults).mockResolvedValue({
    data: { crawlResults: [] },
    error: null,
    status: 200,
  })
})

describe('収集結果', () => {
  it('収集設定の詳細は12件ずつ表示し、販売状態と並びを変えると先頭に戻る', async () => {
    const user = userEvent.setup()
    const listings = Array.from({ length: 26 }, (_, i) => ({
      ...result, id: i + 1, name: `出品 ${i + 1}`, price: 26 - i, sold: i % 2 === 0,
    }))
    render(<CrawlSettingDetail crawlSetting={setting} crawlResults={listings} />)

    const pages = within(screen.getByRole('navigation', { name: '収集結果のページ' }))
    expect(screen.getAllByRole('article')).toHaveLength(12)
    await user.click(pages.getByRole('button', { name: '2ページ' }))
    expect(screen.getAllByRole('article')).toHaveLength(12)
    expect(screen.getByText('出品 13')).toBeInTheDocument()
    expect(screen.queryByText('出品 1')).not.toBeInTheDocument()

    await user.click(screen.getByRole('button', { name: /^売り切れ/ }))
    expect(screen.getAllByRole('article')).toHaveLength(12)
    expect(screen.getByText('出品 1')).toBeInTheDocument()
    expect(screen.queryByText('出品 2')).not.toBeInTheDocument()
    await user.click(pages.getByRole('button', { name: '次へ' }))
    expect(screen.getByRole('article')).toHaveTextContent('出品 25')
    expect(pages.queryByRole('button', { name: '次へ' })).not.toBeInTheDocument()

    await user.selectOptions(screen.getByRole('combobox', { name: '並び順' }), 'price_asc')
    const cards = screen.getAllByRole('article')
    expect(cards).toHaveLength(12)
    expect(cards[0]).toHaveTextContent('出品 25')
    expect(pages.getByRole('button', { name: '1ページ' })).toHaveAttribute('aria-current', 'page')
  })

  it('確認後に結果を削除し、失敗時は画面を更新しないこと', async () => {
    vi.spyOn(window, 'confirm').mockReturnValueOnce(false).mockReturnValue(true)
    vi.mocked(destroyCrawlResult)
      .mockResolvedValueOnce({ data: null, error: { code: 500, message: 'error', details: [] }, status: 500 })
      .mockResolvedValueOnce({ data: {}, error: null, status: 200 })
    const user = userEvent.setup()
    render(<CrawlSettingDetail crawlSetting={setting} crawlResults={[result]} />)

    await user.click(screen.getByRole('button', { name: '削除' }))
    expect(destroyCrawlResult).not.toHaveBeenCalled()
    await user.click(screen.getByRole('button', { name: '削除' }))
    await waitFor(() => expect(toast.error).toHaveBeenCalledWith('削除に失敗しました'))
    expect(refresh).not.toHaveBeenCalled()
    await user.click(screen.getByRole('button', { name: '削除' }))
    await waitFor(() => expect(refresh).toHaveBeenCalledTimes(1))
    expect(destroyCrawlResult).toHaveBeenCalledWith(result.id)
  })
  it('保存済みの設定を同期し、保存済みの結果を除外すること', async () => {
    vi.spyOn(window, 'confirm').mockReturnValue(true)
    vi.mocked(syncCrawlSetting).mockResolvedValue({
      data: {},
      error: null,
      status: 202,
    })
    vi.mocked(setCrawlResultExcluded).mockResolvedValue({
      data: result,
      error: null,
      status: 200,
    })
    const user = userEvent.setup()
    render(
      <CrawlSettingDetail crawlSetting={setting} crawlResults={[result]} />,
    )
    expect(screen.getByRole('link', { name: 'Phone blueの商品ページを開く' })).toHaveAttribute(
      'href',
      result.productUrl,
    )
    expect(screen.getByText('イオシス')).toBeInTheDocument()
    expect(screen.getByText('有効・サイト0件・検索結果URL1件・1件')).toBeInTheDocument()
    const card = screen.getByRole('article')
    expect(within(card).getByText('売り切れ')).toBeInTheDocument()
    await user.click(screen.getByRole('button', { name: /^販売中/ }))
    expect(screen.queryByRole('article')).not.toBeInTheDocument()
    await user.click(screen.getByRole('button', { name: /^すべて/ }))
    await user.click(screen.getByRole('button', { name: '取得して保存' }))
    await waitFor(() => expect(syncCrawlSetting).toHaveBeenCalledWith(1))
    expect(toast.success).toHaveBeenCalledWith(
      '取得を開始しました。しばらくしてから再読み込みしてください',
    )
    await user.click(screen.getByRole('button', { name: '除外' }))
    await waitFor(() => expect(setCrawlResultExcluded).toHaveBeenCalledWith(10, true))
    expect(refresh).toHaveBeenCalledTimes(1)
  })
})

describe('収集結果の一覧', () => {
  it('最新の収集結果だけを表示し、収集結果を除外して詳細ページへリンクすること', async () => {
    vi.spyOn(window, 'confirm').mockReturnValue(true)
    vi.mocked(setCrawlResultExcluded).mockResolvedValue({
      data: result,
      error: null,
      status: 200,
    })
    const user = userEvent.setup()
    const results = Array.from({ length: 10 }, (_, i) => ({
      ...result,
      id: i + 1,
      externalId: `item-${i + 1}`,
      name: `Phone ${i + 1}`,
    }))
    render(
      <CrawlSettingSection
        crawlSetting={setting}
        crawlResults={results.slice(0, 8)}
      />,
    )
    expect(screen.getAllByRole('article')).toHaveLength(8)
    expect(screen.getAllByRole('button', { name: /の操作$/ })).toHaveLength(9)
    expect(screen.getByRole('link', { name: 'phone' })).toHaveAttribute(
      'href',
      '/product-monitoring/crawl-settings/1',
    )
    await user.click(screen.getByRole('button', { name: '編集' }))
    expect(screen.getByRole('dialog')).toHaveTextContent('収集設定を更新')
    expect(screen.getByRole('textbox', { name: '名前' })).toHaveValue('phone')
    await user.click(screen.getByRole('button', { name: '閉じる' }))
    expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
    await user.click(screen.getAllByRole('button', { name: '除外' })[0])
    await waitFor(() => expect(setCrawlResultExcluded).toHaveBeenCalledWith(1, true))
    expect(refresh).toHaveBeenCalled()
  })
})

it('詳細に無効状態とサイト数、追加 URL 数、結果件数を表示すること', () => {
  render(
    <CrawlSettingDetail
      crawlSetting={{ ...setting, enabled: false }}
      crawlResults={[]}
    />,
  )
  expect(screen.getByText('無効・サイト0件・検索結果URL1件・0件')).toBeInTheDocument()
})
