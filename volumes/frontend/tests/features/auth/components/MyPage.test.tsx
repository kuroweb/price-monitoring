import { render, screen } from '@testing-library/react'
import { describe, expect, it, vi } from 'vitest'

import { getCurrentUser } from '@/features/auth/api/actions'
import MyPage from '@/features/auth/components/MyPage'

vi.mock('@/features/auth/api/actions', () => ({ getCurrentUser: vi.fn() }))

describe('MyPage', () => {
  it('ログイン中の名前とメールアドレスを表示すること', async () => {
    vi.mocked(getCurrentUser).mockResolvedValue({ data: { currentUser: { name: '会員', email: 'member@example.com' } }, error: null, status: 200 })
    render(await MyPage())
    expect(screen.getByText('会員')).toBeInTheDocument()
    expect(screen.getByText('member@example.com')).toBeInTheDocument()
  })

  it('未ログイン時にログインの入口を表示すること', async () => {
    vi.mocked(getCurrentUser).mockResolvedValue({ data: { currentUser: null }, error: null, status: 200 })
    render(await MyPage())
    expect(screen.getByRole('link', { name: 'ログイン・新規登録' })).toHaveAttribute('href', '/auth/auth_provider')
  })
})
