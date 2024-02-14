'use client'

import { Dispatch, SetStateAction } from 'react'

import Link from 'next/link'

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
        <div className='flex-1 h-full flex flex-col min-h-0 bg-base-200'>
          <div className='flex-1 flex flex-col pt-5 pb-4 overflow-y-auto'>
            <ul className='space-y-2 pb-2'>
              <li>
                <Link
                  href='/'
                  className='text-base font-normal rounded-lg flex items-center p-2 hover:bg-base-100 group'
                >
                  <svg
                    className='w-6 h-6 text-gray-500 group-hover transition duration-75'
                    fill='currentColor'
                    viewBox='0 0 20 20'
                    xmlns='http://www.w3.org/2000/svg'
                  >
                    <path d='M2 10a8 8 0 018-8v8h8a8 8 0 11-16 0z'></path>
                    <path d='M12 2.252A8.014 8.014 0 0117.748 8H12V2.252z'></path>
                  </svg>
                  <span className='ml-3'>計測対象管理</span>
                </Link>
              </li>
              <li>
                <Link
                  href='/'
                  className='text-base font-normal rounded-lg flex items-center p-2 hover:bg-base-100 group'
                >
                  <svg
                    className='w-6 h-6 text-gray-500 flex-shrink-0 group-hover transition duration-75'
                    fill='currentColor'
                    viewBox='0 0 20 20'
                    xmlns='http://www.w3.org/2000/svg'
                  >
                    <path d='M5 3a2 2 0 00-2 2v2a2 2 0 002 2h2a2 2 0 002-2V5a2 2 0 00-2-2H5zM5 11a2 2 0 00-2 2v2a2 2 0 002 2h2a2 2 0 002-2v-2a2 2 0 00-2-2H5zM11 5a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V5zM11 13a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z'></path>
                  </svg>
                  <span className='ml-3 flex-1 whitespace-nowrap'>ピックアップ</span>
                </Link>
              </li>
            </ul>
          </div>
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
