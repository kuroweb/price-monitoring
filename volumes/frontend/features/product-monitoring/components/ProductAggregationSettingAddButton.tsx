'use client'

import { useState } from 'react'

import ProductAggregationSettingFormModal from './ProductAggregationSettingFormModal'

export default function ProductAggregationSettingAddButton({
  className = 'btn',
}: {
  className?: string
}) {
  const [open, setOpen] = useState(false)

  return (
    <>
      <button type='button' className={className} onClick={() => setOpen(true)}>
        商品相場設定を追加
      </button>
      {open && <ProductAggregationSettingFormModal onClose={() => setOpen(false)} />}
    </>
  )
}
