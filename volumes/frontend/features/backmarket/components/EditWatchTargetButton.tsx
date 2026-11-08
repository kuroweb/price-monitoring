'use client'

import { useState } from 'react'

import type { BackmarketWatchTarget } from '@/features/backmarket/api/types'
import BackmarketWatchTargetFormModal from '@/features/backmarket/components/BackmarketWatchTargetFormModal'

interface Props {
  target: BackmarketWatchTarget
}

const EditWatchTargetButton = ({ target }: Props) => {
  const [isOpen, setIsOpen] = useState(false)

  return (
    <>
      <button className='btn' onClick={() => setIsOpen(true)}>
        計測設定
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
