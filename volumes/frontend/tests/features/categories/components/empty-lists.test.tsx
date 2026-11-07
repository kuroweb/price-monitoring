import { render, screen } from '@testing-library/react'
import { NuqsTestingAdapter } from 'nuqs/adapters/testing'
import { describe, expect, it, vi } from 'vitest'

import CategoriesList from '@/features/categories/components/CategoriesList'

vi.mock('next/navigation', () => ({ useRouter: () => ({ refresh: vi.fn() }) }))
vi.mock('@/features/backmarket/api/actions', () => ({ getBackmarketRecents: vi.fn(), getBackmarketWatchTargets: vi.fn(), createBackmarketWatchTarget: vi.fn(), updateBackmarketWatchTarget: vi.fn(), destroyBackmarketWatchTarget: vi.fn() }))
vi.mock('@/features/categories/api/actions', () => ({ getCategories: vi.fn(), getCategoriesStructured: vi.fn(), createCategory: vi.fn(), updateCategory: vi.fn(), destroyCategory: vi.fn() }))
vi.mock('@/features/products/api/actions', () => ({}))

describe('一覧の空状態', () => {
  it('カテゴリなしの場合は追加を案内する', () => {
    render(
      <NuqsTestingAdapter>
        <CategoriesList structuredCategories={[]} categories={[]} />
      </NuqsTestingAdapter>,
    )
    expect(
      screen.getByText('カテゴリはまだありません。カテゴリを追加してください。'),
    ).toBeInTheDocument()
  })
})
