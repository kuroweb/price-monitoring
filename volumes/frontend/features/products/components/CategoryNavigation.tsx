import Link from 'next/link'

const CategoryNavigation = () => {
  return (
    <>
      <div>
        <Link href='/'>
          <span>
            <svg
              xmlns='http://www.w3.org/2000/svg'
              width='1em'
              height='1em'
              viewBox='0 0 30 30'
              className='inline-block size-5'
            >
              <path fill='currentColor' d='M4 21V9l8-6l8 6v12h-6v-7h-4v7z'></path>
            </svg>
            Home
          </span>
        </Link>
        <span className='px-1'>
          <svg
            xmlns='http://www.w3.org/2000/svg'
            width='1em'
            height='1em'
            viewBox='0 0 24 28'
            className='inline-block size-5 stroke-current'
          >
            <path fill='currentColor' d='m18.366 2.974l-11 19.052l-1.732-1l11-19.052z'></path>
          </svg>
        </span>
        <span>ガジェット</span>
      </div>
      {/* {data.categories.map((category) => {
            return <>{category.name}</>
          })} */}
    </>
  )
}

export default CategoryNavigation
