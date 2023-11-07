// common
import { ReactNode } from 'react'

// components
import Header from './Header'
import Sidebar from './Sidebar'

type Props = {
  children?: ReactNode
}

const Layout = ({ children }: Props) => {
  return (
    <>
      <div className='flex flex-col h-screen'>
        <Header />
        <main className='h-full bg-gray-200'>
          <div className='grid grid-cols-12'>
            <div className='col-span-3'>
              <Sidebar />
            </div>
            <div className='col-span-9'>{children}</div>
          </div>
        </main>
      </div>
    </>
  )
}

export default Layout
