import { render, screen } from '@testing-library/react'
import { describe, expect, it, vi } from 'vitest'

import BackmarketWatchTargetsTable from '@/features/backmarket/components/BackmarketWatchTargetsTable'

vi.mock('next/navigation', () => ({ useRouter: () => ({ refresh: vi.fn() }) }))
vi.mock('@/features/backmarket/api/actions', () => ({ getBackmarketRecents: vi.fn(), getBackmarketWatchTargets: vi.fn(), createBackmarketWatchTarget: vi.fn(), updateBackmarketWatchTarget: vi.fn(), destroyBackmarketWatchTarget: vi.fn() }))
vi.mock('@/features/categories/api/actions', () => ({ getCategories: vi.fn(), getCategoriesStructured: vi.fn(), createCategory: vi.fn(), updateCategory: vi.fn(), destroyCategory: vi.fn() }))
vi.mock('@/features/products/api/actions', () => ({}))

describe('一覧の空状態', () => {
  it('Backmarket計測対象なしの場合は追加ボタンと案内を表示すること', () => {
    render(<BackmarketWatchTargetsTable backmarketWatchTargets={[]} />)
    expect(
      screen.getByText('計測対象はまだありません。「計測対象を追加」から登録してください。'),
    ).toBeInTheDocument()
    expect(screen.getByRole('button', { name: '計測対象を追加' })).toBeEnabled()
  })
})
