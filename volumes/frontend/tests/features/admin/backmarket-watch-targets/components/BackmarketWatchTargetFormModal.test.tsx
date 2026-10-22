import { render, screen, waitFor, within } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { beforeEach, describe, expect, it, vi } from 'vitest'

import type { BackmarketWatchTarget } from '@/lib/api'

import BackmarketWatchTargetFormModal from '@/features/admin/backmarket-watch-targets/components/BackmarketWatchTargetFormModal'
import { createBackmarketWatchTarget, updateBackmarketWatchTarget } from '@/lib/actions'

const { refresh, successToast, errorToast } = vi.hoisted(() => ({
  refresh: vi.fn(),
  successToast: vi.fn(),
  errorToast: vi.fn(),
}))

vi.mock('next/navigation', () => ({ useRouter: () => ({ refresh }) }))
vi.mock('react-toastify', () => ({ toast: { success: successToast, error: errorToast } }))
vi.mock('@/lib/actions', () => ({
  createBackmarketWatchTarget: vi.fn(),
  updateBackmarketWatchTarget: vi.fn(),
}))

const target: BackmarketWatchTarget = {
  id: 3,
  name: 'MacBook',
  url: 'https://example.test/macbook',
  enabled: false,
  createdAt: '2026-01-01T00:00:00Z',
  updatedAt: '2026-01-01T00:00:00Z',
}

beforeEach(() => {
  vi.mocked(createBackmarketWatchTarget).mockReset()
  vi.mocked(updateBackmarketWatchTarget).mockReset()
  vi.mocked(createBackmarketWatchTarget).mockResolvedValue({ data: null, error: null, status: 200 })
  vi.mocked(updateBackmarketWatchTarget).mockResolvedValue({ data: null, error: null, status: 200 })
})

describe('BackmarketWatchTargetFormModal', () => {
  it('必須項目が空なら送信しない', async () => {
    const user = userEvent.setup()
    const onClose = vi.fn()
    render(<BackmarketWatchTargetFormModal isOpen mode='create' onClose={onClose} />)

    await user.click(screen.getByRole('button', { name: '登録' }))

    expect(createBackmarketWatchTarget).not.toHaveBeenCalled()
    expect(refresh).not.toHaveBeenCalled()
    expect(onClose).not.toHaveBeenCalled()
  })

  it('入力した監視対象を登録し、成功通知・モーダル終了・画面更新を行う', async () => {
    const user = userEvent.setup()
    const onClose = vi.fn()
    render(<BackmarketWatchTargetFormModal isOpen mode='create' onClose={onClose} />)

    await user.type(
      within(screen.getByRole('group', { name: '名前' })).getByRole('textbox'),
      'MacBook',
    )
    await user.type(
      within(screen.getByRole('group', { name: 'URL' })).getByRole('textbox'),
      target.url,
    )
    await user.click(screen.getByRole('button', { name: '登録' }))

    await waitFor(() => expect(onClose).toHaveBeenCalledOnce())
    expect(createBackmarketWatchTarget).toHaveBeenCalledExactlyOnceWith({
      name: 'MacBook',
      url: target.url,
      enabled: true,
    })
    expect(updateBackmarketWatchTarget).not.toHaveBeenCalled()
    expect(successToast).toHaveBeenCalledWith('success')
    expect(refresh).toHaveBeenCalledOnce()
  })

  it('既存値を表示し、変更した内容を対象 ID とともに更新する', async () => {
    const user = userEvent.setup()
    const onClose = vi.fn()
    render(<BackmarketWatchTargetFormModal isOpen mode='edit' target={target} onClose={onClose} />)
    const name = within(screen.getByRole('group', { name: '名前' })).getByRole('textbox')
    expect(name).toHaveValue('MacBook')
    expect(screen.getByRole('checkbox', { name: '有効' })).not.toBeChecked()

    await user.clear(name)
    await user.type(name, 'MacBook Pro')
    await user.click(screen.getByRole('checkbox', { name: '有効' }))
    await user.click(screen.getByRole('button', { name: '更新' }))

    await waitFor(() => expect(onClose).toHaveBeenCalledOnce())
    expect(updateBackmarketWatchTarget).toHaveBeenCalledExactlyOnceWith(3, {
      name: 'MacBook Pro',
      url: target.url,
      enabled: true,
    })
    expect(createBackmarketWatchTarget).not.toHaveBeenCalled()
    expect(successToast).toHaveBeenCalledWith('success')
    expect(refresh).toHaveBeenCalledOnce()
  })

  it('保存失敗では入力を保持し、モーダルを閉じずにエラーを通知する', async () => {
    const user = userEvent.setup()
    const onClose = vi.fn()
    vi.mocked(updateBackmarketWatchTarget).mockResolvedValue({
      data: null,
      status: 422,
      error: { code: 422, message: 'invalid', details: [] },
    })
    render(<BackmarketWatchTargetFormModal isOpen mode='edit' target={target} onClose={onClose} />)

    await user.click(screen.getByRole('button', { name: '更新' }))

    await waitFor(() => expect(errorToast).toHaveBeenCalledWith('error'))
    expect(onClose).not.toHaveBeenCalled()
    expect(successToast).not.toHaveBeenCalled()
    expect(screen.getByDisplayValue('MacBook')).toBeInTheDocument()
    expect(refresh).toHaveBeenCalledOnce()
  })

  it('閉じる操作では保存せずにモーダルを閉じる', async () => {
    const user = userEvent.setup()
    const onClose = vi.fn()
    render(<BackmarketWatchTargetFormModal isOpen mode='create' onClose={onClose} />)

    await user.click(screen.getByRole('button', { name: '閉じる' }))

    expect(onClose).toHaveBeenCalledOnce()
    expect(createBackmarketWatchTarget).not.toHaveBeenCalled()
    expect(refresh).not.toHaveBeenCalled()
  })
})
