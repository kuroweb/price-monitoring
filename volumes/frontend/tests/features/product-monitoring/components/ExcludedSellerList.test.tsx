import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { toast } from 'react-toastify'
import { beforeEach, describe, expect, it, vi } from 'vitest'

import { createExcludedSeller, destroyExcludedSeller } from '@/features/product-monitoring/api/actions'
import type { ExcludedSeller } from '@/features/product-monitoring/api/types'
import ExcludedSellerList from '@/features/product-monitoring/components/ExcludedSellerList'

const { refresh } = vi.hoisted(() => ({ refresh: vi.fn() }))
vi.mock('next/navigation', () => ({ useRouter: () => ({ refresh }) }))
vi.mock('react-toastify', () => ({ toast: { success: vi.fn(), error: vi.fn() } }))
vi.mock('@/features/product-monitoring/api/actions', () => ({
  createExcludedSeller: vi.fn(),
  destroyExcludedSeller: vi.fn(),
}))

const seller: ExcludedSeller = {
  id: 1,
  platform: 'yahoo_auction',
  sellerId: 'Seller_1',
  createdAt: '2026-11-28T09:00:00.000+09:00',
}

beforeEach(() => vi.clearAllMocks())

describe('除外する出品者', () => {
  it('選んだサイトと前後の空白を除いた出品者IDを登録し、画面を読み直す', async () => {
    vi.mocked(createExcludedSeller).mockResolvedValue({
      data: { ...seller, platform: 'yahoo_fleamarket' },
      error: null,
      status: 200,
    })
    const user = userEvent.setup()
    render(<ExcludedSellerList excludedSellers={[]} />)
    expect(screen.getByText('除外する出品者はまだありません。')).toBeInTheDocument()
    expect(screen.getByRole('button', { name: '登録' })).toBeDisabled()

    await user.selectOptions(screen.getByLabelText('サイト'), 'yahoo_fleamarket')
    await user.type(screen.getByLabelText('出品者ID'), ' Seller_1 ')
    await user.click(screen.getByRole('button', { name: '登録' }))

    expect(createExcludedSeller).toHaveBeenCalledWith({ platform: 'yahoo_fleamarket', sellerId: 'Seller_1' })
    expect(refresh).toHaveBeenCalled()
    expect(screen.getByLabelText('出品者ID')).toHaveValue('')
  })

  it('登録済みの組とサーバの検証エラーを知らせ、入力を残す', async () => {
    vi.mocked(createExcludedSeller)
      .mockResolvedValueOnce({ data: null, error: { code: 409, message: 'Conflict.', details: [] }, status: 409 })
      .mockResolvedValueOnce({ data: null, error: { code: 400, message: '出品者IDは…', details: [] }, status: 400 })
    const user = userEvent.setup()
    render(<ExcludedSellerList excludedSellers={[]} />)
    await user.type(screen.getByLabelText('出品者ID'), 'Seller_1')
    await user.click(screen.getByRole('button', { name: '登録' }))
    expect(toast.error).toHaveBeenLastCalledWith('この出品者は登録済みです')
    await user.click(screen.getByRole('button', { name: '登録' }))
    expect(toast.error).toHaveBeenLastCalledWith('出品者IDは…')
    expect(screen.getByLabelText('出品者ID')).toHaveValue('Seller_1')
    expect(refresh).not.toHaveBeenCalled()
  })

  it('登録済みの出品者を並べ、確認してから解除する', async () => {
    vi.mocked(destroyExcludedSeller).mockResolvedValue({ data: {}, error: null, status: 200 })
    const confirm = vi.spyOn(window, 'confirm').mockReturnValueOnce(false).mockReturnValueOnce(true)
    const user = userEvent.setup()
    render(<ExcludedSellerList excludedSellers={[seller]} />)
    expect(screen.getByRole('cell', { name: 'ヤフオク' })).toBeInTheDocument()
    expect(screen.getByRole('cell', { name: 'Seller_1' })).toBeInTheDocument()

    const release = screen.getByRole('button', { name: 'ヤフオクの出品者「Seller_1」の除外を解除する' })
    await user.click(release)
    expect(destroyExcludedSeller).not.toHaveBeenCalled()
    await user.click(release)
    expect(destroyExcludedSeller).toHaveBeenCalledWith(1)
    expect(refresh).toHaveBeenCalled()
    confirm.mockRestore()
  })
})
