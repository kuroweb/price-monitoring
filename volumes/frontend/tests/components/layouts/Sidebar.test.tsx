import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { describe, expect, it, vi } from 'vitest'

import Sidebar from '@/components/layouts/Sidebar'

vi.mock('next/navigation', () => ({ usePathname: () => '/products/2' }))

describe('Sidebar', () => {
  it('詳細画面でも最安値一覧を強調し、項目を押すと閉じること', async () => {
    const close = vi.fn()
    const user = userEvent.setup()
    render(<Sidebar open setOpen={close} />)
    expect(screen.getByRole('link', { name: '商品計測' })).toHaveAttribute('href', '/product-crawl-results')
    expect(screen.getByRole('link', { name: '商品モニタリング' })).toHaveAttribute('href', '/product-monitoring')
    const link = screen.getByRole('link', { name: '最安値一覧' })
    expect(link).toHaveAttribute('aria-current', 'page')
    expect(screen.getAllByRole('link').filter((item) => item.hasAttribute('aria-current'))).toEqual([link])
    await user.click(link)
    expect(close).toHaveBeenCalledWith(false)
  })
})
