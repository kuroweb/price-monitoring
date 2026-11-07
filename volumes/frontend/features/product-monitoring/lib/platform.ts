import { platformName as sharedPlatformName } from '@/lib/format'

const platformNames: Record<string, string> = {
  yahoo_fleamarket: 'Yahoo!フリマ',
  yahoo_auction: 'ヤフオク',
}

export const platformName = (platform: string | null) =>
  (platform && platformNames[platform]) || sharedPlatformName(platform)

// 登録画面で検索結果URLのサイトを表示するための対応表。取得可否の判定はバックエンドが行う
const searchUrlHosts: Record<string, string> = {
  'jp.mercari.com': 'mercari',
  'iosys.co.jp': 'iosys',
  'paypayfleamarket.yahoo.co.jp': 'yahoo_fleamarket',
  'auctions.yahoo.co.jp': 'yahoo_auction',
}

export const searchUrlPlatform = (url: string) => {
  try {
    return searchUrlHosts[new URL(url).host.toLowerCase()] ?? null
  } catch {
    return null
  }
}
