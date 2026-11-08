import { describe, expect, it } from 'vitest'

import { platformName, searchUrlPlatform } from '@/features/product-monitoring/lib/platform'

describe('ヤフオクのサイト表示', () => {
  it('検索 URL と出品元を判定すること', () => {
    expect(searchUrlPlatform('https://auctions.yahoo.co.jp/search/search?p=ipad')).toBe('yahoo_auction')
    expect(searchUrlPlatform('https://auctions.yahoo.co.jp/closedsearch/closedsearch?p=ipad')).toBe('yahoo_auction')
    expect(platformName('yahoo_auction')).toBe('ヤフオク')
  })
})

describe('じゃんぱらのサイト表示', () => {
  it('検索 URL と出品元を判定すること', () => {
    expect(searchUrlPlatform('https://www.janpara.co.jp/sale/search/result/?KEYWORDS=iPad')).toBe('janpara')
    expect(platformName('janpara')).toBe('じゃんぱら')
  })
})

describe('トレファクのサイト表示', () => {
  it('検索 URL と出品元を判定すること', () => {
    expect(searchUrlPlatform('https://ec.treasure-f.com/search?category=1029&word=macbook')).toBe(
      'treasure_factory',
    )
    expect(platformName('treasure_factory')).toBe('トレファク')
  })
})
