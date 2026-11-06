'use client'

import { useState } from 'react'

import Link from 'next/link'

import type { ProductCrawlResult, ProductCrawlSetting } from '@/features/product-monitoring/api/types'
import ProductCrawlSettingFormModal from '@/features/product-monitoring/components/ProductCrawlSettingFormModal'

import { useProductCrawlResultActions } from '../hooks/useProductCrawlResultActions'

import ProductCrawlResultCard from './ProductCrawlResultCard'

const PREVIEW_COUNT = 8

interface Props {
  productCrawlSetting: ProductCrawlSetting
  productCrawlResults: ProductCrawlResult[]
}

// 一覧では新着の数件だけを横に並べ、除外はここでもできる。全件・絞り込み・取得は詳細画面に任せる
export default function ProductCrawlResultsSection({
  productCrawlSetting,
  productCrawlResults,
}: Props) {
  const href = `/product-crawl-results/${productCrawlSetting.id}`
  const soldCount = productCrawlResults.filter((item) => item.sold === true).length
  const { busy, exclude } = useProductCrawlResultActions(productCrawlSetting)
  const [editing, setEditing] = useState(false)

  return (
    <section className='space-y-3' aria-label={productCrawlSetting.name}>
      <div className='flex flex-wrap items-end justify-between gap-2'>
        <div>
          <h3 className='text-lg font-semibold leading-tight'>
            <Link className='link-hover' href={href}>
              {productCrawlSetting.name}
            </Link>
          </h3>
          <p className='text-xs opacity-70'>
            {productCrawlResults.length}件・販売中 {productCrawlResults.length - soldCount}
            ・売り切れ {soldCount}
          </p>
        </div>
        <div className='flex gap-1'>
          <button type='button' className='btn btn-ghost btn-sm' onClick={() => setEditing(true)}>
            設定を編集
          </button>
          <Link className='btn btn-ghost btn-sm' href={href}>
            すべて見る
            <span aria-hidden='true'>›</span>
          </Link>
        </div>
      </div>
      {productCrawlResults.length === 0 ? (
        <p className='text-sm opacity-70'>
          商品計測結果はありません。詳細画面の「取得して保存」で取得してください。
        </p>
      ) : (
        <ul className='flex snap-x gap-3 overflow-x-auto pb-2'>
          {productCrawlResults.slice(0, PREVIEW_COUNT).map((item) => (
            <li key={item.id} className='w-40 shrink-0 snap-start sm:w-44'>
              <ProductCrawlResultCard
                productCrawlResult={item}
                disabled={busy}
                onExclude={exclude}
              />
            </li>
          ))}
        </ul>
      )}
      {editing && (
        <ProductCrawlSettingFormModal
          setting={productCrawlSetting}
          onClose={() => setEditing(false)}
        />
      )}
    </section>
  )
}
