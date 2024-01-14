const Sidebar = ({ isOpen }: { isOpen: boolean }) => {
  return (
    <>{isOpen && <aside className='bg-blue-800 text-white w-48 overflow-y-auto'>Sidebar</aside>}</>
  )
}

export default Sidebar
