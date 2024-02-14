'use client'

import { Dispatch, SetStateAction } from 'react'

type Props = {
  open: boolean
  setOpen: Dispatch<SetStateAction<boolean>>
}

const Sidebar = (props: Props) => {
  return (
    <>
      <aside
        className={`${
          props.open ? 'flex' : 'hidden'
        } md:flex fixed z-20 h-full top-0 left-0 pt-16 flex-shrink-0 flex-col w-64 transition-width duration-75`}
      >
        <div className='flex-1 h-full flex flex-col min-h-0 bg-base-200 text-base-content'>
          <div className='flex-1 flex flex-col pt-5 pb-4 overflow-y-auto'>side</div>
        </div>
      </aside>
      <div
        onClick={() => props.setOpen(!open)}
        className={`${props.open ? '' : 'hidden'} bg-gray-900 opacity-50 fixed inset-0 z-10`}
      ></div>
    </>
  )
}

export default Sidebar
