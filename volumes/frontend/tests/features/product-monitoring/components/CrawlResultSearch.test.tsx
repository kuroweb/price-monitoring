import { render, screen, waitFor, within } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { toast } from 'react-toastify'
import { beforeEach, expect, it, vi } from 'vitest'

import { createMonitor, destroyCrawlResult, searchCrawlResults, setCrawlResultExcluded } from '@/features/product-monitoring/api/actions'
import type { CrawlResult } from '@/features/product-monitoring/api/types'
import CrawlResultSearch from '@/features/product-monitoring/components/CrawlResultSearch'

vi.mock('next/navigation', () => ({ useRouter: () => ({ refresh: vi.fn() }) }))
vi.mock('react-toastify', () => ({ toast: { success: vi.fn(), error: vi.fn() } }))
vi.mock('@/features/product-monitoring/api/actions', () => ({
  searchCrawlResults: vi.fn(),
  createMonitor: vi.fn(),
  setCrawlResultExcluded: vi.fn(),
  destroyCrawlResult: vi.fn(),
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

const resultPage = (items: CrawlResult[], current: number, hasMore: boolean) => ({
  data: { crawlResults: items, page: current, perPage: 12, hasMore }, error: null, status: 200,
})

const appliedQuery = {
  requiredKeywords: ['iPad'],
  negativeKeywords: ['ジャンク'],
  minPrice: 1000,
  maxPrice: null,
  saleStatus: 'sold' as const,
  sort: 'price_desc' as const,
  page: 2,
}

const cardFor = (name: string) => {
  const article = screen.getByText(name).closest('article')
  if (!(article instanceof HTMLElement)) throw new Error(`${name}のカードがありません`)
  return within(article)
}

it('確認後にその収集結果だけを除外・削除し、同じ条件のページを検索し直してカードを消す', async () => {
  const user = userEvent.setup()
  const confirm = vi.spyOn(window, 'confirm').mockReturnValue(false)
  const target = { ...listing, id: 11, name: '対象の出品', crawlSettingId: 4, externalId: 'target' }
  const other = { ...listing, id: 22, name: '残る出品', crawlSettingId: 9, externalId: 'other' }
  vi.mocked(searchCrawlResults)
    .mockResolvedValueOnce(resultPage([target, other], 1, true))
    .mockResolvedValueOnce(resultPage([target, other], 1, true))
    .mockResolvedValueOnce(resultPage([target, other], 1, true))
    .mockResolvedValueOnce(resultPage([target, other], 2, false))
    .mockResolvedValueOnce(resultPage([other], 2, false))
    .mockResolvedValueOnce(resultPage([], 2, false))
  vi.mocked(setCrawlResultExcluded).mockResolvedValue({
    data: { ...target, excludedAt: '2026-11-25T00:00:00Z' }, error: null, status: 200,
  })
  vi.mocked(destroyCrawlResult).mockResolvedValue({ data: {}, error: null, status: 200 })
  render(<CrawlResultSearch />)

  try {
    await user.type(screen.getByLabelText(/必須語/), 'iPad')
    await user.click(screen.getByRole('button', { name: '絞り込み' }))
    await user.type(screen.getByLabelText('除外語'), 'ジャンク')
    await user.type(screen.getByLabelText(/最低価格/), '1000')
    await user.click(screen.getByRole('button', { name: '絞り込んで検索' }))
    const results = within(await screen.findByRole('region', { name: '検索結果' }))
    await user.click(results.getByRole('button', { name: '売り切れ' }))
    await waitFor(() => {
      expect(results.getByRole('button', { name: '売り切れ' })).toHaveAttribute('aria-pressed', 'true')
    })
    await user.selectOptions(results.getByLabelText('並び順'), 'price_desc')
    await waitFor(() => expect(results.getByLabelText('並び順')).toHaveValue('price_desc'))
    await user.click(results.getByRole('button', { name: '次へ' }))
    expect(await results.findByText('対象の出品')).toBeInTheDocument()
    expect(searchCrawlResults).toHaveBeenLastCalledWith(appliedQuery)

    await user.clear(screen.getByLabelText(/必須語/))
    await user.type(screen.getByLabelText(/必須語/), '未実行の入力')
    expect(screen.queryByText(/編集中の条件は未反映/)).not.toBeInTheDocument()

    const searches = vi.mocked(searchCrawlResults).mock.calls.length
    await user.click(cardFor('対象の出品').getByRole('button', { name: '除外' }))
    expect(confirm).toHaveBeenCalledWith('「対象の出品」を除外しますか？')
    expect(setCrawlResultExcluded).not.toHaveBeenCalled()
    expect(destroyCrawlResult).not.toHaveBeenCalled()
    expect(searchCrawlResults).toHaveBeenCalledTimes(searches)
    expect(results.getByText('対象の出品')).toBeInTheDocument()

    confirm.mockReturnValue(true)
    await user.click(cardFor('対象の出品').getByRole('button', { name: '除外' }))
    await waitFor(() => expect(setCrawlResultExcluded).toHaveBeenCalledWith(target.id, true))
    expect(setCrawlResultExcluded).toHaveBeenCalledTimes(1)
    expect(setCrawlResultExcluded).not.toHaveBeenCalledWith(other.id, true)
    expect(searchCrawlResults).toHaveBeenLastCalledWith(appliedQuery)
    await waitFor(() => expect(results.queryByText('対象の出品')).not.toBeInTheDocument())
    expect(results.getByText('残る出品')).toBeInTheDocument()
    expect(results.getByRole('button', { name: '2ページ' })).toHaveAttribute('aria-current', 'page')

    confirm.mockReturnValue(false)
    const searchesAfterExclude = vi.mocked(searchCrawlResults).mock.calls.length
    await user.click(cardFor('残る出品').getByRole('button', { name: '削除' }))
    expect(confirm).toHaveBeenCalledWith('「残る出品」を削除しますか？再取得時に再登録されることがあります。')
    expect(destroyCrawlResult).not.toHaveBeenCalled()
    expect(searchCrawlResults).toHaveBeenCalledTimes(searchesAfterExclude)
    expect(results.getByText('残る出品')).toBeInTheDocument()

    confirm.mockReturnValue(true)
    await user.click(cardFor('残る出品').getByRole('button', { name: '削除' }))
    await waitFor(() => expect(destroyCrawlResult).toHaveBeenCalledWith(other.id))
    expect(destroyCrawlResult).toHaveBeenCalledTimes(1)
    expect(destroyCrawlResult).not.toHaveBeenCalledWith(target.id)
    expect(setCrawlResultExcluded).toHaveBeenCalledTimes(1)
    expect(searchCrawlResults).toHaveBeenLastCalledWith(appliedQuery)
    expect(await results.findByText('該当する収集結果はありません。')).toBeInTheDocument()
    expect(results.queryByText('残る出品')).not.toBeInTheDocument()
    expect(results.getByRole('button', { name: '2ページ' })).toHaveAttribute('aria-current', 'page')
  } finally {
    confirm.mockRestore()
  }
})

it('除外と削除に失敗したときは検索をやり直さず、カードを残す', async () => {
  const user = userEvent.setup()
  const confirm = vi.spyOn(window, 'confirm').mockReturnValue(true)
  vi.mocked(searchCrawlResults).mockResolvedValue(resultPage([listing], 1, false))
  vi.mocked(setCrawlResultExcluded)
    .mockResolvedValueOnce({ data: null, error: null, status: 500 })
    .mockRejectedValueOnce(new Error('network'))
  vi.mocked(destroyCrawlResult)
    .mockResolvedValueOnce({ data: null, error: null, status: 500 })
    .mockRejectedValueOnce(new Error('network'))
  render(<CrawlResultSearch />)

  try {
    await user.click(screen.getByRole('button', { name: '検索' }))
    expect(await screen.findByText('iPad Pro')).toBeInTheDocument()

    await user.click(screen.getByRole('button', { name: '除外' }))
    await waitFor(() => expect(toast.error).toHaveBeenCalledWith('除外に失敗しました'))
    expect(setCrawlResultExcluded).toHaveBeenCalledWith(listing.id, true)
    expect(searchCrawlResults).toHaveBeenCalledTimes(1)
    expect(screen.getByText('iPad Pro')).toBeInTheDocument()

    await user.click(screen.getByRole('button', { name: '除外' }))
    await waitFor(() => expect(toast.error).toHaveBeenCalledWith('通信に失敗しました'))
    expect(searchCrawlResults).toHaveBeenCalledTimes(1)

    await user.click(screen.getByRole('button', { name: '削除' }))
    await waitFor(() => expect(toast.error).toHaveBeenCalledWith('削除に失敗しました'))
    expect(destroyCrawlResult).toHaveBeenCalledWith(listing.id)
    expect(searchCrawlResults).toHaveBeenCalledTimes(1)

    await user.click(screen.getByRole('button', { name: '削除' }))
    await waitFor(() => expect(toast.error).toHaveBeenLastCalledWith('通信に失敗しました'))
    expect(searchCrawlResults).toHaveBeenCalledTimes(1)
    expect(screen.getByText('iPad Pro')).toBeInTheDocument()
  } finally {
    confirm.mockRestore()
  }
})
