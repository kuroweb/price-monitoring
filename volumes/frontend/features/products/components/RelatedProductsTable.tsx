'use client'

import NextImage from 'next/image'

import { usePublishedState } from '../hooks/usePublishedState'

import { GetProductDetailPageDataQuery } from '@/graphql/dist/client'

const RelatedProductsTable = ({
  relatedProducts,
}: {
  relatedProducts: GetProductDetailPageDataQuery['product']['relatedProducts']
}) => {
  const [published, _] = usePublishedState()

  const serviceDomainMap: { [key: string]: string } = {
    mercari: 'jp.mercari.com/item/',
    yahoo_auction: 'page.auctions.yahoo.co.jp/jp/auction/',
    yahoo_fleamarket: 'paypayfleamarket.yahoo.co.jp/item/',
  }

  const serviceNameMap: { [key: string]: string } = {
    mercari: 'メルカリ',
    yahoo_auction: 'ヤフオク',
    yahoo_fleamarket: 'ペイペイ',
  }

  const handleRowClick = (relatedType: string, externalId: string) => {
    window.open(`https://${serviceDomainMap[relatedType]}${externalId}`, '_blank')
  }

  const parseDate = (date: string | null | undefined) => {
    // 暫定実装
    return date ? date.substring(0, 10) : ''
  }

  return (
    <>
      <table className='table'>
        <thead>
          <tr>
            <th></th>
            <th>商品名</th>
            <th>価格</th>
            {!published && <th>売却日</th>}
            <th></th>
          </tr>
        </thead>
        <tbody>
          {relatedProducts.map((relatedProduct) => (
            <tr
              key={relatedProduct.externalId}
              onClick={() => handleRowClick(relatedProduct.relatedType, relatedProduct.externalId)}
              className='border-b border-base-200 cursor-pointer hover:bg-base-100'
            >
              <td className='p-0 w-16 min-w-16'>{serviceNameMap[relatedProduct.relatedType]}</td>
              <td className='w-36 max-w-36 md:w-full md:max-w-full'>{relatedProduct.name}</td>
              <td className='w-16 min-w-16'>{relatedProduct.price}</td>
              {!published && (
                <td className='w-24 min-w-24 md:w-28 md:min-w-28'>
                  {parseDate(relatedProduct.boughtDate)}
                </td>
              )}
              <td className='p-2 w-20 min-w-20 md:w-24 md:min-w-24'>
                <div className='relative aspect-square'>
                  <NextImage
                    className='object-cover rounded-lg'
                    src={relatedProduct.thumbnailUrl}
                    alt=''
                    fill
                    sizes='100vw, 100vw'
                  />
                </div>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </>
  )
}

export default RelatedProductsTable
