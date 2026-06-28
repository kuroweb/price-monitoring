'use client'

import type { FormHTMLAttributes, ReactNode } from 'react'

type ScrollableModalBoxProps = {
  title: string
  onClose: () => void
  children: ReactNode
}

export const ScrollableModalBox = ({ title, onClose, children }: ScrollableModalBoxProps) => {
  return (
    <div className='modal-box relative h-fit max-sm:flex max-sm:max-h-[calc(100dvh-2rem)] max-sm:flex-col max-sm:p-0'>
      <div className='max-sm:flex max-sm:shrink-0 max-sm:items-start max-sm:justify-between max-sm:gap-2 max-sm:px-6 max-sm:pt-6 max-sm:pb-2'>
        <h3 className='text-lg font-bold'>{title}</h3>
        <button
          type='button'
          onClick={onClose}
          aria-label='閉じる'
          className='btn btn-circle btn-ghost btn-sm absolute right-4 top-4 max-sm:static max-sm:shrink-0'
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
    <form className={`max-sm:flex max-sm:min-h-0 max-sm:flex-1 max-sm:flex-col ${className}`} {...props}>
      {children}
    </form>
  )
}

export const ScrollableModalBody = ({ children }: { children: ReactNode }) => {
  return (
    <div className='max-sm:min-h-0 max-sm:flex-1 max-sm:overflow-y-auto max-sm:px-6 max-sm:pb-4'>
      {children}
    </div>
  )
}

export const ScrollableModalFooter = ({ children }: { children: ReactNode }) => {
  return (
    <div className='max-sm:shrink-0 max-sm:border-t max-sm:border-base-300 max-sm:px-6 max-sm:py-4'>
      {children}
    </div>
  )
}
