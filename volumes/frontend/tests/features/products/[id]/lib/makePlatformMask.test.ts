import { describe, expect, it } from 'vitest'

import { makePlatformMask } from '@/features/products/[id]/lib/makePlatformMask'

describe('makePlatformMask', () => {
  it.each([
    ['yahoo_auction', 'published', 'yahoo_auction.buyable'],
    ['mercari', 'unpublished', 'mercari.unpublished'],
    ['janpara', 'unpublished', 'janpara.all'],
    ['iosys', 'published', 'iosys.all'],
    ['pc_koubou', 'published', 'pc_koubou.all'],
    ['yahoo_fleamarket', 'published', 'yahoo_fleamarket.published'],
    [
      'all',
      'unpublished',
      'yahoo_auction.unpublished,yahoo_fleamarket.unpublished,mercari.unpublished',
    ],
  ])('%s / %s に対応する検索条件を返す', (platform, status, expected) => {
    expect(makePlatformMask(platform, status)).toBe(expected)
  })

  it.each([
    ['all', 'published'],
    ['unknown', 'published'],
    ['mercari', 'unknown'],
  ])('%s / %s では公開中の全プラットフォームを検索する', (platform, status) => {
    expect(makePlatformMask(platform, status)).toBe(
      'yahoo_auction.buyable,yahoo_fleamarket.published,mercari.published,janpara.all,iosys.all,pc_koubou.all',
    )
  })
})
