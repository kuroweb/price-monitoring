'use client'

import { Fragment, useState } from 'react'

import { toast } from 'react-toastify'

import { destroyCategory } from '@/lib/actions'
import type { Category, GetCategoriesStructured } from '@/lib/api'

import CreateCategoryModal from './create-category-modal/CreateCategoryModal'
import UpdateCategoryModal from './update-category-modal/UpdateCategoryModal'
import { useUpdateCategoryModalState } from './update-category-modal/hooks/useUpdateCategoryModalState'

const CategoriesList = ({
  structuredCategories,
  categories,
}: {
  structuredCategories: GetCategoriesStructured['categories']
  categories: Category[]
}) => {
  const [_updateModal, setUpdateModal] = useUpdateCategoryModalState()
  const [selectedCategory, setSelectedCategory] = useState<Category | undefined>(undefined)

  const submitDestroyCategory = async (categoryId: number) => {
    const result = await destroyCategory(categoryId)

    if (result.status === 200) {
      toast.success('success')
    } else {
      toast.error('error')
    }
  }

  const renderChildren = (
    children: GetCategoriesStructured['categories'][number]['children'],
    ancestors: { id: number; isLast: boolean }[],
  ) => {
    return children.map((child, index) => {
      const isLast = index === children.length - 1
      const childAncestors = [...ancestors, { id: child.id, isLast }]

      return (
        <Fragment key={child.id}>
          <tr>
            <td className='font-mono text-sm'>
              <div className='flex items-center'>
                {ancestors.map((ancestor) => (
                  <span key={ancestor.id} className='inline-block w-4 text-base-content/30'>
                    {ancestor.isLast ? '  ' : '│ '}
                  </span>
                ))}
                <span className='inline-block w-4 text-base-content/30'>
                  {isLast ? '└─' : '├─'}
                </span>
                <span className='ml-1'>{child.name}</span>
              </div>
            </td>
            <td className='w-1/12'>{actionButtons(child)}</td>
          </tr>
          {child.children.length > 0 && renderChildren(child.children, childAncestors)}
        </Fragment>
      )
    })
  }

  const actionButtons = (category: Category) => {
    return (
      <div className='dropdown dropdown-left'>
        <button
          type='button'
          aria-label={`${category.name}の操作`}
          className='btn btn-square btn-md'
        >
          <svg
            xmlns='http://www.w3.org/2000/svg'
            fill='none'
            viewBox='0 0 24 24'
            className='inline-block size-5 stroke-current'
          >
            <path
              strokeLinecap='round'
              strokeLinejoin='round'
              strokeWidth='2'
              d='M5 12h.01M12 12h.01M19 12h.01M6 12a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0z'
            ></path>
          </svg>
        </button>
        <ul className='menu dropdown-content z-1 w-20 space-y-2 rounded-box border border-base-300 bg-base-100 shadow-lg'>
          <li>
            <button
              className='btn btn-primary'
              onClick={() => {
                setSelectedCategory(category)
                setUpdateModal(true)
              }}
            >
              編集
            </button>
          </li>
          <li>
            <button className='btn btn-error' onClick={() => submitDestroyCategory(category.id)}>
              削除
            </button>
          </li>
        </ul>
      </div>
    )
  }

  return (
    <>
      <table className='table'>
        <thead>
          <tr>
            <th>カテゴリ名</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          {structuredCategories.map((category, index) => {
            const isLast = index === structuredCategories.length - 1
            return (
              <Fragment key={category.id}>
                <tr>
                  <td className='font-mono text-sm'>
                    <span className='inline-block w-4 text-base-content/30'>
                      {isLast ? '└─' : '├─'}
                    </span>
                    <span className='ml-1 font-semibold'>{category.name}</span>
                  </td>
                  <td className='w-1/12'>{actionButtons(category)}</td>
                </tr>
                {category.children.length > 0 &&
                  renderChildren(category.children, [{ id: category.id, isLast }])}
              </Fragment>
            )
          })}
        </tbody>
      </table>
      <CreateCategoryModal categories={categories} />
      <UpdateCategoryModal category={selectedCategory} categories={categories} />
    </>
  )
}

export default CategoriesList
