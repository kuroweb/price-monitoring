'use client'

import { useState } from 'react'

import Link from 'next/link'

import type {
  DailyMarketPrice,
  CrawlResult,
  Monitor,
} from '@/features/product-monitoring/api/types'
import CrawlResultCard from '@/features/product-monitoring/components/CrawlResultCard'
import DailyMarketPriceSection from '@/features/product-monitoring/components/DailyMarketPriceSection'
import MonitorFormModal from '@/features/product-monitoring/components/MonitorFormModal'
import { useCrawlResultActions } from '@/features/product-monitoring/hooks/useCrawlResultActions'
import { formatYen } from '@/lib/format'

type Props = {
  monitor: Monitor
  crawlResults: CrawlResult[] | null
  dailyMarketPrices: DailyMarketPrice[] | null
  transactions: CrawlResult[] | null
  discordConfigured: boolean
}

export default function MonitorDetail({ monitor, crawlResults, dailyMarketPrices, transactions, discordConfigured }: Props) {
  const [editing, setEditing] = useState(false)
  const { busy, exclude, remove } = useCrawlResultActions()
  const priceRange = monitor.minPrice != null || monitor.maxPrice != null
    ? `${monitor.minPrice != null ? formatYen(monitor.minPrice) : '下限なし'} 〜 ${monitor.maxPrice != null ? formatYen(monitor.maxPrice) : '上限なし'}`
    : '指定なし'

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
          <p className='mt-1 text-sm text-base-content/60'>保存済みの収集結果から、売り切れを含めて新着順に最大8件を表示します。在庫はリアルタイムではありません。</p>
        </div>
        {crawlResults === null ? (
          <p role='alert' className='text-sm text-error'>収集結果を取得できませんでした。再読み込みしてください。</p>
        ) : crawlResults.length === 0 ? (
          <p className='rounded-box bg-base-200 px-4 py-8 text-center text-sm text-base-content/70'>条件に一致する収集結果はありません。</p>
        ) : (
          <ul className='grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-4 xl:grid-cols-6'>
            {crawlResults.map((item) => (
              <li key={item.id} className='min-w-0'>
                <CrawlResultCard crawlResult={item} disabled={busy} onExclude={exclude} onDelete={remove} />
              </li>
            ))}
          </ul>
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
