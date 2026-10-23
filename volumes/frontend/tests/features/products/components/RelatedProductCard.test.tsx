import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { NuqsTestingAdapter } from 'nuqs/adapters/testing'
import { describe, expect, it, vi } from 'vitest'

import RelatedProductCard from '@/features/products/components/RelatedProductCard'
import type { RelatedProduct } from '@/lib/api'

vi.mock('next/navigation', () => ({ useRouter: () => ({ refresh: vi.fn() }) }))

const relatedProduct: RelatedProduct = {
  platform: 'mercari',
  productId: 1,
  externalId: 'm123',
  name: 'MacBook',
  price: 50000,
  buyoutPrice: null,
  thumbnailUrl: '/thumbnail.png',
  published: true,
  boughtDate: '',
  endDate: '',
  createdAt: '2026-01-01T00:00:00Z',
  updatedAt: '2026-01-01T00:00:00Z',
}

describe('RelatedProductCard', () => {
  it('画像と商品説明から外部の商品ページへリンクし、キーボードで移動できる', async () => {
    const user = userEvent.setup()
    render(
      <NuqsTestingAdapter>
        <RelatedProductCard relatedProduct={relatedProduct} />
      </NuqsTestingAdapter>,
    )

    const links = screen.getAllByRole('link')
    expect(links).toHaveLength(2)
    for (const link of links) {
      expect(link).toHaveAttribute('href', 'https://jp.mercari.com/item/m123')
      expect(link).toHaveAttribute('target', '_blank')
      expect(link).toHaveAttribute('rel', 'noopener noreferrer')
    }

    await user.tab()
    expect(links[0]).toHaveFocus()
    await user.tab()
    expect(screen.getByRole('button', { name: 'MacBookの操作' })).toHaveFocus()
  })
})
