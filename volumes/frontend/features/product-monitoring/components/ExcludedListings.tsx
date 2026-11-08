import NextImage from 'next/image'

import { platformName } from '@/features/product-monitoring/lib/platform'

type ExcludedListingItem = {
  key: string
  platform: string
  name: string
  productUrl: string
  thumbnailUrl: string | null
}

interface Props {
  items: ExcludedListingItem[]
  disabled?: boolean
  onRestore: (key: string) => void
}

// 除外した出品を、判断できるよう画像・名前・商品ページへのリンクつきで並べる。
// 件数が増えてもモーダルが伸びないよう、折りたたんで高さを決めてスクロールさせる
export default function ExcludedListings({ items, disabled, onRestore }: Props) {
  if (items.length === 0) return null

  return (
    <details className='collapse-arrow collapse rounded-box border border-base-300'>
      <summary className='collapse-title min-h-0 py-2 text-sm font-semibold'>
        除外した出品（{items.length}件）
      </summary>
      <ul className='collapse-content max-h-64 space-y-2 overflow-y-auto'>
        {items.map((item) => (
          <li key={item.key} className='flex items-center gap-3'>
            <span className='relative size-10 shrink-0 overflow-hidden rounded bg-white'>
              {item.thumbnailUrl && (
                <NextImage
                  src={item.thumbnailUrl}
                  alt=''
                  fill
                  sizes='40px'
                  className='object-contain'
                />
              )}
            </span>
            <span className='min-w-0 flex-1'>
              <a
                className='link-hover line-clamp-1 text-sm'
                href={item.productUrl}
                target='_blank'
                rel='noopener noreferrer'
                title={item.name}
              >
                {item.name}
              </a>
              <span className='text-xs opacity-60'>{platformName(item.platform)}</span>
            </span>
            <button
              type='button'
              className='btn btn-ghost btn-xs shrink-0'
              disabled={disabled}
              aria-label={`${item.name}の除外を取り消す`}
              onClick={() => onRestore(item.key)}
            >
              取り消す
            </button>
          </li>
        ))}
      </ul>
    </details>
  )
}
