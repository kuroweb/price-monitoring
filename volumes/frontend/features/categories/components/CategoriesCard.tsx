'use client'

import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { toast } from 'react-toastify'

import { deleteCategory } from '../server-actions/graphql/categoryQuery'

import type { DeleteCategoryInput, GetCategoryPageDataQuery } from '@/graphql/dist/client'

const CategoriesCard = ({
  categoryTree,
}: {
  categoryTree: GetCategoryPageDataQuery['categoryTree']
}) => {
  const router = useRouter()

  const submitDeleteCategory = async (input: DeleteCategoryInput) => {
    const result = await deleteCategory(input)

    if (result.data?.deleteCategory.ok) {
      toast.success('success')
    } else {
      toast.error('error')
    }
    router.refresh()
  }

  type ChildCategory = {
    id: string
    name: string
    children: ChildCategory[]
  }

  const renderChildren = (children: ChildCategory[], depth: number = 1) => {
    return children.map((child): JSX.Element => {
      return (
        <>
          <li key={child.id} className='flex items-center'>
            {'__'.repeat(depth)}
            {child.name}
            {deleteButton(child.id)}
          </li>
          {renderChildren(child.children, depth + 1)}
        </>
      )
    })
  }

  const deleteButton = (id: string) => {
    return (
      <>
        <button
          className='pl-0.5 text-red-500'
          onClick={() => {
            submitDeleteCategory({ id })
          }}
        >
          <svg xmlns='http://www.w3.org/2000/svg' width='1em' height='1em' viewBox='0 0 24 24'>
            <path
              fill='currentColor'
              d='M7 21q-.825 0-1.412-.587T5 19V6H4V4h5V3h6v1h5v2h-1v13q0 .825-.587 1.413T17 21zm2-4h2V8H9zm4 0h2V8h-2z'
            />
          </svg>
        </button>
      </>
    )
  }

  return (
    <>
      <div className='card w-full bg-neutral'>
        <div className='card-body'>
          <h2 className='card-title pb-4'>カテゴリ一覧</h2>
          <ul>
            {categoryTree.map((category) => {
              return (
                <>
                  <li key={category.id} className='flex items-center'>
                    <Link className='' href={`/categories/${category.name}`}>
                      {category.name}
                    </Link>
                    {deleteButton(category.id)}
                  </li>
                  {renderChildren(category.children as ChildCategory[])}
                </>
              )
            })}
          </ul>
        </div>
      </div>
    </>
  )
}

export default CategoriesCard
