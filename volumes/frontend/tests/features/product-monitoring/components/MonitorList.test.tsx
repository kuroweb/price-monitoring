import { render, screen, waitFor, within } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { beforeEach, describe, expect, it, vi } from 'vitest'

import {
  createMonitor,
  destroyMonitor,
  setCrawlResultExcluded,
  updateMonitor,
} from '@/features/product-monitoring/api/actions'
import type {
  CrawlResult,
  GetMonitorSummary,
  Monitor,
} from '@/features/product-monitoring/api/types'
import MonitorList from '@/features/product-monitoring/components/MonitorList'

const { refresh } = vi.hoisted(() => ({ refresh: vi.fn() }))
vi.mock('next/navigation', () => ({ useRouter: () => ({ refresh }) }))
vi.mock('react-toastify', () => ({ toast: { success: vi.fn(), error: vi.fn() } }))
vi.mock('@/features/product-monitoring/api/actions', () => ({
  createMonitor: vi.fn(),
  updateMonitor: vi.fn(),
  destroyMonitor: vi.fn(),
  setCrawlResultExcluded: vi.fn(),
}))

const monitor: Monitor = {
  id: 1,
  name: 'phone',
  enabled: true,
  discordEnabled: true,
  newestNotificationEnabled: false,
  requiredKeywords: ['phone'],
  negativeKeywords: ['case'],
  minPrice: null,
  maxPrice: 1000,
}
const summary: GetMonitorSummary = { lowestPrice: 700, latestAverageTransactionPrice: 900 }
const result: CrawlResult = {
  id: 1,
  crawlSettingId: 1,
  platform: 'iosys',
  externalId: '1',
  name: 'phone listing',
  productUrl: 'https://iosys.co.jp/item/1',
  thumbnailUrl: null,
  price: 800,
  buyoutPrice: null,
  sold: false,
  soldAt: null,
  endsAt: null,
  excludedAt: null,
}

beforeEach(() => vi.clearAllMocks())

describe('商品モニタリング', () => {
  it('設定した条件と通知の指定を登録する', async () => {
    vi.mocked(createMonitor).mockResolvedValue({
      data: monitor,
      error: null,
      status: 200,
    })
    const user = userEvent.setup()
    render(<MonitorList sections={[]} />)
    await user.click(screen.getByRole('button', { name: 'モニタリング設定を追加' }))
    await user.type(screen.getByRole('textbox', { name: '名前' }), 'phone')
    await user.type(screen.getByRole('textbox', { name: /必須語/ }), 'phone、 blue')
    expect(screen.getByText(/語句を分けるにはスペースを使います/)).toBeVisible()
    await user.type(screen.getByRole('textbox', { name: /除外語/ }), 'case')
    await user.type(screen.getByRole('spinbutton', { name: '最高価格（円）' }), '1000')
    await user.click(screen.getByRole('checkbox', { name: '新着を通知する' }))
    await user.click(screen.getByRole('button', { name: '登録' }))
    await waitFor(() =>
      expect(createMonitor).toHaveBeenCalledWith({
        name: 'phone',
        enabled: true,
        discordEnabled: true,
        newestNotificationEnabled: true,
        requiredKeywords: ['phone、', 'blue'],
        negativeKeywords: ['case'],
        minPrice: null,
        maxPrice: 1000,
      }),
    )
    expect(refresh).toHaveBeenCalled()
  })

  it('最安値と直近の平均取引価格を summary から表示し、確認後に設定を削除する', async () => {
    vi.spyOn(window, 'confirm').mockReturnValue(true)
    vi.mocked(destroyMonitor).mockResolvedValue({
      data: null,
      error: null,
      status: 200,
    })
    const user = userEvent.setup()
    render(
      <MonitorList
        sections={[{ monitor, crawlResults: [result], summary }]}
      />,
    )
    expect(screen.getByText('¥700')).toBeInTheDocument()
    expect(screen.getByText('¥900')).toBeInTheDocument()
    const menuButton = screen.getByRole('button', { name: 'phoneの操作' })
    await user.click(menuButton)
    await user.click(within(menuButton.parentElement!).getByRole('button', { name: '削除' }))
    await waitFor(() => expect(destroyMonitor).toHaveBeenCalledWith(1))
  })

  it('summary の取得失敗と該当なしを区別する', () => {
    const { rerender } = render(
      <MonitorList sections={[{ monitor, crawlResults: [result], summary: null }]} />,
    )
    expect(screen.getAllByText('取得失敗')).toHaveLength(2)
    expect(screen.getByRole('list', { name: '収集結果を新着順に表示' })).toBeInTheDocument()
    rerender(
      <MonitorList
        sections={[{ monitor, crawlResults: [], summary: { lowestPrice: null, latestAverageTransactionPrice: null } }]}
      />,
    )
    expect(screen.getByText('該当する収集結果なし')).toBeInTheDocument()
    expect(screen.getByText('集計データなし')).toBeInTheDocument()
  })

  it('収集結果の取得失敗を示し、最安値と平均取引価格は表示する', () => {
    render(<MonitorList sections={[{ monitor, crawlResults: null, summary }]} />)
    expect(screen.getByRole('alert')).toHaveTextContent('収集結果を取得できませんでした。再読み込みしてください。')
    expect(screen.getByText('¥700')).toBeInTheDocument()
    expect(screen.getByText('¥900')).toBeInTheDocument()
  })

  it('売り切れを含む収集結果を新着順のプレビューで表示し、詳細へ移動できる', () => {
    const second = { ...result, id: 2, name: 'phone second', price: 900, sold: true }
    render(<MonitorList sections={[{ monitor, crawlResults: [second, result], summary }]} />)
    const items = within(screen.getByRole('list', { name: '収集結果を新着順に表示' })).getAllByRole('listitem').filter((item) => item.querySelector('a'))
    expect(items[0]).toHaveTextContent('phone second')
    expect(items[1]).toHaveTextContent('phone listing')
    expect(screen.getByRole('link', { name: 'phone' })).toHaveAttribute('href', '/product-monitoring/monitors/1')
  })

  it('商品画像の操作メニューから除外できる', async () => {
    vi.spyOn(window, 'confirm').mockReturnValue(true)
    vi.mocked(setCrawlResultExcluded).mockResolvedValue({ data: result, error: null, status: 200 })
    const user = userEvent.setup()
    render(<MonitorList sections={[{ monitor, crawlResults: [result], summary }]} />)
    await user.click(screen.getByRole('button', { name: 'phone listingの操作' }))
    await user.click(screen.getByRole('button', { name: '除外' }))
    await waitFor(() => expect(setCrawlResultExcluded).toHaveBeenCalledWith(result.id, true))
    expect(refresh).toHaveBeenCalled()
  })

  it('編集と複製で新着通知の指定を引き継ぐ', async () => {
    const newest = {
      ...monitor,
      newestNotificationEnabled: true,
      requiredKeywords: ['phone blue', 'A,B'],
      negativeKeywords: ['broken case', '箱、説明書'],
    }
    vi.mocked(updateMonitor).mockResolvedValue({ data: newest, error: null, status: 200 })
    vi.mocked(createMonitor).mockResolvedValue({ data: newest, error: null, status: 200 })
    const user = userEvent.setup()
    render(<MonitorList sections={[{ monitor: newest, crawlResults: [], summary }]} />)

    await user.click(screen.getByRole('button', { name: 'phoneの操作' }))
    await user.click(screen.getByRole('button', { name: '編集' }))
    expect(screen.getByRole('checkbox', { name: '新着を通知する' })).toBeChecked()
    expect(screen.getByRole('textbox', { name: '必須語' })).toHaveValue('"phone blue" A,B')
    expect(screen.getByRole('textbox', { name: '除外語' })).toHaveValue('"broken case" 箱、説明書')
    await user.click(screen.getByRole('button', { name: '更新' }))
    await waitFor(() => expect(updateMonitor).toHaveBeenCalledWith(1, expect.objectContaining({
      newestNotificationEnabled: true,
      requiredKeywords: newest.requiredKeywords,
      negativeKeywords: newest.negativeKeywords,
    })))

    await user.click(screen.getByRole('button', { name: 'phoneの操作' }))
    await user.click(screen.getByRole('button', { name: '複製' }))
    expect(screen.getByRole('checkbox', { name: '新着を通知する' })).toBeChecked()
    await user.click(screen.getByRole('button', { name: '登録' }))
    await waitFor(() => expect(createMonitor).toHaveBeenCalledWith(expect.objectContaining({ newestNotificationEnabled: true })))
  })

   it('既存の条件を引き継いで新しい設定を複製する', async () => {
    vi.mocked(createMonitor).mockResolvedValue({ data: monitor, error: null, status: 200 })
    const user = userEvent.setup()
    render(<MonitorList sections={[{ monitor, crawlResults: [], summary }]} />)
    await user.click(screen.getByRole('button', { name: 'phoneの操作' }))
    await user.click(screen.getByRole('button', { name: '複製' }))
    expect(screen.getByRole('textbox', { name: '名前' })).toHaveValue('phone（コピー）')
    expect(screen.getByRole('textbox', { name: /必須語/ })).toHaveValue('phone')
    await user.click(screen.getByRole('button', { name: '登録' }))
    await waitFor(() => expect(createMonitor).toHaveBeenCalledWith(expect.objectContaining({
      name: 'phone（コピー）', requiredKeywords: ['phone'], negativeKeywords: ['case'], maxPrice: 1000,
    })))
  })
})
