'use client'

import { useRef, useState } from 'react'

import Link from 'next/link'

import { getMonitorCrawlResults } from '@/features/product-monitoring/api/actions'
import type {
  CrawlResult,
  DailyMarketPrice,
  Monitor,
  MonitorCrawlResultSort,
  MonitorSaleStatus,
} from '@/features/product-monitoring/api/types'
import CrawlResultCard from '@/features/product-monitoring/components/CrawlResultCard'
import DailyMarketPriceSection from '@/features/product-monitoring/components/DailyMarketPriceSection'
import MonitorFormModal from '@/features/product-monitoring/components/MonitorFormModal'
import ResultPagination from '@/features/product-monitoring/components/ResultPagination'
import { useCrawlResultActions } from '@/features/product-monitoring/hooks/useCrawlResultActions'
import { formatYen } from '@/lib/format'

const STATUS_FILTERS = [
  ['all', 'すべて'],
  ['on_sale', '販売中'],
  ['sold', '売り切れ'],
] as const
type StatusFilter = MonitorSaleStatus

const SORTS = [
  ['newest', '新着順'],
  ['price_asc', '価格の安い順'],
  ['price_desc', '価格の高い順'],
] as const
type Sort = MonitorCrawlResultSort

type Props = {
  monitor: Monitor
  crawlResults: CrawlResult[] | null
  hasMore: boolean
  dailyMarketPrices: DailyMarketPrice[] | null
  transactions: CrawlResult[] | null
  discordConfigured: boolean
}

export default function MonitorDetail({
  monitor,
  crawlResults,
  hasMore: initialHasMore,
  dailyMarketPrices,
  transactions,
  discordConfigured,
}: Props) {
  const [editing, setEditing] = useState(false)
  const [statusFilter, setStatusFilter] = useState<StatusFilter>('all')
  const [sort, setSort] = useState<Sort>('newest')
  const [items, setItems] = useState<CrawlResult[] | null>(crawlResults)
  const [page, setPage] = useState(1)
  const [hasMore, setHasMore] = useState(initialHasMore)
  const [loading, setLoading] = useState(false)
  const [failed, setFailed] = useState(false)
  const [serverPage, setServerPage] = useState({ crawlResults, hasMore: initialHasMore })
  const requestSeqRef = useRef(0)
  const { busy, exclude, remove } = useCrawlResultActions()

  if (crawlResults !== serverPage.crawlResults || initialHasMore !== serverPage.hasMore) {
    requestSeqRef.current += 1
    setServerPage({ crawlResults, hasMore: initialHasMore })
    setStatusFilter('all')
    setSort('newest')
    setItems(crawlResults)
    setPage(1)
    setHasMore(initialHasMore)
    setLoading(false)
    setFailed(false)
  }

  const fetchPage = async (nextStatus: StatusFilter, nextSort: Sort, nextPage: number) => {
    const seq = ++requestSeqRef.current
    setLoading(true)
    setFailed(false)
    try {
      const result = await getMonitorCrawlResults(monitor.id, {
        saleStatus: nextStatus,
        sort: nextSort,
        page: nextPage,
      })
      if (seq !== requestSeqRef.current) return
      const data = result.data
      if (!data) {
        setFailed(true)
        return
      }
      setItems(data.crawlResults)
      setStatusFilter(nextStatus)
      setSort(nextSort)
      setPage(nextPage)
      setHasMore(Boolean(data.hasMore))
    } catch {
      if (seq !== requestSeqRef.current) return
      setFailed(true)
    } finally {
      if (seq === requestSeqRef.current) setLoading(false)
    }
  }

  const changeStatus = (value: StatusFilter) => {
    if (loading || value === statusFilter) return
    return fetchPage(value, sort, 1)
  }

  const changeSort = (value: Sort) => {
    if (loading || value === sort) return
    return fetchPage(statusFilter, value, 1)
  }

  const changePage = (nextPage: number) => {
    if (loading || nextPage < 1 || nextPage === page || (nextPage > page && !hasMore)) return
    return fetchPage(statusFilter, sort, nextPage)
  }

  const priceRange = monitor.minPrice != null || monitor.maxPrice != null
    ? `${monitor.minPrice != null ? formatYen(monitor.minPrice) : '下限なし'} 〜 ${monitor.maxPrice != null ? formatYen(monitor.maxPrice) : '上限なし'}`
    : '指定なし'
  const untouched = statusFilter === 'all' && sort === 'newest' && page === 1 && !failed

  return (
    <div className='space-y-4'>
      <nav className='breadcrumbs p-0 text-sm text-base-content/65' aria-label='パンくずリスト'>
        <ul>
          <li><Link href='/product-monitoring/monitors'>モニタリング設定</Link></li>
          <li aria-current='page'>{monitor.name}</li>
        </ul>
      </nav>

      <header className='flex flex-wrap items-start justify-between gap-4'>
        <div className='min-w-0 space-y-2'>
          <h1 className='card-title break-words'>{monitor.name}</h1>
        </div>
        <button type='button' className='btn btn-ghost btn-sm' onClick={() => setEditing(true)}>
          条件を編集
        </button>
      </header>

      <section className='rounded-box bg-base-200 p-4' aria-labelledby='watch-conditions'>
        <div className='flex flex-wrap items-center justify-between gap-2'>
          <h2 id='watch-conditions' className='font-semibold'>抽出条件</h2>
          <div className='flex flex-wrap gap-2'>
            <span className={`badge badge-sm ${monitor.enabled ? 'badge-success' : 'badge-ghost'}`}>
              {monitor.enabled ? '最安値の通知評価：有効' : '最安値の通知評価：停止中'}
            </span>
            <span className={`badge badge-sm ${monitor.newestNotificationEnabled ? 'badge-success' : 'badge-ghost'}`}>
              {monitor.newestNotificationEnabled ? '新着の通知評価：有効' : '新着の通知評価：停止中'}
            </span>
          </div>
        </div>
        <dl className='mt-4 grid gap-4 text-sm sm:grid-cols-3'>
          <div><dt className='text-base-content/60'>必須語</dt><dd className='mt-1 break-words'>{monitor.requiredKeywords.join('、') || '指定なし'}</dd></div>
          <div><dt className='text-base-content/60'>除外語</dt><dd className='mt-1 break-words'>{monitor.negativeKeywords.join('、') || '指定なし'}</dd></div>
          <div><dt className='text-base-content/60'>価格帯</dt><dd className='mt-1 tabular-nums'>{priceRange}</dd></div>
        </dl>
        {(monitor.enabled || monitor.newestNotificationEnabled) && !discordConfigured && (
          <p className='mt-4 text-sm text-warning'>Discord通知は利用できません。送信先を確認してください。</p>
        )}
      </section>

      <section className='space-y-4 rounded-box bg-base-200 p-4' aria-labelledby='watch-listings'>
        <div>
          <h2 id='watch-listings' className='text-lg font-semibold'>新着の収集結果</h2>
          <p className='mt-1 text-sm text-base-content/60'>
            在庫は集めた時点のものです。新着順では、売れた日が未取得の売り切れを末尾に置きます。
          </p>
        </div>
        {items === null ? (
          <p role='alert' className='text-sm text-error'>収集結果を取得できませんでした。再読み込みしてください。</p>
        ) : items.length === 0 && untouched ? (
          <p className='rounded-box bg-base-200 px-4 py-8 text-center text-sm text-base-content/70'>条件に一致する収集結果はありません。</p>
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
                    disabled={loading}
                    onClick={() => changeStatus(value)}
                  >
                    {label}
                  </button>
                ))}
              </div>
              <select
                className='select select-sm w-auto'
                aria-label='並び順'
                value={sort}
                disabled={loading}
                onChange={(event) => changeSort(event.target.value as Sort)}
              >
                {SORTS.map(([value, label]) => (
                  <option key={value} value={value}>
                    {label}
                  </option>
                ))}
              </select>
            </div>
            {failed && (
              <p role='alert' className='text-sm text-error'>収集結果を取得できませんでした。もう一度試してください。</p>
            )}
            {!failed && items.length === 0 && (
              <p className='text-sm'>該当する収集結果はありません。</p>
            )}
            {items.length > 0 && (
              <ul className='grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-4 xl:grid-cols-6'>
                {items.map((item) => (
                  <li key={item.id} className='min-w-0'>
                    <CrawlResultCard crawlResult={item} disabled={busy} onExclude={exclude} onDelete={remove} />
                  </li>
                ))}
              </ul>
            )}
            <ResultPagination label='収集結果のページ' page={page} hasMore={hasMore} disabled={loading} onChange={changePage} />
          </>
        )}
      </section>

      {dailyMarketPrices === null ? (
        <section className='rounded-box bg-base-200 p-4' aria-label='日次相場'>
          <h2 className='text-lg font-semibold'>日次相場</h2>
          <p role='alert' className='mt-3 text-sm text-error'>日次相場を取得できませんでした。再読み込みしてください。</p>
        </section>
      ) : (
        <DailyMarketPriceSection
          monitor={monitor}
          dailyMarketPrices={dailyMarketPrices}
          transactions={transactions}
        />
      )}
      {editing && <MonitorFormModal monitor={monitor} onClose={() => setEditing(false)} />}
    </div>
  )
}
