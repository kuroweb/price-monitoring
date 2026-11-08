import { render, screen } from '@testing-library/react'
import { describe, expect, it, vi } from 'vitest'

import Header from '@/components/layouts/Header'

vi.mock('@/features/auth/components/AccountStatus', () => ({ default: () => <span>ログイン状態</span> }))

describe('Header', () => {
  it('ログイン状態を表示すること', () => {
    render(<Header open={false} setOpen={vi.fn()} />)

    expect(screen.getByText('ログイン状態')).toBeInTheDocument()
    expect(screen.getByRole('link', { name: 'Price Monitoring' })).toHaveAttribute('href', '/product-monitoring')
  })

  it('Compose の project 名があれば、どの環境の画面か分かるように表示すること', () => {
    vi.stubEnv('NEXT_PUBLIC_COMPOSE_PROJECT_NAME', 'add-just-url')
    render(<Header open={false} setOpen={vi.fn()} />)

    expect(screen.getByText('add-just-url')).toBeInTheDocument()
  })

  it.each([undefined, ''])('Compose の project 名が %j なら表示しないこと', (projectName) => {
    vi.stubEnv('NEXT_PUBLIC_COMPOSE_PROJECT_NAME', projectName)
    const { container } = render(<Header open={false} setOpen={vi.fn()} />)

    expect(container.querySelector('.badge')).toBeNull()
  })
})
