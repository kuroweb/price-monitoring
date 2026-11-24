import { expect, it } from 'vitest'

import { formatWords, words } from '@/features/product-monitoring/lib/words'

it('半角・全角スペースと改行で分け、空欄と重複を除く', () => {
  expect(words('  iPad　　Pro\r\n64GB\n iPad　')).toEqual(['iPad', 'Pro', '64GB'])
  expect(words('　 \r\n')).toEqual([])
})

it('カンマと読点を語句の一部として扱う', () => {
  expect(words('Wi-Fi,Cellular 傷、割れ A, B')).toEqual(['Wi-Fi,Cellular', '傷、割れ', 'A,', 'B'])
})

it('クォートで囲まれた語句をまとめ、語句の途中のクォートを保持する', () => {
  expect(words('"iPad  Pro"　64GB 6.1"')).toEqual(['iPad  Pro', '64GB', '6.1"'])
  expect(words('"iPad Pro')).toEqual(['"iPad', 'Pro'])
})

it('既存の複合語を表示し、同じ欄に追記しても元の語句を保つ', () => {
  const saved = ['iPad Pro', 'A,B', '箱　説明書', '行\r\n区切り', '"引用"', 'C:\\My Files']
  const displayed = formatWords(saved)
  expect(words(displayed)).toEqual(saved)
  expect(words(`${displayed}　64GB`)).toEqual([...saved, '64GB'])
})
