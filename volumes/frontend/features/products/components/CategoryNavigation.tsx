'use client'

import Link from 'next/link'

import type { Category } from '@/api'

const CategoryNavigation = ({
  parentCategory,
  currentCategory,
  childCategories,
}: {
  parentCategory?: Category
  currentCategory?: Category
  childCategories?: Category[]
}) => {
  return (
    <>
      <div className='grid grid-cols-1 space-y-4'>
        <div>
          {parentCategory ? (
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
              <Link href='/products'>
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
          {parentCategory && (
            <>
              <Link href={`/products?category_id=${parentCategory.id}`}>{parentCategory.name}</Link>
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
          {currentCategory && (
            <>
              <span>{currentCategory.name}</span>
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
        {childCategories && (
          <>
            <div className='flex flex-wrap gap-3'>
              {childCategories.map((childCategory) => {
                return (
                  <>
                    <Link
                      href={`/products?category_id=${childCategory.id}`}
                      className='btn btn-outline btn-sm'
                    >
                      {childCategory.name}
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
