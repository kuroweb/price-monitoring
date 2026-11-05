import NextImage from 'next/image'

import { platformColors, platformName } from '@/features/admin/product-crawl-settings/lib/platform'
import type { ProductCrawlResult } from '@/lib/api'

const soldName = (sold: boolean | null) => (sold == null ? null : sold ? '売り切れ' : '販売中')
const date = (value: string | null) => (value ? value.substring(0, 10) : null)

interface Props {
  productCrawlResult: ProductCrawlResult
  disabled?: boolean
  onExclude: (item: ProductCrawlResult) => void
}

export default function ProductCrawlResultCard({
  productCrawlResult: item,
  disabled,
  onExclude,
}: Props) {
  const status = soldName(item.sold)
  const boughtDate = date(item.boughtDate)
  const endDate = date(item.endDate)

  return (
    <article className='card bg-base-100 shadow-xl'>
      <figure className='relative'>
        <a
          href={item.productUrl}
          target='_blank'
          rel='noopener noreferrer'
          aria-label={`${item.name}の商品ページを開く`}
          className='relative h-32 w-full'
        >
          {item.thumbnailUrl ? (
            <NextImage
              src={item.thumbnailUrl}
              alt=''
              fill
              sizes='(max-width: 640px) 50vw, 200px'
              style={{ objectFit: 'contain' }}
            />
          ) : (
            <span className='flex h-full items-center justify-center bg-base-200 text-xs'>
              画像なし
            </span>
          )}
        </a>
        <div
          className={`badge ${platformColors[item.platform] ?? 'badge-neutral'} absolute inset-s-2 top-2 text-black`}
        >
          {platformName(item.platform)}
        </div>
        <div className='dropdown dropdown-left absolute inset-e-2 top-2'>
          <button type='button' aria-label={`${item.name}の操作`} className='btn btn-square btn-sm'>
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
                type='button'
                className='btn btn-error'
                disabled={disabled}
                onClick={() => onExclude(item)}
              >
                除外
              </button>
            </li>
          </ul>
        </div>
      </figure>
      <a
        href={item.productUrl}
        target='_blank'
        rel='noopener noreferrer'
        className='card-body cursor-pointer gap-2 p-4'
      >
        <p className='line-clamp-2 text-sm'>{item.name}</p>
        <div className='flex flex-wrap justify-end gap-1'>
          {status && <span className='badge badge-ghost text-xs'>{status}</span>}
          <span className='badge badge-outline whitespace-nowrap text-xs'>
            {`${item.price.toLocaleString()}円`}
          </span>
          {item.buyoutPrice != null && (
            <span className='badge badge-outline whitespace-nowrap text-xs'>
              {`即決: ${item.buyoutPrice.toLocaleString()}円`}
            </span>
          )}
        </div>
        {(boughtDate || endDate) && (
          <p className='text-right text-xs'>
            {boughtDate ? `売れた日: ${boughtDate}` : `終了日: ${endDate}`}
          </p>
        )}
      </a>
    </article>
  )
}
