'use client'

import { useState } from 'react'

import Link from 'next/link'

import type {
  ProductAggregationResult,
  ProductCrawlResult,
  ProductWatchSetting,
} from '@/features/product-monitoring/api/types'
import ProductAggregationResultsSection from '@/features/product-monitoring/components/ProductAggregationResultsSection'
import ProductCrawlResultCard from '@/features/product-monitoring/components/ProductCrawlResultCard'
import ProductWatchSettingFormModal from '@/features/product-monitoring/components/ProductWatchSettingFormModal'
import { useProductCrawlResultActions } from '@/features/product-monitoring/hooks/useProductCrawlResultActions'
import { formatYen } from '@/lib/format'

type Props = {
  setting: ProductWatchSetting
  results: ProductCrawlResult[] | null
  daily: ProductAggregationResult[] | null
  purchases: ProductCrawlResult[] | null
  discordConfigured: boolean
}

export default function ProductWatchDetail({ setting, results, daily, purchases, discordConfigured }: Props) {
  const [editing, setEditing] = useState(false)
  const { busy, exclude } = useProductCrawlResultActions()
  const priceRange = setting.minPrice != null || setting.maxPrice != null
    ? `${setting.minPrice != null ? formatYen(setting.minPrice) : '下限なし'} 〜 ${setting.maxPrice != null ? formatYen(setting.maxPrice) : '上限なし'}`
    : '指定なし'

  return (
    <div className='space-y-4'>
      <nav className='breadcrumbs p-0 text-sm text-base-content/65' aria-label='パンくずリスト'>
        <ul>
          <li><Link href='/product-monitoring'>商品モニタリング</Link></li>
          <li aria-current='page'>{setting.name}</li>
        </ul>
      </nav>

      <header className='flex flex-wrap items-start justify-between gap-4'>
        <div className='min-w-0 space-y-2'>
          <h1 className='card-title break-words'>{setting.name}</h1>
        </div>
        <button type='button' className='btn btn-ghost btn-sm' onClick={() => setEditing(true)}>
          条件を編集
        </button>
      </header>

      <section className='rounded-box bg-base-200 p-4' aria-labelledby='watch-conditions'>
        <div className='flex flex-wrap items-center justify-between gap-2'>
          <h2 id='watch-conditions' className='font-semibold'>モニタリング条件</h2>
          <span className={`badge badge-sm ${setting.enabled ? 'badge-success' : 'badge-ghost'}`}>
            {setting.enabled ? '最安値の通知評価：有効' : '最安値の通知評価：停止中'}
          </span>
        </div>
        <dl className='mt-4 grid gap-4 text-sm sm:grid-cols-3'>
          <div><dt className='text-base-content/60'>必須語</dt><dd className='mt-1 break-words'>{setting.requiredKeywords.join('、') || '指定なし'}</dd></div>
          <div><dt className='text-base-content/60'>除外語</dt><dd className='mt-1 break-words'>{setting.excludeKeywords.join('、') || '指定なし'}</dd></div>
          <div><dt className='text-base-content/60'>価格帯</dt><dd className='mt-1 tabular-nums'>{priceRange}</dd></div>
        </dl>
        {setting.enabled && !discordConfigured && (
          <p className='mt-4 text-sm text-warning'>Discord通知は利用できません。送信先を確認してください。</p>
        )}
      </section>

      <section className='space-y-4 rounded-box bg-base-200 p-4' aria-labelledby='watch-listings'>
        <div>
          <h2 id='watch-listings' className='text-lg font-semibold'>販売中の安い商品</h2>
          <p className='mt-1 text-sm text-base-content/60'>保存済みの商品から価格の安い順に最大8件を表示します。在庫はリアルタイムではありません。</p>
        </div>
        {results === null ? (
          <p role='alert' className='text-sm text-error'>商品を取得できませんでした。再読み込みしてください。</p>
        ) : results.length === 0 ? (
          <p className='rounded-box bg-base-200 px-4 py-8 text-center text-sm text-base-content/70'>条件に一致する販売中の商品はありません。</p>
        ) : (
          <ul className='grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-4 xl:grid-cols-6'>
            {results.map((item) => (
              <li key={item.id} className='min-w-0'>
                <ProductCrawlResultCard productCrawlResult={item} disabled={busy} onExclude={exclude} />
              </li>
            ))}
          </ul>
        )}
      </section>

      {daily === null ? (
        <section className='rounded-box bg-base-200 p-4' aria-label='商品相場'>
          <h2 className='text-lg font-semibold'>商品相場</h2>
          <p role='alert' className='mt-3 text-sm text-error'>商品相場を取得できませんでした。再読み込みしてください。</p>
        </section>
      ) : (
        <ProductAggregationResultsSection
          productAggregationSetting={setting}
          productAggregationResults={daily}
          productAggregationPurchases={purchases}
        />
      )}
      {editing && <ProductWatchSettingFormModal setting={setting} onClose={() => setEditing(false)} />}
    </div>
  )
}
