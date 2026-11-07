export const formatYen = (value: number) => `¥${value.toLocaleString()}`

// 'YYYY-MM-DD' → 'M/D'
export const formatDate = (value: string) => {
  const [, month, day] = value.substring(0, 10).split('-')
  return `${Number(month)}/${Number(day)}`
}

export const platformNames: Record<string, string> = {
  mercari: 'メルカリ',
  yahoo_auction: 'ヤフオク',
  yahoo_fleamarket: 'ヤフーフリマ',
  janpara: 'じゃんぱら',
  iosys: 'イオシス',
  pc_koubou: 'パソコン工房',
  used_sofmap: 'リコレ',
  treasure_factory: 'トレファク',
}

export const platformName = (platform: string | null) =>
  platform ? (platformNames[platform] ?? platform) : '未対応'

// 既存の出品カード（RelatedProductCard）と同じ配色
export const platformColors: Record<string, string> = {
  mercari: 'bg-red-500',
  yahoo_auction: 'bg-yellow-600',
  yahoo_fleamarket: 'bg-green-600',
  janpara: 'bg-blue-500',
  iosys: 'bg-blue-600',
  pc_koubou: 'bg-blue-400',
  used_sofmap: 'bg-green-500',
  treasure_factory: 'bg-orange-500',
}
