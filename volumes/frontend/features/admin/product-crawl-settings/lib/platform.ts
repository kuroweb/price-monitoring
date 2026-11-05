// 登録画面で検索結果URLのサイトを表示するための対応表。取得可否の判定はバックエンドが行う
const searchUrlHosts: Record<string, string> = {
  'jp.mercari.com': 'mercari',
  'iosys.co.jp': 'iosys',
}

export const platformNames: Record<string, string> = {
  mercari: 'メルカリ',
  yahoo_auction: 'ヤフオク',
  yahoo_fleamarket: 'ヤフーフリマ',
  janpara: 'じゃんぱら',
  iosys: 'イオシス',
  pc_koubou: 'パソコン工房',
  used_sofmap: 'リコレ',
}

export const platformName = (platform: string | null) =>
  platform ? (platformNames[platform] ?? platform) : '未対応'

export const searchUrlPlatform = (url: string) => {
  try {
    return searchUrlHosts[new URL(url).host.toLowerCase()] ?? null
  } catch {
    return null
  }
}

export const words = (value: string) => [
  ...new Set(
    value
      .split(/[\n,、]/)
      .map((word) => word.trim())
      .filter(Boolean),
  ),
]

// 既存の出品カード（RelatedProductCard）と同じ配色
export const platformColors: Record<string, string> = {
  mercari: 'bg-red-500',
  yahoo_auction: 'bg-yellow-600',
  yahoo_fleamarket: 'bg-green-600',
  janpara: 'bg-blue-500',
  iosys: 'bg-blue-600',
  pc_koubou: 'bg-blue-400',
  used_sofmap: 'bg-green-500',
}
