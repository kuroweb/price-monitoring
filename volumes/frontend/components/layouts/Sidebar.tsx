'use client'

const Sidebar = ({ isOpen }: { isOpen: boolean }) => {
  return (
    <>
      {isOpen && (
        <aside className='fixed z-20 h-full top-0 left-0 pt-16 flex flex-shrink-0 flex-col w-64 transition-width duration-75'>
          <div className='flex-1 h-full flex flex-col min-h-0 border-r border-gray-200 bg-white pt-0'>
            <div className='flex-1 flex flex-col pt-5 pb-4 overflow-y-auto'>side</div>
          </div>
        </aside>
      )}
    </>
  )
}

export default Sidebar
