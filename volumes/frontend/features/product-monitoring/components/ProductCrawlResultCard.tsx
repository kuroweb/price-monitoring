import NextImage from 'next/image'

import MoreIcon from '@/components/ui/MoreIcon'
import type { ProductCrawlResult } from '@/features/product-monitoring/api/types'
import { formatDate, formatYen, platformColors, platformName } from '@/lib/format'

interface Props {
  productCrawlResult: ProductCrawlResult
  disabled?: boolean
  onExclude?: (item: ProductCrawlResult) => void
}

// 売れた日を優先し、オークションは終了日を出す。どちらもなければ出さない
const dateLabel = (item: ProductCrawlResult) => {
  if (item.boughtDate) return `${formatDate(item.boughtDate)} に売れた`
  if (item.endDate) return `${formatDate(item.endDate)} 終了`
  if (item.sold) return '売れた日は未取得'
  return null
}

export default function ProductCrawlResultCard({
  productCrawlResult: item,
  disabled,
  onExclude,
}: Props) {
  const date = dateLabel(item)

  return (
    <article className='card h-full overflow-hidden bg-base-100 shadow-md'>
      <figure className='relative aspect-square bg-white'>
        <a
          href={item.productUrl}
          target='_blank'
          rel='noopener noreferrer'
          aria-label={`${item.name}の商品ページを開く`}
          className='relative block h-full w-full'
        >
          {item.thumbnailUrl ? (
            <NextImage
              src={item.thumbnailUrl}
              alt=''
              fill
              sizes='(max-width: 640px) 50vw, 240px'
              className={`object-contain p-2 ${item.sold ? 'opacity-50' : ''}`}
            />
          ) : (
            <span className='flex h-full items-center justify-center bg-base-200 text-xs opacity-60'>
              画像なし
            </span>
          )}
        </a>
        <span
          className={`badge badge-sm absolute top-2 left-2 border-0 text-black ${platformColors[item.platform] ?? 'badge-neutral'}`}
        >
          {platformName(item.platform)}
        </span>
        {item.sold && (
          <span className='badge badge-sm badge-neutral absolute bottom-2 left-2 font-semibold'>
            売り切れ
          </span>
        )}
        {onExclude && (
          <div className='dropdown dropdown-left dropdown-start absolute top-1 right-1'>
            <button
              type='button'
              aria-label={`${item.name}の操作`}
              className='btn btn-square btn-ghost btn-sm bg-base-100/80'
            >
              <MoreIcon />
            </button>
            <ul className='menu dropdown-content invisible pointer-events-none [.dropdown:focus-within_&]:visible [.dropdown:focus-within_&]:pointer-events-auto z-1 w-max rounded-box border border-base-300 bg-base-100 p-2 shadow-lg'>
              <li>
                <button
                  type='button'
                  className='btn btn-error btn-sm'
                  disabled={disabled}
                  onClick={() => onExclude(item)}
                >
                  除外
                </button>
              </li>
            </ul>
          </div>
        )}
      </figure>
      <a
        href={item.productUrl}
        target='_blank'
        rel='noopener noreferrer'
        className='flex flex-1 flex-col gap-1 p-3'
      >
        <p className='line-clamp-2 min-h-10 text-sm leading-5'>{item.name}</p>
        <p className='mt-auto text-lg font-bold tabular-nums'>{formatYen(item.price)}</p>
        {item.buyoutPrice != null && (
          <p className='text-xs tabular-nums opacity-70'>即決 {formatYen(item.buyoutPrice)}</p>
        )}
        {date && <p className='text-xs opacity-60'>{date}</p>}
      </a>
    </article>
  )
}
