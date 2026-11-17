'use client'

import { useRef, useState } from 'react'

import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { toast } from 'react-toastify'

import SettingRowMenu from '@/components/ui/SettingRowMenu'
import { destroyCrawlSetting } from '@/features/product-monitoring/api/actions'
import type {
  CrawlResult,
  CrawlSetting,
  CrawlSettingInput,
} from '@/features/product-monitoring/api/types'
import CrawlSettingFormModal from '@/features/product-monitoring/components/CrawlSettingFormModal'

import { useCrawlResultActions } from '../hooks/useCrawlResultActions'

import CrawlResultCard from './CrawlResultCard'

const PREVIEW_COUNT = 8
const COPY_SUFFIX = '（コピー）'
// 初期値には入力欄の maxLength が効かないため、name 列の上限 255 文字に収める
const copyName = (name: string) => `${name.slice(0, 255 - COPY_SUFFIX.length)}${COPY_SUFFIX}`

interface Props {
  crawlSetting: CrawlSetting
  crawlResults: CrawlResult[]
}

// 一覧では新着の数件だけを横に並べ、除外はここでもできる。全件・絞り込み・取得は詳細画面に任せる
export default function CrawlSettingSection({
  crawlSetting,
  crawlResults,
}: Props) {
  const href = `/product-monitoring/crawl-settings/${crawlSetting.id}`
  const { busy, exclude, remove } = useCrawlResultActions()
  const router = useRouter()
  const [modal, setModal] = useState<{
    setting?: CrawlSetting
    initial?: CrawlSettingInput
  } | null>(null)
  const [deleting, setDeleting] = useState(false)
  const deletingRef = useRef(false)

  const destroy = async () => {
    if (
      deletingRef.current ||
      !window.confirm(`収集設定「${crawlSetting.name}」を削除しますか？`)
    )
      return
    deletingRef.current = true
    setDeleting(true)
    try {
      const result = await destroyCrawlSetting(crawlSetting.id)
      if (result.status !== 200) {
        toast.error('収集設定の削除に失敗しました')
        return
      }
      toast.success('収集設定を削除しました')
      router.refresh()
    } catch {
      toast.error('収集設定の削除に失敗しました')
    } finally {
      deletingRef.current = false
      setDeleting(false)
    }
  }

  return (
    <section className='space-y-3' aria-label={crawlSetting.name}>
      <div className='flex flex-wrap items-end justify-between gap-2'>
        <div>
          <h3 className='text-lg font-semibold leading-tight'>
            <Link className='link-hover' href={href}>
              {crawlSetting.name}
            </Link>
          </h3>
        </div>
        <div className='flex gap-1'>
          <SettingRowMenu
            name={crawlSetting.name}
            deleting={deleting}
            onEdit={() => setModal({ setting: crawlSetting })}
            onDuplicate={() =>
              setModal({
                initial: {
                  ...crawlSetting,
                  name: copyName(crawlSetting.name),
                },
              })
            }
            onDestroy={destroy}
          />
        </div>
      </div>
      {crawlResults.length === 0 ? (
        <p className='text-sm opacity-70'>収集結果はありません。</p>
      ) : (
        <ul className='flex snap-x gap-3 overflow-x-auto pb-2'>
          {crawlResults.slice(0, PREVIEW_COUNT).map((item) => (
            <li key={item.id} className='w-40 shrink-0 snap-start sm:w-44'>
              <CrawlResultCard
                crawlResult={item}
                disabled={busy}
                onExclude={exclude}
                onDelete={remove}
              />
            </li>
          ))}
        </ul>
      )}
      {modal && (
        <CrawlSettingFormModal
          setting={modal.setting}
          initial={modal.initial}
          onClose={() => setModal(null)}
        />
      )}
    </section>
  )
}
