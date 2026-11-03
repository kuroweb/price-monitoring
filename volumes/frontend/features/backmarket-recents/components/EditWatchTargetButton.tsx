'use client'

import { useState } from 'react'

import BackmarketWatchTargetFormModal from '@/features/admin/backmarket-watch-targets/components/BackmarketWatchTargetFormModal'
import type { BackmarketWatchTarget } from '@/lib/api'

interface Props {
  target: BackmarketWatchTarget
}

const EditWatchTargetButton = ({ target }: Props) => {
  const [isOpen, setIsOpen] = useState(false)

  return (
    <>
      <button className='btn' onClick={() => setIsOpen(true)}>
        監視設定
      </button>
      <BackmarketWatchTargetFormModal
        isOpen={isOpen}
        onClose={() => setIsOpen(false)}
        target={target}
        mode='edit'
      />
    </>
  )
}

export default EditWatchTargetButton
