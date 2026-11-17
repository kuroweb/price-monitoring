'use client'

import { useState } from 'react'

import CrawlSettingFormModal from './CrawlSettingFormModal'

export default function CrawlSettingAddButton({
  className = 'btn',
}: {
  className?: string
}) {
  const [open, setOpen] = useState(false)

  return (
    <>
      <button type='button' className={className} onClick={() => setOpen(true)}>
        収集設定を追加
      </button>
      {open && <CrawlSettingFormModal onClose={() => setOpen(false)} />}
    </>
  )
}
