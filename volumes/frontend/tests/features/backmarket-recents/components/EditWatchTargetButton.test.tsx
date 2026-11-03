import { render, screen, waitFor, within } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { describe, expect, it, vi } from 'vitest'

import EditWatchTargetButton from '@/features/backmarket-recents/components/EditWatchTargetButton'
import { updateBackmarketWatchTarget } from '@/lib/actions'
import type { BackmarketWatchTarget } from '@/lib/api'

vi.mock('next/navigation', () => ({ useRouter: () => ({ refresh: vi.fn() }) }))
vi.mock('react-toastify', () => ({ toast: { success: vi.fn(), error: vi.fn() } }))
vi.mock('@/lib/actions', () => ({
  createBackmarketWatchTarget: vi.fn(),
  updateBackmarketWatchTarget: vi.fn(),
}))

const target: BackmarketWatchTarget = {
  id: 3,
  name: 'MacBook',
  url: 'https://example.test/macbook',
  enabled: true,
  createdAt: '2026-01-01T00:00:00Z',
  updatedAt: '2026-01-01T00:00:00Z',
}

describe('EditWatchTargetButton', () => {
  it('結果画面から監視対象の編集モーダルを開き、保存すると閉じる', async () => {
    const user = userEvent.setup()
    vi.mocked(updateBackmarketWatchTarget).mockResolvedValue({
      data: null,
      error: null,
      status: 200,
    })
    const { container } = render(<EditWatchTargetButton target={target} />)
    const toggle = container.querySelector<HTMLInputElement>('.modal-toggle')
    expect(toggle).not.toBeChecked()

    await user.click(screen.getByRole('button', { name: '監視設定' }))

    expect(toggle).toBeChecked()
    expect(
      within(screen.getByRole('group', { name: '名前' })).getByRole('textbox'),
    ).toHaveValue('MacBook')

    await user.click(screen.getByRole('button', { name: '更新' }))

    await waitFor(() => expect(toggle).not.toBeChecked())
    expect(updateBackmarketWatchTarget).toHaveBeenCalledExactlyOnceWith(3, {
      name: 'MacBook',
      url: target.url,
      enabled: true,
    })
  })
})
