'use client'

import { useState } from 'react'

import type { ProductCrawlResult, ProductCrawlSetting } from '@/features/product-monitoring/api/types'
import ProductCrawlSettingFormModal from '@/features/product-monitoring/components/ProductCrawlSettingFormModal'

import { useProductCrawlResultActions } from '../hooks/useProductCrawlResultActions'

import ProductCrawlResultCard from './ProductCrawlResultCard'

const STATUS_FILTERS = [
  ['all', 'すべて'],
  ['on_sale', '販売中'],
  ['sold', '売り切れ'],
] as const
type StatusFilter = (typeof STATUS_FILTERS)[number][0]

const SORTS = [
  ['newest', '新着順'],
  ['price_asc', '価格の安い順'],
  ['price_desc', '価格の高い順'],
] as const
type Sort = (typeof SORTS)[number][0]

const matchesStatus = (item: ProductCrawlResult, filter: StatusFilter) =>
  filter === 'all' || (filter === 'sold' ? item.sold === true : item.sold !== true)

const sortResults = (items: ProductCrawlResult[], sort: Sort) =>
  sort === 'newest'
    ? items
    : [...items].sort((a, b) => (sort === 'price_asc' ? a.price - b.price : b.price - a.price))

interface Props {
  productCrawlSetting: ProductCrawlSetting
  productCrawlResults: ProductCrawlResult[]
}

export default function ProductCrawlResultsDetail({
  productCrawlSetting,
  productCrawlResults,
}: Props) {
  const [statusFilter, setStatusFilter] = useState<StatusFilter>('all')
  const [sort, setSort] = useState<Sort>('newest')
  const [editing, setEditing] = useState(false)
  const { busy, sync, exclude } = useProductCrawlResultActions(productCrawlSetting)

  const counts = {
    all: productCrawlResults.length,
    on_sale: productCrawlResults.filter((item) => matchesStatus(item, 'on_sale')).length,
    sold: productCrawlResults.filter((item) => matchesStatus(item, 'sold')).length,
  }
  const visibleResults = sortResults(
    productCrawlResults.filter((item) => matchesStatus(item, statusFilter)),
    sort,
  )

  return (
    <section
      className='space-y-4 rounded-box bg-base-200 p-4'
      aria-label={productCrawlSetting.name}
    >
      <div className='flex flex-wrap items-center justify-between gap-3'>
        <div>
          <p className='text-sm opacity-70'>
            {productCrawlSetting.searchUrls.length} URL・{counts.all}件
          </p>
        </div>
        <div className='flex gap-2'>
          <button type='button' className='btn btn-ghost btn-sm' onClick={() => setEditing(true)}>
            設定を編集
          </button>
          <button type='button' className='btn btn-sm btn-primary' disabled={busy} onClick={sync}>
            {busy ? '取得中…' : '取得して保存'}
          </button>
        </div>
      </div>
      {productCrawlResults.length === 0 ? (
        <p className='text-sm'>商品計測結果はありません。「取得して保存」で取得してください。</p>
      ) : (
        <>
          <div className='flex flex-wrap items-center justify-between gap-2'>
            <div className='join' role='group' aria-label='販売状態'>
              {STATUS_FILTERS.map(([value, label]) => (
                <button
                  key={value}
                  type='button'
                  className={`btn join-item btn-sm ${statusFilter === value ? 'btn-primary' : 'btn-ghost'}`}
                  aria-pressed={statusFilter === value}
                  onClick={() => setStatusFilter(value)}
                >
                  {label}
                  <span className='tabular-nums opacity-60'>{counts[value]}</span>
                </button>
              ))}
            </div>
            <select
              className='select select-sm w-auto'
              aria-label='並び順'
              value={sort}
              onChange={(event) => setSort(event.target.value as Sort)}
            >
              {SORTS.map(([value, label]) => (
                <option key={value} value={value}>
                  {label}
                </option>
              ))}
            </select>
          </div>
          {visibleResults.length === 0 ? (
            <p className='text-sm'>該当する出品はありません。</p>
          ) : (
            <div className='grid grid-cols-2 gap-3 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 2xl:grid-cols-8'>
              {visibleResults.map((item) => (
                <ProductCrawlResultCard
                  key={item.id}
                  productCrawlResult={item}
                  disabled={busy}
                  onExclude={exclude}
                />
              ))}
            </div>
          )}
        </>
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
