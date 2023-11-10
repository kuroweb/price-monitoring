// common
import { ReactNode } from 'react'

// components
import Header from './Header'
import Sidebar from './Sidebar'
import Footer from './Footer'

type Props = {
  children?: ReactNode
}

const Layout = ({ children }: Props) => {
  return (
    <>
      <div className='flex flex-col h-screen'>
        <Header />
        <div className='flex flex-1 overflow-hidden'>
          <Sidebar />
          <main className='w-full p-4 overflow-scroll bg-gray-200'>{children}</main>
        </div>
        <Footer />
      </div>
    </>
  )
}

export default Layout
