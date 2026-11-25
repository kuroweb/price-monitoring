'use client'

import NextImage from 'next/image'
import { useRouter } from 'next/navigation'
import { toast } from 'react-toastify'

import type { RelatedProduct } from '@/features/products/api/types'

import { useStatusState } from '../hooks/useStatusState'

const RelatedProductCard = ({ relatedProduct }: { relatedProduct: RelatedProduct }) => {
  const router = useRouter()
  const [status, _] = useStatusState()

  const serviceDomainMap: { [key: string]: string } = {}

  const serviceNameMap: { [key: string]: string } = {}

  const serviceColorMap: { [key: string]: string } = {}

  const domain = serviceDomainMap[relatedProduct.platform]
  const productUrl = domain ? `https://${domain}${relatedProduct.externalId}` : '#'

  const parseDate = (date: string | null | undefined) => {
    // 暫定実装
    return date ? date.substring(0, 10) : ''
  }

  // 暫定実装
  const createExcludeProduct = async (platform: string, productId: number, externalId: string) => {
    type ExcludeProductResponse = { status: number }
    const platformActions: {
      [key: string]: (
        productId: number,
        data: { externalId: string },
      ) => Promise<ExcludeProductResponse>
    } = {}

    const action = platformActions[platform]

    if (action) {
      try {
        const result = await action(productId, { externalId })
        if (result.status !== 200 && result.status !== 409) {
          toast.error('除外商品の追加に失敗しました')
        } else {
          toast.success('除外商品を追加しました')
        }
      } catch {
        toast.error('除外商品の追加に失敗しました')
      }
    } else {
      toast.error('対応していないプラットフォームです')
    }

    router.refresh()
  }

  return (
    <>
      <div className='card bg-base-100 shadow-xl'>
        <figure>
          <a
            href={productUrl}
            target='_blank'
            rel='noopener noreferrer'
            aria-label={`${relatedProduct.name}の商品ページを開く`}
            className='relative h-32 w-full'
          >
            <NextImage
              src={relatedProduct.thumbnailUrl}
              alt=''
              fill
              sizes='100vh 100vw'
              style={{ objectFit: 'contain' }}
              className='cursor-pointer'
            />
          </a>
          <div
            className={`badge ${serviceColorMap[relatedProduct.platform] ?? ''} absolute inset-s-2 top-2 text-black`}
          >
            {serviceNameMap[relatedProduct.platform]}
          </div>
          <div className='badge badge-neutral absolute inset-e-2 top-24 whitespace-nowrap text-xs'>
            {`終了日: ${
              status == 'published'
                ? relatedProduct.endDate
                  ? parseDate(relatedProduct.endDate)
                  : '-'
                : parseDate(relatedProduct.boughtDate)
            }`}
          </div>
          <div className='dropdown dropdown-left absolute inset-e-2 top-2'>
            <button
              type='button'
              aria-label={`${relatedProduct.name}の操作`}
              className='btn btn-square btn-sm'
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
                  className='btn btn-error'
                  onClick={async () =>
                    createExcludeProduct(
                      relatedProduct.platform,
                      relatedProduct.productId,
                      relatedProduct.externalId,
                    )
                  }
                >
                  除外
                </button>
              </li>
            </ul>
          </div>
        </figure>
        <a
          href={productUrl}
          target='_blank'
          rel='noopener noreferrer'
          className='card-body cursor-pointer p-4'
        >
          <p className='text-sm'>{`${relatedProduct.name.substring(0, 40)}...`}</p>
          <div className='flex-wrap space-y-2'>
            <div className='flex justify-end'>
              <div className='badge badge-outline whitespace-nowrap text-xs'>
                {`現在: ${relatedProduct.price}円`}
              </div>
            </div>
          </div>
        </a>
      </div>
    </>
  )
}

export default RelatedProductCard
