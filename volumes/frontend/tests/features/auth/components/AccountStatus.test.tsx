import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { beforeEach, describe, expect, it, vi } from 'vitest'

import { getCurrentUser } from '@/features/auth/api/actions'
import AccountStatus from '@/features/auth/components/AccountStatus'

vi.mock('@/features/auth/api/actions', () => ({ getCurrentUser: vi.fn(), logout: vi.fn() }))

beforeEach(() => {
  vi.mocked(getCurrentUser).mockReset()
})

describe('AccountStatus', () => {
  it('ログイン中はユーザー名を表示し、ログインの入口を出さないこと', async () => {
    vi.mocked(getCurrentUser).mockResolvedValue({
      data: { currentUser: { name: '会員', email: 'member@example.com' } },
      error: null,
      status: 200,
    })
    render(<AccountStatus />)

    expect(await screen.findByText('会員')).toBeInTheDocument()
    expect(screen.queryByRole('link', { name: 'ログイン・新規登録' })).toBeNull()
  })

  it('未ログインならログインと新規登録の入口へ遷移できること', async () => {
    vi.mocked(getCurrentUser).mockResolvedValue({ data: { currentUser: null }, error: null, status: 200 })
    render(<AccountStatus />)

    expect(await screen.findByRole('link', { name: 'ログイン・新規登録' })).toHaveAttribute(
      'href',
      '/auth/auth_provider',
    )
  })

  it('名前からマイページとログアウトのメニューを開けること', async () => {
    vi.mocked(getCurrentUser).mockResolvedValue({ data: { currentUser: { name: '会員', email: 'member@example.com' } }, error: null, status: 200 })
    render(<AccountStatus />)
    await userEvent.click(await screen.findByText('会員'))
    expect(screen.getByRole('link', { name: 'マイページ' })).toHaveAttribute('href', '/mypage')
    expect(screen.getByRole('button', { name: 'ログアウト' })).toBeInTheDocument()
  })

  it('ログイン状態を取得できなければログインの入口を表示すること', async () => {
    vi.mocked(getCurrentUser).mockRejectedValue(new Error('Unexpected error occurred.'))
    render(<AccountStatus />)

    expect(await screen.findByRole('link', { name: 'ログイン・新規登録' })).toBeInTheDocument()
  })
})
