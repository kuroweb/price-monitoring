'use client'

import { Dispatch, SetStateAction } from 'react'

import { useRouter, useParams } from 'next/navigation'
import { toast } from 'react-toastify'

import { deleteYahooAuctionCrawlSettingExcludeCondition } from '@/features/products/server-actions/product-query'
import { GetProductDetailPageDataQuery } from '@/graphql/dist/client'

const ConditionTable = ({
  data,
  setMode,
}: {
  data: GetProductDetailPageDataQuery
  setMode: Dispatch<SetStateAction<'list' | 'create' | 'edit'>>
}) => {
  const params = useParams()
  const router = useRouter()

  const destroy = async (id: string, productId: string) => {
    const result = await deleteYahooAuctionCrawlSettingExcludeCondition(id, productId)
    if (result.data?.deleteYahooAuctionCrawlSettingExcludeCondition.ok) {
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
            <td>キーワード</td>
            <td>商品ID</td>
            <td>出品者ID</td>
            <td></td>
          </tr>
        </thead>
        <tbody>
          {data.product.yahooAuctionCrawlSetting.yahooAuctionCrawlSettingExcludeConditions.map(
            (condition) => (
              <tr key={condition.id}>
                <td>{condition.keyword}</td>
                <td>{condition.yahooAuctionId}</td>
                <td>{condition.sellerId}</td>
                <td className='w-1/12'>
                  <div className='dropdown dropdown-left'>
                    <div tabIndex={0} role='button' className='btn btn-square btn-sm'>
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
                      className='dropdown-content z-[1] menu p-2 shadow bg-base-200 rounded-box w-20'
                    >
                      <li>
                        <a
                          onClick={() => {
                            setMode('edit')
                          }}
                        >
                          編集
                        </a>
                      </li>
                      <li>
                        <a onClick={() => destroy(condition.id, String(params.id))}>削除</a>
                      </li>
                    </ul>
                  </div>
                </td>
              </tr>
            ),
          )}
        </tbody>
      </table>
    </>
  )
}

export default ConditionTable
