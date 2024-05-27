import { Dispatch, SetStateAction } from 'react'

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
              onClick={() => props.setOpen(!props.open)}
            >
              <svg
                xmlns='http://www.w3.org/2000/svg'
                fill='none'
                viewBox='0 0 24 24'
                className='inline-block w-5 h-5 stroke-current'
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
            <a href={'/products'}>
              <p className='text-xl px-4'>Price Monitoring</p>
            </a>
          </div>
          <div className='flex-none'>{/* ヘッダー右側 */}</div>
        </div>
      </header>
    </>
  )
}

export default Header
