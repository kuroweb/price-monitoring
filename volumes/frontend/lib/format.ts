export const formatYen = (value: number) => `¥${value.toLocaleString()}`

// 'YYYY-MM-DD' → 'M/D'
export const formatDate = (value: string) => {
  const [, month, day] = value.substring(0, 10).split('-')
  return `${Number(month)}/${Number(day)}`
}
