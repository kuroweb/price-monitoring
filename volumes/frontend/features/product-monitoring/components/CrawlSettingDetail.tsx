'use client'

import { useState } from 'react'

import type {
  CrawlResult,
  CrawlSetting,
} from '@/features/product-monitoring/api/types'
import CrawlSettingFormModal from '@/features/product-monitoring/components/CrawlSettingFormModal'

import { useCrawlResultActions } from '../hooks/useCrawlResultActions'

import CrawlResultCard from './CrawlResultCard'
import ResultPagination from './ResultPagination'

const RESULTS_PER_PAGE = 12

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

const matchesStatus = (item: CrawlResult, filter: StatusFilter) =>
  filter === 'all' || (filter === 'sold' ? item.sold === true : item.sold !== true)

const sortResults = (items: CrawlResult[], sort: Sort) => {
  if (sort === 'newest') return items

  const direction = sort === 'price_asc' ? 1 : -1
  return [...items].sort((a, b) => direction * (a.price - b.price))
}

interface Props {
  crawlSetting: CrawlSetting
  crawlResults: CrawlResult[]
}

export default function CrawlSettingDetail({
  crawlSetting,
  crawlResults,
}: Props) {
  const [statusFilter, setStatusFilter] = useState<StatusFilter>('all')
  const [sort, setSort] = useState<Sort>('newest')
  const [selectedPage, setSelectedPage] = useState(1)
  const [editing, setEditing] = useState(false)
  const { busy, sync, exclude, remove } = useCrawlResultActions()

  const counts = {
    all: crawlResults.length,
    on_sale: crawlResults.filter((item) => matchesStatus(item, 'on_sale')).length,
    sold: crawlResults.filter((item) => matchesStatus(item, 'sold')).length,
  }
  const matchingResults = sortResults(
    crawlResults.filter((item) => matchesStatus(item, statusFilter)),
    sort,
  )
  const lastPage = Math.max(1, Math.ceil(matchingResults.length / RESULTS_PER_PAGE))
  const page = Math.min(selectedPage, lastPage)
  const start = (page - 1) * RESULTS_PER_PAGE
  const visibleResults = matchingResults.slice(start, start + RESULTS_PER_PAGE)

  return (
    <section
      className='space-y-4 rounded-box bg-base-200 p-4'
      aria-label={crawlSetting.name}
    >
      <div className='flex flex-wrap items-center justify-between gap-3'>
        <div>
          <p className='text-sm opacity-70'>
            {crawlSetting.enabled ? '有効' : '無効'}・サイト{crawlSetting.platforms.length}件・検索結果URL{crawlSetting.searchUrls.length}件・{counts.all}件
          </p>
        </div>
        <div className='flex gap-2'>
          <button type='button' className='btn btn-ghost btn-sm' onClick={() => setEditing(true)}>
            設定を編集
          </button>
          <button type='button' className='btn btn-sm btn-primary' disabled={busy} onClick={() => sync(crawlSetting.id)}>
            {busy ? '取得中…' : '取得して保存'}
          </button>
        </div>
      </div>
      {crawlResults.length === 0 ? (
        <p className='text-sm'>収集結果はありません。「取得して保存」で取得してください。</p>
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
                  onClick={() => {
                    if (value === statusFilter) return
                    setStatusFilter(value)
                    setSelectedPage(1)
                  }}
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
              onChange={(event) => {
                setSort(event.target.value as Sort)
                setSelectedPage(1)
              }}
            >
              {SORTS.map(([value, label]) => (
                <option key={value} value={value}>
                  {label}
                </option>
              ))}
            </select>
          </div>
          {visibleResults.length === 0 ? (
            <p className='text-sm'>該当する収集結果はありません。</p>
          ) : (
            <div className='grid grid-cols-2 gap-3 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 2xl:grid-cols-8'>
              {visibleResults.map((item) => (
                <CrawlResultCard
                  key={item.id}
                  crawlResult={item}
                  disabled={busy}
                  onExclude={exclude}
                  onDelete={remove}
                />
              ))}
            </div>
          )}
          <ResultPagination label='収集結果のページ' page={page} hasMore={page < lastPage} onChange={setSelectedPage} />
        </>
      )}
      {editing && (
        <CrawlSettingFormModal
          setting={crawlSetting}
          onClose={() => setEditing(false)}
        />
      )}
    </section>
  )
}
