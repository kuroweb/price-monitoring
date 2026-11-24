export function words(value: string): string[] {
  // ダブルクォートで囲んだ語句は JSON 文字列として読み、内部の空白や改行を保持する。
  const tokens = /("(?:[^"\\\x00-\x1f]|\\(?:["\\/bfnrt]|u[\da-fA-F]{4}))*")(?=$|[ \u3000\r\n])|[^ \u3000\r\n]+/g
  const keywords = Array.from(value.matchAll(tokens), ([token, quoted]) =>
    quoted ? JSON.parse(quoted) as string : token,
  )
  return [...new Set(keywords.filter(Boolean))]
}

export function formatWords(keywords: readonly string[]): string {
  return keywords.map((word) => /^"|[ \u3000\r\n]/.test(word) ? JSON.stringify(word) : word).join(' ')
}
