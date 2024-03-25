'use client'

import { Link } from 'react-daisyui'

const DetailPageSidebarContent = () => {
  return (
    <>
      <ul className='space-y-2 pb-2'>
        <li>
          <Link
            href='/'
            className='text-base font-normal rounded-lg flex items-center py-2 px-4 hover:bg-base-100 group'
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
            <span className='ml-3'>計測管理</span>
          </Link>
        </li>
      </ul>
    </>
  )
}

export default DetailPageSidebarContent
