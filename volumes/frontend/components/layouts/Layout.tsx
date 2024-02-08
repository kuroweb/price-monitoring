'use client'

import { ReactNode, useState } from 'react'

import Header from './Header'
import Sidebar from './Sidebar'

type Props = {
  children?: ReactNode
}

const Layout = ({ children }: Props) => {
  const [open, setOpen] = useState<boolean>(false)

  return (
    <>
      <div className='h-dvh'>
        <Header />
        <div className='flex h-full overflow-hidden bg-gray-200 pt-16'>
          <Sidebar isOpen={open} />
          <div className='bg-gray-900 opacity-50 hidden fixed inset-0 z-10'></div>
          <div className={`h-full w-full overflow-y-auto ${open && 'md:pl-64'}`}>
            <main>
              <div className='p-4'>
                <main>{children}</main>
              </div>
            </main>
          </div>
        </div>
      </div>
    </>
  )
}

export default Layout
