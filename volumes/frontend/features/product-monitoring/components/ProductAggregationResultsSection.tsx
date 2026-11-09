'use client'

import { useRef, useState } from 'react'

import { useRouter } from 'next/navigation'
import { toast } from 'react-toastify'

import {
  calculateProductAggregationSetting,
} from '@/features/product-monitoring/api/actions'
import type {
  ProductAggregationResult,
  ProductAggregationSetting,
  ProductCrawlResult,
} from '@/features/product-monitoring/api/types'
import { formatDate, formatYen } from '@/lib/format'

import ProductAggregationChart from './ProductAggregationChart'
import ProductCrawlResultCard from './ProductCrawlResultCard'

const PERIODS = [7, 14, 30] as const
type Period = (typeof PERIODS)[number]
type View = 'chart' | 'table'

interface Props {
  productAggregationSetting: ProductAggregationSetting
  productAggregationResults: ProductAggregationResult[]
  // 取得に失敗したときは null
  productAggregationPurchases: ProductCrawlResult[] | null
}

// 期間内で購入があった日の件数で重み付けした平均
const summarize = (results: ProductAggregationResult[]) => {
  const purchased = results.filter((item) => item.averagePurchasePrice != null)
  const count = purchased.reduce((sum, item) => sum + item.purchaseCount, 0)
  const total = purchased.reduce(
    (sum, item) => sum + item.averagePurchasePrice! * item.purchaseCount,
    0,
  )
  return {
    latest: purchased.at(-1) ?? null,
    average: count > 0 ? Math.round(total / count) : null,
    count,
  }
}

export default function ProductAggregationResultsSection({
  productAggregationSetting,
  productAggregationResults,
  productAggregationPurchases,
}: Props) {
  const router = useRouter()
  const [busy, setBusy] = useState(false)
  const [period, setPeriod] = useState<Period>(30)
  const [view, setView] = useState<View>('chart')
  const inFlightRef = useRef(false)
  const results = productAggregationResults.slice(-period)
  const summary = summarize(results)
  // bought_date は日本時間の ISO 文字列なので、先頭の日付で表示期間と比べる
  const purchases = productAggregationPurchases?.filter(
    (item) => item.boughtDate != null && item.boughtDate.substring(0, 10) >= results[0]?.date,
  )

  const calculate = async () => {
    if (inFlightRef.current) return
    inFlightRef.current = true
    setBusy(true)
    try {
      const result = await calculateProductAggregationSetting(productAggregationSetting.id)
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
      aria-label={`${productAggregationSetting.name}の商品相場`}
    >
      <div className='flex flex-wrap items-start justify-between gap-3'>
        <h4 className='font-semibold'>商品相場</h4>
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

      {productAggregationResults.length === 0 ? (
        <p className='text-sm'>商品日次相場はありません。</p>
      ) : (
        <>
          <div className='grid grid-cols-1 gap-3 sm:grid-cols-3'>
            <div className='rounded-box bg-base-100 p-4'>
              <p className='text-xs opacity-70'>直近の平均購入価格</p>
              <p className='text-2xl font-semibold'>
                {summary.latest ? formatYen(summary.latest.averagePurchasePrice!) : '-'}
              </p>
              <p className='text-xs opacity-70'>
                {summary.latest ? `${formatDate(summary.latest.date)}の購入` : '期間内の購入なし'}
              </p>
            </div>
            <div className='rounded-box bg-base-100 p-4'>
              <p className='text-xs opacity-70'>期間の平均購入価格</p>
              <p className='text-2xl font-semibold'>
                {summary.average != null ? formatYen(summary.average) : '-'}
              </p>
              <p className='text-xs opacity-70'>直近{period}日・購入件数で加重</p>
            </div>
            <div className='rounded-box bg-base-100 p-4'>
              <p className='text-xs opacity-70'>購入件数</p>
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
                  onClick={() => setPeriod(value)}
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
              <ProductAggregationChart
                syncId={`aggregation-${productAggregationSetting.id}`}
                results={results}
              />
            </div>
          ) : (
            <div className='overflow-x-auto rounded-box bg-base-100'>
              <table className='table'>
                <thead>
                  <tr>
                    <th>集計日</th>
                    <th className='text-right'>平均購入価格</th>
                    <th className='text-right'>購入件数</th>
                  </tr>
                </thead>
                <tbody>
                  {[...results].reverse().map((item) => (
                    <tr key={item.id}>
                      <td>{item.date}</td>
                      <td className='text-right tabular-nums'>
                        {item.averagePurchasePrice == null
                          ? '-'
                          : formatYen(item.averagePurchasePrice)}
                      </td>
                      <td className='text-right tabular-nums'>{item.purchaseCount}件</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}

          <div className='space-y-2'>
            <h4 className='font-semibold'>
              相場対象の商品
              {purchases && (
                <span className='ml-2 text-xs font-normal opacity-70'>
                  直近{period}日・{purchases.length}件
                </span>
              )}
            </h4>
            {!purchases ? (
              <p className='text-sm opacity-70'>
                相場対象の商品を取得できませんでした。再読み込みしてください。
              </p>
            ) : purchases.length === 0 ? (
              <p className='text-sm opacity-70'>期間内に相場対象の商品はありません。</p>
            ) : (
              <ul className='flex snap-x gap-3 overflow-x-auto pb-2'>
                {purchases.map((item) => (
                  <li key={item.id} className='w-40 shrink-0 snap-start sm:w-44'>
                    <ProductCrawlResultCard productCrawlResult={item} />
                  </li>
                ))}
              </ul>
            )}
          </div>
        </>
      )}
    </section>
  )
}
