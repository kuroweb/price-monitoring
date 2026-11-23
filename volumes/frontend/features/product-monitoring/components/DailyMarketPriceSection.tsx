'use client'

import { useRef, useState } from 'react'

import { useRouter } from 'next/navigation'
import { toast } from 'react-toastify'

import {
  aggregateDailyMarketPrices,
} from '@/features/product-monitoring/api/actions'
import type {
  DailyMarketPrice,
  Monitor,
  CrawlResult,
} from '@/features/product-monitoring/api/types'
import { formatDate, formatYen } from '@/lib/format'

import CrawlResultCard from './CrawlResultCard'
import DailyMarketPriceChart from './DailyMarketPriceChart'
import ResultPagination from './ResultPagination'

const TRANSACTIONS_PER_PAGE = 12
const PERIODS = [7, 14, 30] as const
type Period = (typeof PERIODS)[number]
type View = 'chart' | 'table'

interface Props {
  monitor: Monitor
  dailyMarketPrices: DailyMarketPrice[]
  // 取得に失敗したときは null
  transactions: CrawlResult[] | null
}

// 期間内で取引があった日の件数で重み付けした平均
const summarize = (results: DailyMarketPrice[]) => {
  const purchased = results.filter((item) => item.averageTransactionPrice != null)
  const count = purchased.reduce((sum, item) => sum + item.transactionCount, 0)
  const total = purchased.reduce(
    (sum, item) => sum + item.averageTransactionPrice! * item.transactionCount,
    0,
  )
  return {
    latest: purchased.at(-1) ?? null,
    average: count > 0 ? Math.round(total / count) : null,
    count,
  }
}

export default function DailyMarketPriceSection({
  monitor,
  dailyMarketPrices,
  transactions,
}: Props) {
  const router = useRouter()
  const [busy, setBusy] = useState(false)
  const [period, setPeriod] = useState<Period>(30)
  const [transactionPage, setTransactionPage] = useState(1)
  const [view, setView] = useState<View>('chart')
  const inFlightRef = useRef(false)
  const results = dailyMarketPrices.slice(-period)
  const summary = summarize(results)
  // sold_at は日本時間の ISO 文字列なので、先頭の日付で表示期間と比べる
  const purchases = transactions?.filter(
    (item) => item.soldAt != null && item.soldAt.substring(0, 10) >= results[0]?.date,
  )

  const lastPage = Math.max(1, Math.ceil((purchases?.length ?? 0) / TRANSACTIONS_PER_PAGE))
  const page = Math.min(transactionPage, lastPage)
  const start = (page - 1) * TRANSACTIONS_PER_PAGE

  const calculate = async () => {
    if (inFlightRef.current) return
    inFlightRef.current = true
    setBusy(true)
    try {
      const result = await aggregateDailyMarketPrices(monitor.id)
      if (result.status !== 200) {
        toast.error('集計に失敗しました')
        return
      }
      toast.success('直近30日を集計しました')
      router.refresh()
    } catch {
      toast.error('通信に失敗しました')
    } finally {
      inFlightRef.current = false
      setBusy(false)
    }
  }

  return (
    <section
      className='space-y-4 rounded-box bg-base-200 p-4'
      aria-label={`${monitor.name}の日次相場`}
    >
      <div className='flex flex-wrap items-start justify-between gap-3'>
        <h4 className='font-semibold'>日次相場</h4>
        <div className='flex gap-2'>
          <button
            type='button'
            className='btn btn-sm btn-primary'
            disabled={busy}
            onClick={calculate}
          >
            {busy ? '集計中…' : '直近30日を集計'}
          </button>
        </div>
      </div>

      {dailyMarketPrices.length === 0 ? (
        <p className='text-sm'>日次相場はありません。</p>
      ) : (
        <>
          <div className='grid grid-cols-1 gap-3 sm:grid-cols-3'>
            <div className='rounded-box bg-base-100 p-4'>
              <p className='text-xs opacity-70'>直近の平均取引価格</p>
              <p className='text-2xl font-semibold'>
                {summary.latest ? formatYen(summary.latest.averageTransactionPrice!) : '-'}
              </p>
              <p className='text-xs opacity-70'>
                {summary.latest ? `${formatDate(summary.latest.date)}の取引` : '期間内の取引なし'}
              </p>
            </div>
            <div className='rounded-box bg-base-100 p-4'>
              <p className='text-xs opacity-70'>期間の平均取引価格</p>
              <p className='text-2xl font-semibold'>
                {summary.average != null ? formatYen(summary.average) : '-'}
              </p>
              <p className='text-xs opacity-70'>直近{period}日・取引件数で加重</p>
            </div>
            <div className='rounded-box bg-base-100 p-4'>
              <p className='text-xs opacity-70'>取引件数</p>
              <p className='text-2xl font-semibold'>{summary.count}件</p>
              <p className='text-xs opacity-70'>直近{period}日の合計</p>
            </div>
          </div>

          <div className='flex flex-wrap items-center justify-between gap-2'>
            <div className='join' role='group' aria-label='表示期間'>
              {PERIODS.map((value) => (
                <button
                  key={value}
                  type='button'
                  className={`btn join-item btn-sm ${period === value ? 'btn-primary' : 'btn-ghost'}`}
                  aria-pressed={period === value}
                  onClick={() => {
                    if (value === period) return
                    setPeriod(value)
                    setTransactionPage(1)
                  }}
                >
                  {value}日
                </button>
              ))}
            </div>
            <div className='join' role='group' aria-label='表示形式'>
              {(
                [
                  ['chart', 'グラフ'],
                  ['table', '表'],
                ] as const
              ).map(([value, label]) => (
                <button
                  key={value}
                  type='button'
                  className={`btn join-item btn-sm ${view === value ? 'btn-primary' : 'btn-ghost'}`}
                  aria-pressed={view === value}
                  onClick={() => setView(value)}
                >
                  {label}
                </button>
              ))}
            </div>
          </div>

          {view === 'chart' ? (
            <div className='rounded-box bg-base-100 p-4'>
              <DailyMarketPriceChart
                syncId={`aggregation-${monitor.id}`}
                results={results}
              />
            </div>
          ) : (
            <div className='overflow-x-auto rounded-box bg-base-100'>
              <table className='table'>
                <thead>
                  <tr>
                    <th>集計日</th>
                    <th className='text-right'>平均取引価格</th>
                    <th className='text-right'>取引件数</th>
                  </tr>
                </thead>
                <tbody>
                  {[...results].reverse().map((item) => (
                    <tr key={item.id}>
                      <td>{item.date}</td>
                      <td className='text-right tabular-nums'>
                        {item.averageTransactionPrice == null
                          ? '-'
                          : formatYen(item.averageTransactionPrice)}
                      </td>
                      <td className='text-right tabular-nums'>{item.transactionCount}件</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}

          <div className='space-y-2'>
            <h4 className='font-semibold'>
              取引
              {purchases && (
                <span className='ml-2 text-xs font-normal opacity-70'>
                  直近{period}日・{purchases.length}件
                </span>
              )}
            </h4>
            {!purchases ? (
              <p className='text-sm opacity-70'>
                取引を取得できませんでした。再読み込みしてください。
              </p>
            ) : purchases.length === 0 ? (
              <p className='text-sm opacity-70'>期間内に取引はありません。</p>
            ) : (
              <>
                <ul key={page} className='flex snap-x gap-3 overflow-x-auto pb-2'>
                  {purchases.slice(start, start + TRANSACTIONS_PER_PAGE).map((item) => (
                    <li key={item.id} className='w-40 shrink-0 snap-start sm:w-44'>
                      <CrawlResultCard crawlResult={item} />
                    </li>
                  ))}
                </ul>
                <ResultPagination label='取引のページ' page={page} hasMore={page < lastPage} onChange={setTransactionPage} />
              </>
            )}
          </div>
        </>
      )}
    </section>
  )
}
