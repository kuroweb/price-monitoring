import { render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { beforeEach, describe, expect, it, vi } from 'vitest'

import {
  createCrawlSetting,
  getCrawlResults,
  setCrawlResultExcluded,
  updateCrawlSetting,
} from '@/features/product-monitoring/api/actions'
import type {
  CrawlResult,
  CrawlSetting,
} from '@/features/product-monitoring/api/types'
import CrawlSettingAddButton from '@/features/product-monitoring/components/CrawlSettingAddButton'
import CrawlSettingSection from '@/features/product-monitoring/components/CrawlSettingSection'

const { refresh } = vi.hoisted(() => ({ refresh: vi.fn() }))
vi.mock('next/navigation', () => ({ useRouter: () => ({ refresh }) }))
vi.mock('react-toastify', () => ({ toast: { success: vi.fn(), error: vi.fn() } }))
vi.mock('@/features/product-monitoring/api/actions', () => ({
  createCrawlSetting: vi.fn(),
  updateCrawlSetting: vi.fn(),
  destroyCrawlSetting: vi.fn(),
  syncCrawlSetting: vi.fn(),
  setCrawlResultExcluded: vi.fn(),
  getCrawlResults: vi.fn(),
}))

const mercariUrl = 'https://jp.mercari.com/search?searchKeyword=phone'
const iosysUrl = 'https://iosys.co.jp/items?q=phone'
const setting: CrawlSetting = {
  id: 1,
  name: 'phone',
  enabled: true,
  searchKeyword: null,
  platforms: [],
  searchUrls: [mercariUrl],
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

describe('収集設定', () => {
  it('検索ワードと選択したサイトを保存すること', async () => {
    vi.mocked(createCrawlSetting).mockResolvedValue({ data: setting, error: null, status: 200 })
    const user = userEvent.setup()
    render(<CrawlSettingAddButton />)
    await user.click(screen.getByRole('button', { name: '収集設定を追加' }))
    await user.type(screen.getByRole('textbox', { name: '名前' }), 'phone')
    await user.type(screen.getByRole('textbox', { name: '検索ワード' }), 'iPad Pro')
    await user.click(screen.getByRole('checkbox', { name: 'ヤフオク' }))
    await user.click(screen.getByRole('button', { name: '登録' }))
    await waitFor(() => expect(createCrawlSetting).toHaveBeenCalledWith(
      expect.objectContaining({ searchKeyword: 'iPad Pro', platforms: ['yahoo_auction'], searchUrls: [] }),
    ))
  })

  it('検索 URL と共通キーワードを一つの設定に保存し、各 URL のサイトを表示すること', async () => {
    vi.mocked(createCrawlSetting).mockResolvedValue({
      data: setting,
      error: null,
      status: 200,
    })
    const user = userEvent.setup()
    render(<CrawlSettingAddButton />)
    await user.click(screen.getByRole('button', { name: '収集設定を追加' }))
    await user.type(screen.getByRole('textbox', { name: '名前' }), 'phone')
    await user.type(screen.getByRole('textbox', { name: '検索結果URL 1' }), mercariUrl)
    await user.click(screen.getByRole('button', { name: 'URLを追加' }))
    await user.type(screen.getByRole('textbox', { name: '検索結果URL 2' }), iosysUrl)
    await user.click(screen.getByRole('button', { name: 'URLを追加' }))
    const yahooUrl = 'https://paypayfleamarket.yahoo.co.jp/search/iPad%20Pro'
    await user.type(screen.getByRole('textbox', { name: '検索結果URL 3' }), yahooUrl)
    expect(screen.getAllByText('メルカリ').length).toBeGreaterThan(0)
    expect(screen.getAllByText('イオシス').length).toBeGreaterThan(0)
    expect(screen.getAllByText('Yahoo!フリマ').length).toBeGreaterThan(0)
    await user.type(screen.getByRole('textbox', { name: /必須語/ }), '　phone  blue ')
    await user.type(screen.getByRole('textbox', { name: /除外語/ }), 'junk,{Enter}case')
    expect(screen.getByText(/語句を分けるにはスペースを使います/)).toBeVisible()
    await user.click(screen.getByRole('button', { name: '登録' }))
    await waitFor(() =>
      expect(createCrawlSetting).toHaveBeenCalledWith(
        expect.objectContaining({
          searchUrls: [mercariUrl, iosysUrl, yahooUrl],
          requiredKeywords: ['phone', 'blue'],
          negativeKeywords: ['junk,', 'case'],
        }),
      ),
    )
    expect(refresh).toHaveBeenCalled()
    expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
  })

  it('設定を複製して追加モーダルを開き、新しい設定として保存すること', async () => {
    vi.mocked(createCrawlSetting).mockResolvedValue({
      data: { ...setting, id: 2 },
      error: null,
      status: 200,
    })
    const user = userEvent.setup()
    const source = {
      ...setting,
      searchUrls: [mercariUrl, iosysUrl],
      requiredKeywords: ['phone blue', 'A,B'],
      negativeKeywords: ['junk', '箱、説明書'],
      minPrice: 1000,
      maxPrice: 5000,
    }
    render(<CrawlSettingSection crawlSetting={source} crawlResults={[]} />)
    await user.click(screen.getByRole('button', { name: '複製' }))
    expect(screen.getByRole('heading', { name: '収集設定を追加' })).toBeInTheDocument()
    expect(screen.getByRole('textbox', { name: '名前' })).toHaveValue('phone（コピー）')
    expect(screen.getByRole('textbox', { name: /必須語/ })).toHaveValue('"phone blue" A,B')
    expect(getCrawlResults).not.toHaveBeenCalled()
    await user.click(screen.getByRole('button', { name: '登録' }))
    await waitFor(() =>
      expect(createCrawlSetting).toHaveBeenCalledWith(
        expect.objectContaining({
          name: 'phone（コピー）',
          enabled: true,
          searchUrls: [mercariUrl, iosysUrl],
          requiredKeywords: source.requiredKeywords,
          negativeKeywords: source.negativeKeywords,
          minPrice: 1000,
          maxPrice: 5000,
        }),
      ),
    )
    expect(updateCrawlSetting).not.toHaveBeenCalled()
    expect(refresh).toHaveBeenCalled()
  })

  it.each([
    ['', ['phone blue', 'A,B', '在庫、', '新品']],
    ['　64GB', ['phone blue', 'A,B', '在庫、', '新品', '64GB']],
  ])('既存の収集設定の語句を保って更新する（追記: %s）', async (addition, requiredKeywords) => {
    const source = { ...setting, requiredKeywords: ['phone blue', 'A,B', '在庫、', '新品'], negativeKeywords: ['broken case'] }
    vi.mocked(updateCrawlSetting).mockResolvedValue({ data: source, error: null, status: 200 })
    const user = userEvent.setup()
    render(<CrawlSettingSection crawlSetting={source} crawlResults={[]} />)
    await user.click(screen.getByRole('button', { name: '編集' }))
    const required = screen.getByRole('textbox', { name: /必須語/ })
    expect(required).toHaveValue('"phone blue" A,B 在庫、 新品')
    await user.click(required)
    expect(screen.queryByText(/語句を分けるにはスペースを使います/)).not.toBeInTheDocument()
    if (addition) await user.type(required, addition)
    await user.click(screen.getByRole('button', { name: '更新' }))
    expect(updateCrawlSetting).toHaveBeenCalledWith(1, expect.objectContaining({
      requiredKeywords, negativeKeywords: source.negativeKeywords,
    }))
  })

  it('複製した名前を255文字以内に収めること', async () => {
    const user = userEvent.setup()
    render(
      <CrawlSettingSection
        crawlSetting={{ ...setting, name: 'a'.repeat(255) }}
        crawlResults={[]}
      />,
    )
    await user.click(screen.getByRole('button', { name: '複製' }))
    expect(screen.getByRole('textbox', { name: '名前' })).toHaveValue(
      `${'a'.repeat(250)}（コピー）`,
    )
  })

  it('除外した収集結果をリンク付きで一覧表示し、その場で復元すること', async () => {
    const user = userEvent.setup()
    vi.mocked(setCrawlResultExcluded).mockResolvedValue({
      data: { ...result, id: 2 },
      error: null,
      status: 200,
    })
    vi.mocked(getCrawlResults).mockResolvedValue({
      data: {
        crawlResults: [1, 2, 3].map((id) => ({
          ...result,
          id,
          externalId: `item-${id}`,
          name: `Phone ${id}`,
          excludedAt: '2026-11-06T00:00:00+09:00',
        })),
      },
      error: null,
      status: 200,
    })
    render(<CrawlSettingSection crawlSetting={setting} crawlResults={[]} />)
    await user.click(screen.getByRole('button', { name: '編集' }))
    expect(getCrawlResults).toHaveBeenCalledWith({
      crawlSettingId: 1,
      excluded: true,
    })
    await user.click(await screen.findByText('除外した収集結果（3件）'))
    expect(screen.getByRole('link', { name: 'Phone 2' })).toHaveAttribute('href', result.productUrl)
    await user.click(screen.getByRole('button', { name: 'Phone 2の除外を取り消す' }))
    await waitFor(() => expect(setCrawlResultExcluded).toHaveBeenCalledWith(2, false))
    expect(screen.getByText('除外した収集結果（2件）')).toBeInTheDocument()
    expect(refresh).toHaveBeenCalled()
  })
})

it('結果一覧から設定を削除すること', async () => {
  const { destroyCrawlSetting } = await import('@/features/product-monitoring/api/actions')
  vi.mocked(destroyCrawlSetting).mockResolvedValue({ data: {}, error: null, status: 200 })
  vi.spyOn(window, 'confirm').mockReturnValue(true)
  const user = userEvent.setup()
  render(
    <CrawlSettingSection
      crawlSetting={{ ...setting, enabled: false }}
      crawlResults={[]}
    />,
  )
  await user.click(screen.getByRole('button', { name: '削除' }))
  await waitFor(() => expect(destroyCrawlSetting).toHaveBeenCalledWith(1))
  expect(refresh).toHaveBeenCalled()
})
