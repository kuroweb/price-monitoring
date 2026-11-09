'use client'

import { useRef, useState } from 'react'

import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { toast } from 'react-toastify'

import SettingRowMenu from '@/components/ui/SettingRowMenu'
import { destroyProductWatchSetting } from '@/features/product-monitoring/api/actions'
import type { ProductAggregationResult, ProductCrawlResult, ProductWatchSetting, ProductWatchSettingInput } from '@/features/product-monitoring/api/types'
import ProductCrawlResultCard from '@/features/product-monitoring/components/ProductCrawlResultCard'
import ProductWatchSettingFormModal from '@/features/product-monitoring/components/ProductWatchSettingFormModal'
import { useProductCrawlResultActions } from '@/features/product-monitoring/hooks/useProductCrawlResultActions'
import { formatYen } from '@/lib/format'

type Section = { setting: ProductWatchSetting; results: ProductCrawlResult[] | null; daily: ProductAggregationResult[] | null }
type Props = { sections: Section[] }
const COPY_SUFFIX = '（コピー）'

function WatchSection({ setting, results, daily }: Section) {
  const router = useRouter()
  const [modal, setModal] = useState<{ setting?: ProductWatchSetting; initial?: ProductWatchSettingInput } | null>(null)
  const [deleting, setDeleting] = useState(false)
  const deletingRef = useRef(false)
  const { busy, exclude, remove } = useProductCrawlResultActions()
  const latest = daily?.filter((item) => item.averagePurchasePrice != null).at(-1)

  const destroy = async () => {
    if (deletingRef.current || !window.confirm(`商品モニタリング設定「${setting.name}」を削除しますか？`)) return
    deletingRef.current = true
    setDeleting(true)
    try {
      const result = await destroyProductWatchSetting(setting.id)
      if (result.status !== 200) {
        toast.error('商品モニタリング設定の削除に失敗しました')
        return
      }
      toast.success('商品モニタリング設定を削除しました')
      router.refresh()
    } catch {
      toast.error('商品モニタリング設定の削除に失敗しました')
    } finally {
      deletingRef.current = false
      setDeleting(false)
    }
  }

  return (
    <section className='min-w-0 space-y-3' aria-label={setting.name}>
      <div className='flex flex-wrap items-end justify-between gap-2'>
        <div className='min-w-0'>
          <h3 className='break-words text-lg font-semibold leading-tight'>
            <Link className='link-hover' href={`/product-monitoring/${setting.id}`}>
              {setting.name}
            </Link>
          </h3>
        </div>
        <SettingRowMenu name={setting.name} deleting={deleting} onEdit={() => setModal({ setting })}
          onDuplicate={() => setModal({ initial: { ...setting, name: `${setting.name.slice(0, 255 - COPY_SUFFIX.length)}${COPY_SUFFIX}` } })}
          onDestroy={destroy} />
      </div>
      <dl className='grid grid-cols-2 gap-4'>
        <div>
          <dt className='text-xs opacity-60'>販売中の最安値</dt>
          <dd className='mt-1 text-xl font-semibold tabular-nums'>
            {results === null ? '取得失敗' : results.length ? formatYen(results[0].price) : '—'}
          </dd>
          {(results === null || results.length === 0) && (
            <p className='mt-1 text-xs opacity-55'>{results === null ? '再読み込みしてください' : '該当する出品なし'}</p>
          )}
        </div>
        <div>
          <dt className='text-xs opacity-60'>直近の平均購入価格</dt>
          <dd className='mt-1 text-xl font-semibold tabular-nums'>
            {daily === null ? '取得失敗' : latest ? formatYen(latest.averagePurchasePrice!) : '—'}
          </dd>
          {!latest && <p className='mt-1 text-xs opacity-55'>{daily === null ? '再読み込みしてください' : '集計データなし'}</p>}
        </div>
      </dl>
      {results && results.length > 0 && (
        <div className='min-w-0'>
          <ol aria-label='販売中の商品を価格順に表示' className='flex w-full snap-x gap-3 overflow-x-auto pb-2'>
            {results.map((item) => (
              <li key={item.id} className='w-40 shrink-0 snap-start sm:w-44'>
                <ProductCrawlResultCard productCrawlResult={item} disabled={busy} onExclude={exclude} onDelete={remove} />
              </li>
            ))}
          </ol>
        </div>
      )}
      {modal && <ProductWatchSettingFormModal setting={modal.setting} initial={modal.initial} onClose={() => setModal(null)} />}
    </section>
  )
}

export default function ProductWatchSettings({ sections }: Props) {
  const [adding, setAdding] = useState(false)
  return (
    <>
      <div className='flex flex-wrap items-center justify-between gap-2'>
        <h2 className='card-title'>商品モニタリング</h2>
        <button type='button' className='btn' onClick={() => setAdding(true)}>商品モニタリング設定を追加</button>
      </div>
      {sections.length === 0 ? (
        <p className='pt-4'>商品モニタリング設定はまだありません。</p>
      ) : (
        <div className='divide-y divide-base-200 pt-4 [&>section]:py-5 [&>section:first-child]:pt-0'>
          {sections.map((section) => <WatchSection key={section.setting.id} {...section} />)}
        </div>
      )}
      {adding && <ProductWatchSettingFormModal onClose={() => setAdding(false)} />}
    </>
  )
}
