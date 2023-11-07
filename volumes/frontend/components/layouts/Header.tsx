// common
import Link from 'next/link'

const Header = () => {
  return (
    <>
      {/* Header */}
      <header className='sticky top-0 z-10 bg-blue-500'>
        <div className='px-4 sm:px-6 lg:px-8'>
          <div className='flex justify-between items-center -mb-px h-16'>
            <div className='flex'>
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
