'use client'

import { useState } from 'react'

import ProductCrawlSettingFormModal from './ProductCrawlSettingFormModal'

export default function ProductCrawlSettingAddButton({
  className = 'btn',
}: {
  className?: string
}) {
  const [open, setOpen] = useState(false)

  return (
    <>
      <button type='button' className={className} onClick={() => setOpen(true)}>
        商品計測設定を追加
      </button>
      {open && <ProductCrawlSettingFormModal onClose={() => setOpen(false)} />}
    </>
  )
}
