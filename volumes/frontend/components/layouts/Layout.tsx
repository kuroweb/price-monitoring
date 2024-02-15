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
      <div className='h-svh' data-theme='night'>
        <div className='flex h-full overflow-hidden'>
          <Header open={open} setOpen={setOpen} />
          <Sidebar open={open} setOpen={setOpen} />
          <div className='h-full w-full overflow-y-auto md:pl-64'>
            <main>
              <div className='pt-20 p-4'>
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
