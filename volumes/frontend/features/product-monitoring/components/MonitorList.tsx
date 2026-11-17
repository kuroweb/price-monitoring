'use client'

import { useRef, useState } from 'react'

import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { toast } from 'react-toastify'

import SettingRowMenu from '@/components/ui/SettingRowMenu'
import { destroyMonitor } from '@/features/product-monitoring/api/actions'
import type { DailyMarketPrice, CrawlResult, Monitor, MonitorInput } from '@/features/product-monitoring/api/types'
import CrawlResultCard from '@/features/product-monitoring/components/CrawlResultCard'
import MonitorFormModal from '@/features/product-monitoring/components/MonitorFormModal'
import { useCrawlResultActions } from '@/features/product-monitoring/hooks/useCrawlResultActions'
import { formatYen } from '@/lib/format'

type Section = { monitor: Monitor; crawlResults: CrawlResult[] | null; dailyMarketPrices: DailyMarketPrice[] | null }
type Props = { sections: Section[] }
const COPY_SUFFIX = '（コピー）'

function WatchSection({ monitor, crawlResults, dailyMarketPrices }: Section) {
  const router = useRouter()
  const [modal, setModal] = useState<{ monitor?: Monitor; initial?: MonitorInput } | null>(null)
  const [deleting, setDeleting] = useState(false)
  const deletingRef = useRef(false)
  const { busy, exclude, remove } = useCrawlResultActions()
  const latest = dailyMarketPrices?.filter((item) => item.averageTransactionPrice != null).at(-1)

  const destroy = async () => {
    if (deletingRef.current || !window.confirm(`モニタリング設定「${monitor.name}」を削除しますか？`)) return
    deletingRef.current = true
    setDeleting(true)
    try {
      const result = await destroyMonitor(monitor.id)
      if (result.status !== 200) {
        toast.error('モニタリング設定の削除に失敗しました')
        return
      }
      toast.success('モニタリング設定を削除しました')
      router.refresh()
    } catch {
      toast.error('モニタリング設定の削除に失敗しました')
    } finally {
      deletingRef.current = false
      setDeleting(false)
    }
  }

  return (
    <section className='min-w-0 space-y-3' aria-label={monitor.name}>
      <div className='flex flex-wrap items-end justify-between gap-2'>
        <div className='min-w-0'>
          <h3 className='break-words text-lg font-semibold leading-tight'>
            <Link className='link-hover' href={`/product-monitoring/monitors/${monitor.id}`}>
              {monitor.name}
            </Link>
          </h3>
        </div>
        <SettingRowMenu name={monitor.name} deleting={deleting} onEdit={() => setModal({ monitor })}
          onDuplicate={() => setModal({ initial: { ...monitor, name: `${monitor.name.slice(0, 255 - COPY_SUFFIX.length)}${COPY_SUFFIX}` } })}
          onDestroy={destroy} />
      </div>
      <dl className='grid grid-cols-2 gap-4'>
        <div>
          <dt className='text-xs opacity-60'>販売中の最安値</dt>
          <dd className='mt-1 text-xl font-semibold tabular-nums'>
            {crawlResults === null ? '取得失敗' : crawlResults.length ? formatYen(crawlResults[0].price) : '—'}
          </dd>
          {(crawlResults === null || crawlResults.length === 0) && (
            <p className='mt-1 text-xs opacity-55'>{crawlResults === null ? '再読み込みしてください' : '該当する収集結果なし'}</p>
          )}
        </div>
        <div>
          <dt className='text-xs opacity-60'>直近の平均取引価格</dt>
          <dd className='mt-1 text-xl font-semibold tabular-nums'>
            {dailyMarketPrices === null ? '取得失敗' : latest ? formatYen(latest.averageTransactionPrice!) : '—'}
          </dd>
          {!latest && <p className='mt-1 text-xs opacity-55'>{dailyMarketPrices === null ? '再読み込みしてください' : '集計データなし'}</p>}
        </div>
      </dl>
      {crawlResults && crawlResults.length > 0 && (
        <div className='min-w-0'>
          <ol aria-label='販売中の収集結果を価格順に表示' className='flex w-full snap-x gap-3 overflow-x-auto pb-2'>
            {crawlResults.map((item) => (
              <li key={item.id} className='w-40 shrink-0 snap-start sm:w-44'>
                <CrawlResultCard crawlResult={item} disabled={busy} onExclude={exclude} onDelete={remove} />
              </li>
            ))}
          </ol>
        </div>
      )}
      {modal && <MonitorFormModal monitor={modal.monitor} initial={modal.initial} onClose={() => setModal(null)} />}
    </section>
  )
}

export default function MonitorList({ sections }: Props) {
  const [adding, setAdding] = useState(false)
  return (
    <>
      <div className='flex flex-wrap items-center justify-between gap-2'>
        <h2 className='card-title'>モニタリング設定</h2>
        <button type='button' className='btn' onClick={() => setAdding(true)}>モニタリング設定を追加</button>
      </div>
      {sections.length === 0 ? (
        <p className='pt-4'>モニタリング設定はまだありません。</p>
      ) : (
        <div className='divide-y divide-base-200 pt-4 [&>section]:py-5 [&>section:first-child]:pt-0'>
          {sections.map((section) => <WatchSection key={section.monitor.id} {...section} />)}
        </div>
      )}
      {adding && <MonitorFormModal onClose={() => setAdding(false)} />}
    </>
  )
}
