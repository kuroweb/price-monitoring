import { render, screen } from '@testing-library/react'
import { describe, expect, it } from 'vitest'

import AuthenticationError from '@/features/auth/components/AuthenticationError'

describe('AuthenticationError', () => {
  it('ログイン失敗を伝え、再試行できること', () => {
    render(<AuthenticationError />)

    expect(screen.getByRole('alert')).toHaveTextContent('ログインに失敗しました')
    expect(screen.getByRole('link', { name: '再試行' })).toHaveAttribute('href', '/auth/auth_provider')
  })
})
