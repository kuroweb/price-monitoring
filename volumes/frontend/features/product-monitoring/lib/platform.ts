import { platformName as sharedPlatformName } from '@/lib/format'

const platformNames: Record<string, string> = {
  yahoo_fleamarket: 'Yahoo!フリマ',
  yahoo_auction: 'ヤフオク',
}

export const platformName = (platform: string | null) =>
  (platform && platformNames[platform]) || sharedPlatformName(platform)

// 表示用の対応表で、取得可否の判定はバックエンドが行う
const searchUrlHosts: Record<string, string> = {
  'jp.mercari.com': 'mercari',
  'iosys.co.jp': 'iosys',
  'www.janpara.co.jp': 'janpara',
  'paypayfleamarket.yahoo.co.jp': 'yahoo_fleamarket',
  'auctions.yahoo.co.jp': 'yahoo_auction',
  'ec.treasure-f.com': 'treasure_factory',
}

export const searchUrlPlatform = (url: string) => {
  try {
    return searchUrlHosts[new URL(url).host.toLowerCase()] ?? null
  } catch {
    return null
  }
}
