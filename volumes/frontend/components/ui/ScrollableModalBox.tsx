'use client'

import type { FormHTMLAttributes, ReactNode } from 'react'

type ScrollableModalBoxProps = {
  title: string
  onClose: () => void
  children: ReactNode
}

export const ScrollableModalBox = ({ title, onClose, children }: ScrollableModalBoxProps) => {
  return (
    <div className='modal-box flex max-h-[calc(100dvh-2rem)] flex-col p-0'>
      <div className='flex shrink-0 items-start justify-between gap-2 px-6 pt-6 pb-2'>
        <h3 className='text-lg font-bold'>{title}</h3>
        <button
          type='button'
          onClick={onClose}
          aria-label='閉じる'
          className='btn btn-circle btn-ghost btn-sm shrink-0'
        >
          ✕
        </button>
      </div>
      {children}
    </div>
  )
}

export const ScrollableModalForm = ({
  children,
  className = '',
  ...props
}: FormHTMLAttributes<HTMLFormElement>) => {
  return (
    <form className={`flex min-h-0 flex-1 flex-col ${className}`} {...props}>
      {children}
    </form>
  )
}

export const ScrollableModalBody = ({ children }: { children: ReactNode }) => {
  return (
    <div className='min-h-0 flex-1 overflow-y-auto px-6 pb-4'>
      {children}
    </div>
  )
}

export const ScrollableModalFooter = ({ children }: { children: ReactNode }) => {
  return (
    <div className='shrink-0 border-t border-base-300 px-6 py-4'>
      {children}
    </div>
  )
}
