'use client'

import { useRef, useState } from 'react'

import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { toast } from 'react-toastify'

import SettingRowMenu from '@/components/ui/SettingRowMenu'
import { destroyProductCrawlSetting } from '@/features/product-monitoring/api/actions'
import type {
  ProductCrawlResult,
  ProductCrawlSetting,
  ProductCrawlSettingInput,
} from '@/features/product-monitoring/api/types'
import ProductCrawlSettingFormModal from '@/features/product-monitoring/components/ProductCrawlSettingFormModal'

import { useProductCrawlResultActions } from '../hooks/useProductCrawlResultActions'

import ProductCrawlResultCard from './ProductCrawlResultCard'

const PREVIEW_COUNT = 8
const COPY_SUFFIX = '（コピー）'
// 初期値には入力欄の maxLength が効かないため、name 列の上限 255 文字に収める
const copyName = (name: string) => `${name.slice(0, 255 - COPY_SUFFIX.length)}${COPY_SUFFIX}`

interface Props {
  productCrawlSetting: ProductCrawlSetting
  productCrawlResults: ProductCrawlResult[]
}

// 一覧では新着の数件だけを横に並べ、除外はここでもできる。全件・絞り込み・取得は詳細画面に任せる
export default function ProductCrawlResultsSection({
  productCrawlSetting,
  productCrawlResults,
}: Props) {
  const href = `/product-crawl-results/${productCrawlSetting.id}`
  const { busy, exclude, remove } = useProductCrawlResultActions()
  const router = useRouter()
  const [modal, setModal] = useState<{
    setting?: ProductCrawlSetting
    initial?: ProductCrawlSettingInput
  } | null>(null)
  const [deleting, setDeleting] = useState(false)
  const deletingRef = useRef(false)

  const destroy = async () => {
    if (
      deletingRef.current ||
      !window.confirm(`商品計測設定「${productCrawlSetting.name}」を削除しますか？`)
    )
      return
    deletingRef.current = true
    setDeleting(true)
    try {
      const result = await destroyProductCrawlSetting(productCrawlSetting.id)
      if (result.status !== 200) {
        toast.error('商品計測設定の削除に失敗しました')
        return
      }
      toast.success('商品計測設定を削除しました')
      router.refresh()
    } catch {
      toast.error('商品計測設定の削除に失敗しました')
    } finally {
      deletingRef.current = false
      setDeleting(false)
    }
  }

  return (
    <section className='space-y-3' aria-label={productCrawlSetting.name}>
      <div className='flex flex-wrap items-end justify-between gap-2'>
        <div>
          <h3 className='text-lg font-semibold leading-tight'>
            <Link className='link-hover' href={href}>
              {productCrawlSetting.name}
            </Link>
          </h3>
        </div>
        <div className='flex gap-1'>
          <SettingRowMenu
            name={productCrawlSetting.name}
            deleting={deleting}
            onEdit={() => setModal({ setting: productCrawlSetting })}
            onDuplicate={() =>
              setModal({
                initial: {
                  ...productCrawlSetting,
                  name: copyName(productCrawlSetting.name),
                },
              })
            }
            onDestroy={destroy}
          />
        </div>
      </div>
      {productCrawlResults.length === 0 ? (
        <p className='text-sm opacity-70'>商品計測結果はありません。</p>
      ) : (
        <ul className='flex snap-x gap-3 overflow-x-auto pb-2'>
          {productCrawlResults.slice(0, PREVIEW_COUNT).map((item) => (
            <li key={item.id} className='w-40 shrink-0 snap-start sm:w-44'>
              <ProductCrawlResultCard
                productCrawlResult={item}
                disabled={busy}
                onExclude={exclude}
                onDelete={remove}
              />
            </li>
          ))}
        </ul>
      )}
      {modal && (
        <ProductCrawlSettingFormModal
          setting={modal.setting}
          initial={modal.initial}
          onClose={() => setModal(null)}
        />
      )}
    </section>
  )
}
