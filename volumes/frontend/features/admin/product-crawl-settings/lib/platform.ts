// 登録画面で検索結果URLのサイトを表示するための対応表。取得可否の判定はバックエンドが行う
const searchUrlHosts: Record<string, string> = {
  'jp.mercari.com': 'mercari',
  'iosys.co.jp': 'iosys',
}

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
