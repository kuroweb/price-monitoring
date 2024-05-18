'use client'

import { Dispatch, SetStateAction } from 'react'

import { useRouter, useParams } from 'next/navigation'
import { toast } from 'react-toastify'

import { deleteMercariCrawlSettingExcludeProduct } from '@/features/products/server-actions/productQuery'
import {
  GetProductDetailPageDataQuery,
  MercariCrawlSettingExcludeProduct,
} from '@/graphql/dist/client'

const KeywordTable = ({
  data,
  setMode,
  setCondition,
}: {
  data: GetProductDetailPageDataQuery
  setMode: Dispatch<SetStateAction<'list' | 'create' | 'edit'>>
  setCondition: Dispatch<SetStateAction<MercariCrawlSettingExcludeProduct | undefined>>
}) => {
  const params = useParams()
  const router = useRouter()

  const destroy = async (id: string, productId: string) => {
    const result = await deleteMercariCrawlSettingExcludeProduct(id, productId)
    if (result.data?.deleteMercariCrawlSettingExcludeProduct.ok) {
      toast.success('success')
    } else {
      toast.error('error')
    }
    router.refresh()
  }

  return (
    <>
      <table className='table'>
        <thead>
          <tr>
            <td>商品ID</td>
            <td></td>
          </tr>
        </thead>
        <tbody>
          {data.product.mercariCrawlSetting.mercariCrawlSettingExcludeProducts.map((condition) => (
            <tr key={condition.id}>
              <td>{condition.externalId}</td>
              <td className='w-1/12'>
                <div className='dropdown dropdown-left'>
                  <div tabIndex={0} role='button' className='btn btn-square btn-md'>
                    <svg
                      xmlns='http://www.w3.org/2000/svg'
                      fill='none'
                      viewBox='0 0 24 24'
                      className='inline-block w-5 h-5 stroke-current'
                    >
                      <path
                        strokeLinecap='round'
                        strokeLinejoin='round'
                        strokeWidth='2'
                        d='M5 12h.01M12 12h.01M19 12h.01M6 12a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0z'
                      ></path>
                    </svg>
                  </div>
                  <ul
                    tabIndex={0}
                    className='dropdown-content z-[1] menu space-y-2 shadow bg-base-200 rounded-box w-20'
                  >
                    <li>
                      <button
                        className='btn btn-primary'
                        onClick={() => {
                          setCondition(condition)
                          setMode('edit')
                        }}
                      >
                        編集
                      </button>
                    </li>
                    <li>
                      <button
                        className='btn btn-error'
                        onClick={() => destroy(condition.id, String(params.id))}
                      >
                        削除
                      </button>
                    </li>
                  </ul>
                </div>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </>
  )
}

export default KeywordTable
