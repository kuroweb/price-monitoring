import { describe, expect, it } from 'vitest'

import { makePlatformMask } from '@/features/products/lib/makePlatformMask'

describe('makePlatformMask', () => {
  it.each([
    ['yahoo_auction', 'published', 'yahoo_auction.buyable'],
    ['all', 'unpublished', 'yahoo_auction.unpublished'],
  ])('%s / %s に対応する検索条件を返すこと', (platform, status, expected) => {
    expect(makePlatformMask(platform, status)).toBe(expected)
  })

  it.each([
    ['all', 'published'],
    ['unknown', 'published'],
    ['yahoo_auction', 'unknown'],
  ])('%s / %s では公開中の全プラットフォームを検索すること', (platform, status) => {
    expect(makePlatformMask(platform, status)).toBe(
      'yahoo_auction.buyable',
    )
  })
})
