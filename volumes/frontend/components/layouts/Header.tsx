import { Dispatch, SetStateAction } from 'react'

import Link from 'next/link'

type Props = {
  open: boolean
  setOpen: Dispatch<SetStateAction<boolean>>
}

const Header = (props: Props) => {
  return (
    <>
      <header className='fixed z-30 w-full bg-blue-600'>
        <div className='px-6'>
          <div className='flex justify-between items-center -mb-px h-16'>
            <div className='flex'>
              <button
                className='flex md:hidden bg-white rounded-md px-2 mr-4'
                onClick={() => props.setOpen(!props.open)}
              >
                =
              </button>
              <Link href={'/'}>
                <p className='text-white'>Price Monitoring</p>
              </Link>
            </div>
          </div>
        </div>
      </header>
    </>
  )
}

export default Header
