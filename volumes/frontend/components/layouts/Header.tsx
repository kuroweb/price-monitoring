import type { Dispatch, SetStateAction } from 'react'

import Link from 'next/link'

import AccountStatus from '@/features/auth/components/AccountStatus'

type Props = {
  open: boolean
  setOpen: Dispatch<SetStateAction<boolean>>
}

const Header = (props: Props) => {
  return (
    <>
      <header>
        <div className='navbar fixed z-30 bg-base-100'>
          <div className='flex-none'>
            <button
              className='btn btn-square btn-ghost flex md:hidden'
              aria-label={props.open ? 'メニューを閉じる' : 'メニューを開く'}
              aria-expanded={props.open}
              onClick={() => props.setOpen(!props.open)}
            >
              <svg
                xmlns='http://www.w3.org/2000/svg'
                fill='none'
                viewBox='0 0 24 24'
                className='inline-block size-5 stroke-current'
              >
                <path
                  strokeLinecap='round'
                  strokeLinejoin='round'
                  strokeWidth='2'
                  d='M4 6h16M4 12h16M4 18h16'
                ></path>
              </svg>
            </button>
          </div>
          <div className='flex-1'>
            <Link href='/product-monitoring'>
              <p className='whitespace-nowrap px-2 text-base sm:px-4 sm:text-xl'>Price Monitoring</p>
            </Link>
          </div>
          <div className='flex-none'>
            {process.env.NEXT_PUBLIC_COMPOSE_PROJECT_NAME && (
              <span className='badge badge-outline mx-4 hidden lg:inline-flex'>
                {process.env.NEXT_PUBLIC_COMPOSE_PROJECT_NAME}
              </span>
            )}
            <AccountStatus />
          </div>
        </div>
      </header>
    </>
  )
}

export default Header
