import { render, screen } from '@testing-library/react'
import { describe, expect, it } from 'vitest'

import type { Category } from '@/lib/api/models/categories'

import CategoryNavigation from '@/features/products/components/CategoryNavigation'

const category: Category = {
  id: 1,
  parentId: null,
  name: 'パソコン',
  createdAt: '2026-01-01T00:00:00Z',
  updatedAt: '2026-01-01T00:00:00Z',
}

describe('CategoryNavigation', () => {
  it('カテゴリ未選択では商品一覧へのリンクを表示する', () => {
    render(<CategoryNavigation />)

    expect(screen.getByRole('link', { name: 'Home' })).toHaveAttribute('href', '/products')
  })

  it('親カテゴリと子カテゴリへのリンクと、現在のカテゴリを表示する', () => {
    render(
      <CategoryNavigation
        parentCategory={category}
        currentCategory={{ ...category, id: 2, parentId: 1, name: 'ノートパソコン' }}
        childCategories={[{ ...category, id: 3, parentId: 2, name: 'MacBook' }]}
      />,
    )

    expect(screen.getByRole('link', { name: 'パソコン' })).toHaveAttribute(
      'href',
      '/products?category_id=1',
    )
    expect(screen.getByText('ノートパソコン')).toBeInTheDocument()
    expect(screen.getByRole('link', { name: 'MacBook' })).toHaveAttribute(
      'href',
      '/products?category_id=3',
    )
    expect(screen.queryByRole('link', { name: 'Home' })).not.toBeInTheDocument()
  })
})
