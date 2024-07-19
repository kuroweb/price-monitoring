'use client'

import Link from 'next/link'

const CategoryNavigation = ({
  parentCategoryName,
  currentCategoryName,
  childCategoryNames,
}: {
  parentCategoryName?: string
  currentCategoryName?: string
  childCategoryNames?: string[]
}) => {
  console.log(parentCategoryName)

  return (
    <>
      <div className='grid grid-cols-1 space-y-4'>
        <div>
          {parentCategoryName ? (
            <>
              <span>...</span>
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
            </>
          ) : (
            <>
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
            </>
          )}
          {parentCategoryName && (
            <>
              <Link href={`/products/categories/${parentCategoryName}`}>{parentCategoryName}</Link>
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
            </>
          )}
          {currentCategoryName && (
            <>
              <span>{currentCategoryName}</span>
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
            </>
          )}
        </div>
        {childCategoryNames && (
          <>
            <div className='flex flex-wrap space-x-4'>
              {childCategoryNames.map((categoryName) => {
                return (
                  <>
                    <Link
                      href={`/products/categories/${categoryName}`}
                      className='btn btn-outline btn-sm'
                    >
                      {categoryName}
                    </Link>
                  </>
                )
              })}
            </div>
          </>
        )}
      </div>
    </>
  )
}

export default CategoryNavigation
