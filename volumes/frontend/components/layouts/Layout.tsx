// common
import { ReactNode } from 'react'

// components
import Header from './Header'

type Props = {
  children?: ReactNode
}

const Layout = ({ children }: Props) => {
  return (
    <>
      <div className='bg-gray-200'>
        <Header />
        <main className='container mx-auto max-w-6xl p-4'>
          <div className='grid grid-cols-12 gap-4'>
            <div className='col-span-12'>{children}</div>
          </div>
        </main>
      </div>
    </>
  )
}

export default Layout
