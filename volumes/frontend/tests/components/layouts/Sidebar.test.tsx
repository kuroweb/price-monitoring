import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { describe, expect, it, vi } from 'vitest'

import Sidebar from '@/components/layouts/Sidebar'

vi.mock('next/navigation', () => ({ usePathname: () => '/product-monitoring/monitors/1' }))

describe('Sidebar', () => {
  it('詳細画面でもモニタリング設定を強調し、項目を押すと閉じること', async () => {
    const close = vi.fn()
    const user = userEvent.setup()
    render(<Sidebar open setOpen={close} />)
    expect(screen.getByRole('link', { name: '収集設定' })).toHaveAttribute('href', '/product-monitoring/crawl-settings')
    expect(screen.queryByRole('link', { name: '最安値一覧' })).not.toBeInTheDocument()
    expect(screen.queryByRole('link', { name: 'カテゴリ管理' })).not.toBeInTheDocument()
    const link = screen.getByRole('link', { name: 'モニタリング設定' })
    expect(link).toHaveAttribute('aria-current', 'page')
    expect(screen.getAllByRole('link').filter((item) => item.hasAttribute('aria-current'))).toEqual([link])
    await user.click(link)
    expect(close).toHaveBeenCalledWith(false)
  })
})
