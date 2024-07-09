'use client'

import type { Dispatch, SetStateAction } from 'react'

import Link from 'next/link'

type Props = {
  open: boolean
  setOpen: Dispatch<SetStateAction<boolean>>
}

const Sidebar = ({ open, setOpen }: Props) => {
  return (
    <>
      <aside
        className={`${
          open ? 'flex' : 'hidden'
        } transition-width fixed left-0 top-0 z-20 h-full w-64 shrink-0 flex-col pt-16 duration-75 md:flex`}
      >
        <div className='flex h-full min-h-0 flex-1 flex-col bg-base-200'>
          <div className='flex flex-1 flex-col overflow-y-auto pb-4 pt-5'>
            <ul className='space-y-2 pb-2'>
              <li>
                <Link
                  href='/'
                  className='group flex items-center rounded-lg px-4 py-2 text-base font-normal hover:bg-base-100'
                >
                  <svg
                    className='group-hover size-6 text-gray-500 transition duration-75'
                    fill='currentColor'
                    viewBox='0 0 20 20'
                    xmlns='http://www.w3.org/2000/svg'
                  >
                    <path d='M2 10a8 8 0 018-8v8h8a8 8 0 11-16 0z'></path>
                    <path d='M12 2.252A8.014 8.014 0 0117.748 8H12V2.252z'></path>
                  </svg>
                  <span className='ml-3'>計測管理</span>
                </Link>
              </li>
              <li>
                <Link
                  href='/categories'
                  className='group flex items-center rounded-lg px-4 py-2 text-base font-normal hover:bg-base-100'
                >
                  <svg
                    className='group-hover size-6 text-gray-500 transition duration-75'
                    xmlns='http://www.w3.org/2000/svg'
                    width='1em'
                    height='1em'
                    viewBox='0 0 24 24'
                  >
                    <path
                      fill='currentColor'
                      d='M6.5 11L12 2l5.5 9zm11 11q-1.875 0-3.187-1.312T13 17.5t1.313-3.187T17.5 13t3.188 1.313T22 17.5t-1.312 3.188T17.5 22M3 21.5v-8h8v8z'
                    ></path>
                  </svg>
                  <span className='ml-3'>カテゴリ管理</span>
                </Link>
              </li>
              <li>
                <Link
                  href='/recommends'
                  className='group flex items-center rounded-lg px-4 py-2 text-base font-normal hover:bg-base-100'
                >
                  <svg
                    className='group-hover size-6 text-gray-500 transition duration-75'
                    xmlns='http://www.w3.org/2000/svg'
                    width='1em'
                    height='1em'
                    viewBox='0 0 48 48'
                  >
                    <defs>
                      <mask id='ipSTrend0'>
                        <g fill='none' strokeLinejoin='round' strokeWidth='4'>
                          <path
                            fill='#fff'
                            stroke='#fff'
                            d='M39 6H9a3 3 0 0 0-3 3v30a3 3 0 0 0 3 3h30a3 3 0 0 0 3-3V9a3 3 0 0 0-3-3Z'
                          />
                          <path
                            stroke='#000'
                            strokeLinecap='round'
                            d='m13.44 29.835l5.657-5.657l4.388 4.377L34 18'
                          />
                          <path stroke='#000' strokeLinecap='round' d='M26 18h8v8' />
                        </g>
                      </mask>
                    </defs>
                    <path fill='currentColor' d='M0 0h48v48H0z' mask='url(#ipSTrend0)' />
                  </svg>
                  <span className='ml-3'>レコメンド</span>
                </Link>
              </li>
            </ul>
          </div>
        </div>
      </aside>
      <div
        onClick={() => setOpen(!open)}
        className={`${open ? '' : 'hidden'} fixed inset-0 z-10 bg-gray-900 opacity-50`}
      ></div>
    </>
  )
}

export default Sidebar
