// 語句の入力欄（カンマ・読点・改行区切り）を、重複のない語句の配列にする
export const words = (value: string) => [
  ...new Set(
    value
      .split(/[\n,、]/)
      .map((word) => word.trim())
      .filter(Boolean),
  ),
]
