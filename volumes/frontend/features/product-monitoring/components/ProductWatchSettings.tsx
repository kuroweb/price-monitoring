'use client'

import { useRef, useState } from 'react'

import { useRouter } from 'next/navigation'
import { toast } from 'react-toastify'

import SettingRowMenu from '@/components/ui/SettingRowMenu'
import { destroyProductWatchSetting } from '@/features/product-monitoring/api/actions'
import type {
  ProductCrawlResult,
  ProductWatchSetting,
  ProductWatchSettingInput,
} from '@/features/product-monitoring/api/types'
import ProductCrawlResultCard from '@/features/product-monitoring/components/ProductCrawlResultCard'
import ProductWatchSettingFormModal from '@/features/product-monitoring/components/ProductWatchSettingFormModal'
import { formatYen } from '@/lib/format'

type Section = { setting: ProductWatchSetting; results: ProductCrawlResult[] | null }
type Props = { sections: Section[] }
const COPY_SUFFIX = '（コピー）'

function WatchSection({
  setting,
  results,
}: Section) {
  const router = useRouter()
  const [modal, setModal] = useState<{ setting?: ProductWatchSetting; initial?: ProductWatchSettingInput } | null>(null)
  const [deleting, setDeleting] = useState(false)
  const deletingRef = useRef(false)

  const destroy = async () => {
    if (
      deletingRef.current ||
      !window.confirm(`商品モニタリング設定「${setting.name}」を削除しますか？`)
    )
      return
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
    <section className='space-y-3 rounded-box bg-base-200 p-4' aria-label={setting.name}>
      <div className='flex flex-wrap items-start justify-between gap-3'>
        <div className='space-y-2'>
          <h3 className='text-lg font-semibold'>{setting.name}</h3>
          <p className='text-sm opacity-70'>{setting.enabled ? '有効' : '無効'}</p>
          <div className='flex flex-wrap gap-1'>
            {setting.requiredKeywords.map((word) => (
              <span key={`required-${word}`} className='badge badge-sm badge-outline'>
                必須: {word}
              </span>
            ))}
            {setting.excludeKeywords.map((word) => (
              <span key={`excluded-${word}`} className='badge badge-sm badge-outline'>
                除外: {word}
              </span>
            ))}
            {(setting.minPrice != null || setting.maxPrice != null) && (
              <span className='badge badge-sm badge-outline'>
                {setting.minPrice != null ? formatYen(setting.minPrice) : ''}〜
                {setting.maxPrice != null ? formatYen(setting.maxPrice) : ''}
              </span>
            )}
          </div>
        </div>
        <SettingRowMenu
          name={setting.name}
          deleting={deleting}
          onEdit={() => setModal({ setting })}
          onDuplicate={() => setModal({ initial: { ...setting, name: `${setting.name.slice(0, 255 - COPY_SUFFIX.length)}${COPY_SUFFIX}` } })}
          onDestroy={destroy}
        />
      </div>
      <h4 className='font-semibold'>価格の安い商品（最大8件）</h4>
      {results === null ? (
        <p className='text-sm'>商品を取得できませんでした。再読み込みしてください。</p>
      ) : results.length === 0 ? (
        <p className='text-sm'>条件に一致する販売中の商品はありません。</p>
      ) : (
        <ul className='flex snap-x gap-3 overflow-x-auto pb-2'>
          {results.map((item) => (
            <li key={item.id} className='w-40 shrink-0 snap-start sm:w-44'>
              <ProductCrawlResultCard productCrawlResult={item} />
            </li>
          ))}
        </ul>
      )}
      {modal && (
        <ProductWatchSettingFormModal
          setting={modal.setting}
          initial={modal.initial}
          onClose={() => setModal(null)}
        />
      )}
    </section>
  )
}

export default function ProductWatchSettings({ sections }: Props) {
  const [adding, setAdding] = useState(false)
  return (
    <>
      <div className='flex flex-wrap items-center justify-between gap-2'>
        <h2 className='card-title'>商品モニタリング</h2>
        <button type='button' className='btn' onClick={() => setAdding(true)}>
          商品モニタリング設定を追加
        </button>
      </div>
      <div className='space-y-4 pt-4'>
        {sections.length === 0 && <p>商品モニタリング設定はまだありません。</p>}
        {sections.map((section) => (
          <WatchSection
            key={section.setting.id}
            {...section}
          />
        ))}
      </div>
      {adding && (
        <ProductWatchSettingFormModal
          onClose={() => setAdding(false)}
        />
      )}
    </>
  )
}
