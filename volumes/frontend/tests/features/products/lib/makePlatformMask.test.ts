import { describe, expect, it } from 'vitest'

import { makePlatformMask } from '@/features/products/lib/makePlatformMask'

describe('makePlatformMask', () => {
  it.each([
    ['all', 'published'],
    ['all', 'unpublished'],
    ['unknown', 'published'],
  ])('%s / %s では関連商品の検索条件を空にすること', (platform, status) => {
    expect(makePlatformMask(platform, status)).toBe('')
  })
})
