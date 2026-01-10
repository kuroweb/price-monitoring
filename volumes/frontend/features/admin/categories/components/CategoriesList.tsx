'use client'

import { Fragment } from 'react'

import { useRouter } from 'next/navigation'
import { toast } from 'react-toastify'

import type { GetCategoriesStructured } from '@/lib/api'

import { destroyCategory } from '@/lib/actions'

const CategoriesList = ({
  structuredCategories,
}: {
  structuredCategories: GetCategoriesStructured['categories']
}) => {
  const router = useRouter()

  const submitDestroyCategory = async (categoryId: number) => {
    const result = await destroyCategory(categoryId)

    if (result.status === 200) {
      toast.success('success')
    } else {
      toast.error('error')
    }
    router.refresh()
  }

  const renderChildren = (
    children: GetCategoriesStructured['categories'][number]['children'],
    depth: number = 1,
  ) => {
    return children.map((child) => (
      <Fragment key={child.id}>
        <li className='flex items-center'>
          {'__'.repeat(depth)}
          {child.name}
          {deleteButton(child.id)}
        </li>
        {renderChildren(child.children, depth + 1)}
      </Fragment>
    ))
  }

  const deleteButton = (categoryId: number) => {
    return (
      <button
        className='pl-0.5 text-red-500'
        onClick={() => {
          submitDestroyCategory(categoryId)
        }}
      >
        <svg xmlns='http://www.w3.org/2000/svg' width='1em' height='1em' viewBox='0 0 24 24'>
          <path
            fill='currentColor'
            d='M7 21q-.825 0-1.412-.587T5 19V6H4V4h5V3h6v1h5v2h-1v13q0 .825-.587 1.413T17 21zm2-4h2V8H9zm4 0h2V8h-2z'
          />
        </svg>
      </button>
    )
  }

  return (
    <ul>
      {structuredCategories.map((category) => (
        <Fragment key={category.id}>
          <li className='flex items-center'>
            {category.name}
            {deleteButton(category.id)}
          </li>
          {renderChildren(category.children)}
        </Fragment>
      ))}
    </ul>
  )
}

export default CategoriesList
