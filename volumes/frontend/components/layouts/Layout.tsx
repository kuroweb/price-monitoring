import { ReactNode } from 'react'

import Footer from './Footer'
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
        <div className='flex flex-1 overflow-hidden'>
          <Sidebar isOpen={false} />
          <main className='w-full p-4 overflow-scroll bg-gray-200'>{children}</main>
        </div>
        <Footer />
      </div>
    </>
  )
}

export default Layout
