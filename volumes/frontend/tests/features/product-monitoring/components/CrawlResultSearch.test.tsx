import { render, screen, waitFor, within } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { beforeEach, expect, it, vi } from 'vitest'

import { createMonitor, searchCrawlResults } from '@/features/product-monitoring/api/actions'
import type { CrawlResult } from '@/features/product-monitoring/api/types'
import CrawlResultSearch from '@/features/product-monitoring/components/CrawlResultSearch'

vi.mock('next/navigation', () => ({ useRouter: () => ({ refresh: vi.fn() }) }))
vi.mock('react-toastify', () => ({ toast: { success: vi.fn() } }))
vi.mock('@/features/product-monitoring/api/actions', () => ({
  searchCrawlResults: vi.fn(),
  createMonitor: vi.fn(),
}))

const listing: CrawlResult = {
  id: 1,
  crawlSettingId: 1,
  platform: 'iosys',
  externalId: 'item-1',
  name: 'iPad Pro',
  productUrl: 'https://iosys.co.jp/items/item-1',
  thumbnailUrl: null,
  price: 1200,
  buyoutPrice: null,
  sold: false,
  soldAt: null,
  endsAt: null,
  excludedAt: null,
}

beforeEach(() => vi.resetAllMocks())

it('Enter で検索し、結果の操作と新規登録に表示中の検索条件を使う', async () => {
  const user = userEvent.setup()
  vi.mocked(searchCrawlResults)
    .mockResolvedValueOnce({
      data: { crawlResults: [listing], page: 1, perPage: 12, hasMore: true }, error: null, status: 200,
    })
    .mockResolvedValueOnce({
      data: { crawlResults: [listing], page: 1, perPage: 12, hasMore: true }, error: null, status: 200,
    })
    .mockResolvedValueOnce({
      data: { crawlResults: [{ ...listing, id: 2, name: 'iPad Pro 2' }], page: 2, perPage: 12, hasMore: false },
      error: null,
      status: 200,
    })
  vi.mocked(createMonitor).mockImplementation(async (input) => ({
    data: { ...input, id: 2 }, error: null, status: 200,
  }))
  render(<CrawlResultSearch />)

  const required = screen.getByLabelText(/必須語/)
  await user.type(required, '  "iPad Pro"　64GB Wi-Fi  ')
  await user.click(screen.getByRole('button', { name: '絞り込み' }))
  await user.type(screen.getByLabelText(/除外語/), '傷,割れ　箱、説明書')
  await user.type(screen.getByLabelText(/最低価格/), '1000')
  await user.type(screen.getByLabelText(/最高価格/), '2000{enter}')
  expect(await screen.findByText('iPad Pro')).toBeInTheDocument()
  const criteria = { requiredKeywords: ['iPad Pro', '64GB', 'Wi-Fi'], negativeKeywords: ['傷,割れ', '箱、説明書'], minPrice: 1000, maxPrice: 2000 }
  expect(searchCrawlResults).toHaveBeenLastCalledWith({ ...criteria, saleStatus: 'all', sort: 'newest', page: 1 })
  await user.keyboard('{Escape}')
  expect(screen.getByRole('button', { name: '絞り込み' })).toHaveFocus()
  expect(screen.getByText('必須："iPad Pro" 64GB Wi-Fi')).toBeInTheDocument()
  expect(screen.getByText('除外：傷,割れ 箱、説明書')).toBeInTheDocument()

  await user.clear(required)
  await user.type(required, '未実行の入力')
  const results = within(screen.getByRole('region', { name: '検索結果' }))
  expect(results.queryByText(/編集中の条件は未反映/)).not.toBeInTheDocument()
  await user.selectOptions(results.getByLabelText('並び順'), 'price_asc')
  await waitFor(() => expect(results.getByLabelText('並び順')).toHaveValue('price_asc'))
  expect(searchCrawlResults).toHaveBeenLastCalledWith({ ...criteria, saleStatus: 'all', sort: 'price_asc', page: 1 })
  await user.click(screen.getByRole('button', { name: '次へ' }))
  expect(await screen.findByText('iPad Pro 2')).toBeInTheDocument()
  expect(searchCrawlResults).toHaveBeenLastCalledWith({ ...criteria, saleStatus: 'all', sort: 'price_asc', page: 2 })
  await user.click(screen.getByRole('button', { name: 'この条件でモニタリングを作成' }))

  const modal = within(screen.getByRole('dialog'))
  expect(modal.getByLabelText(/必須語/)).toHaveValue('"iPad Pro" 64GB Wi-Fi')
  expect(modal.getByLabelText(/除外語/)).toHaveValue('傷,割れ 箱、説明書')
  expect(modal.getByLabelText(/最安値の変化を通知/)).not.toBeChecked()
  expect(modal.getByLabelText(/新着を通知/)).not.toBeChecked()
  expect(createMonitor).not.toHaveBeenCalled()
  await user.type(modal.getByRole('textbox', { name: '名前' }), 'iPad 用')
  await user.click(modal.getByRole('button', { name: '登録' }))
  expect(createMonitor).toHaveBeenCalledWith({
    ...criteria, name: 'iPad 用', enabled: false, discordEnabled: true, newestNotificationEnabled: false,
  })
  await waitFor(() => expect(screen.queryByRole('dialog')).not.toBeInTheDocument())
})

it('検索前、失敗、0件を区別し、結果が0件でも条件を引き継げる', async () => {
  const user = userEvent.setup()
  const createButton = { name: 'この条件でモニタリングを作成' }
  vi.mocked(searchCrawlResults)
    .mockResolvedValueOnce({ data: null, error: null, status: 503 })
    .mockResolvedValueOnce({
      data: { crawlResults: [], page: 1, perPage: 12, hasMore: false }, error: null, status: 200,
    })
  render(<CrawlResultSearch />)

  expect(screen.getByRole('form', { name: '検索条件' })).toBeInTheDocument()
  expect(screen.queryByRole('region', { name: '検索結果' })).not.toBeInTheDocument()
  expect(screen.queryByRole('button', createButton)).not.toBeInTheDocument()
  await user.click(screen.getByRole('button', { name: '検索' }))
  expect(await screen.findByRole('alert')).toHaveTextContent('収集結果を取得できませんでした。')
  expect(screen.queryByRole('button', createButton)).not.toBeInTheDocument()

  await user.type(screen.getByLabelText(/必須語/), '未入荷')
  await user.keyboard('{Enter}')
  expect(await screen.findByText('該当する収集結果はありません。')).toBeInTheDocument()
  await user.click(screen.getByRole('button', createButton))
  expect(within(screen.getByRole('dialog')).getByLabelText(/必須語/)).toHaveValue('未入荷')
})

it('必須語が空でも、閉じた絞り込みを検索に使える', async () => {
  const user = userEvent.setup()
  vi.mocked(searchCrawlResults).mockResolvedValue({
    data: { crawlResults: [], page: 1, perPage: 12, hasMore: false },
    error: null,
    status: 200,
  })
  render(<CrawlResultSearch />)

  const toggle = screen.getByRole('button', { name: '絞り込み' })
  expect(toggle).toHaveAttribute('aria-expanded', 'false')
  expect(screen.getByLabelText('除外語')).not.toBeVisible()
  await user.click(toggle)
  await user.type(screen.getByLabelText('除外語'), 'ジャンク')
  await user.type(screen.getByLabelText(/最低価格/), '1000')
  await user.click(toggle)
  expect(screen.getByText('未送信の絞り込み')).toBeInTheDocument()
  expect(searchCrawlResults).not.toHaveBeenCalled()

  await user.click(screen.getByRole('button', { name: '検索' }))
  const results = within(await screen.findByRole('region', { name: '検索結果' }))
  const applied = await results.findByText('適用中')
  expect(applied.compareDocumentPosition(results.getByRole('group', { name: '販売状態' }))).toBe(
    Node.DOCUMENT_POSITION_FOLLOWING,
  )
  expect(results.getByText('除外：ジャンク')).toBeInTheDocument()
  expect(searchCrawlResults).toHaveBeenCalledWith({
    requiredKeywords: [], negativeKeywords: ['ジャンク'], minPrice: 1000, maxPrice: null,
    saleStatus: 'all', sort: 'newest', page: 1,
  })
})

it('販売状態を切り替えると、売り切れ・販売中・すべての結果を分け、1ページ目に戻す', async () => {
  const user = userEvent.setup()
  const onSale = { ...listing, id: 1, name: '販売中の出品', sold: false }
  const unknown = { ...listing, id: 2, name: '状態不明の出品', sold: null }
  const sold = { ...listing, id: 3, name: '売り切れの出品', sold: true }
  const soldNext = { ...listing, id: 4, name: '売り切れの2ページ目', sold: true }
  const page = (items: CrawlResult[], current: number, hasMore: boolean) => ({
    data: { crawlResults: items, page: current, perPage: 12, hasMore }, error: null, status: 200,
  })
  vi.mocked(searchCrawlResults)
    .mockResolvedValueOnce(page([onSale, unknown, sold], 1, true))
    .mockResolvedValueOnce(page([soldNext], 2, false))
    .mockResolvedValueOnce(page([sold], 1, false))
    .mockResolvedValueOnce(page([onSale, unknown], 1, false))
    .mockResolvedValueOnce(page([onSale, unknown, sold], 1, true))
  render(<CrawlResultSearch />)

  await user.click(screen.getByRole('button', { name: '検索' }))
  const results = within(await screen.findByRole('region', { name: '検索結果' }))
  expect(results.getByRole('button', { name: /^すべて$/ })).toHaveAttribute('aria-pressed', 'true')
  expect(results.getByRole('button', { name: /^販売中$/ })).toBeInTheDocument()
  expect(results.getByRole('button', { name: /^売り切れ$/ })).toBeInTheDocument()
  expect(results.getByText('販売中の出品')).toBeInTheDocument()
  expect(results.getByText('状態不明の出品')).toBeInTheDocument()
  expect(results.getByText('売り切れの出品')).toBeInTheDocument()

  await user.click(results.getByRole('button', { name: '次へ' }))
  expect(await results.findByText('売り切れの2ページ目')).toBeInTheDocument()
  expect(searchCrawlResults).toHaveBeenLastCalledWith({
    requiredKeywords: [], negativeKeywords: [], minPrice: null, maxPrice: null,
    saleStatus: 'all', sort: 'newest', page: 2,
  })

  await user.click(results.getByRole('button', { name: '売り切れ' }))
  expect(await results.findByText('売り切れの出品')).toBeInTheDocument()
  expect(results.queryByText('売り切れの2ページ目')).not.toBeInTheDocument()
  expect(results.queryByText('販売中の出品')).not.toBeInTheDocument()
  expect(results.queryByText('状態不明の出品')).not.toBeInTheDocument()
  expect(results.getByRole('button', { name: '売り切れ' })).toHaveAttribute('aria-pressed', 'true')
  expect(searchCrawlResults).toHaveBeenLastCalledWith({
    requiredKeywords: [], negativeKeywords: [], minPrice: null, maxPrice: null,
    saleStatus: 'sold', sort: 'newest', page: 1,
  })

  await user.click(results.getByRole('button', { name: '販売中' }))
  expect(await results.findByText('販売中の出品')).toBeInTheDocument()
  expect(results.getByText('状態不明の出品')).toBeInTheDocument()
  expect(results.queryByText('売り切れの出品')).not.toBeInTheDocument()
  expect(searchCrawlResults).toHaveBeenLastCalledWith({
    requiredKeywords: [], negativeKeywords: [], minPrice: null, maxPrice: null,
    saleStatus: 'on_sale', sort: 'newest', page: 1,
  })

  await user.click(results.getByRole('button', { name: 'すべて' }))
  expect(await results.findByText('売り切れの出品')).toBeInTheDocument()
  expect(results.getByText('販売中の出品')).toBeInTheDocument()
  expect(results.getByText('状態不明の出品')).toBeInTheDocument()
  expect(searchCrawlResults).toHaveBeenLastCalledWith({
    requiredKeywords: [], negativeKeywords: [], minPrice: null, maxPrice: null,
    saleStatus: 'all', sort: 'newest', page: 1,
  })
})
