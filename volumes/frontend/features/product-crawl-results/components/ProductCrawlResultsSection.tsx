'use client'

import { useRef, useState } from 'react'

import { useRouter } from 'next/navigation'
import { toast } from 'react-toastify'

import { excludeProductCrawlResult, syncProductCrawlSetting } from '@/lib/actions'
import type { ProductCrawlResult, ProductCrawlSetting } from '@/lib/api'

import ProductCrawlResultCard from './ProductCrawlResultCard'

interface Props {
  productCrawlSetting: ProductCrawlSetting
  productCrawlResults: ProductCrawlResult[]
}

export default function ProductCrawlResultsSection({
  productCrawlSetting,
  productCrawlResults,
}: Props) {
  const router = useRouter()
  const [busy, setBusy] = useState(false)
  const inFlightRef = useRef(false)
  const perform = async (action: () => Promise<boolean>) => {
    if (inFlightRef.current) return
    inFlightRef.current = true
    setBusy(true)
    try {
      if (await action()) router.refresh()
    } catch {
      toast.error('通信に失敗しました')
    } finally {
      inFlightRef.current = false
      setBusy(false)
    }
  }
  const sync = () =>
    perform(async () => {
      const result = await syncProductCrawlSetting(productCrawlSetting.id)
      if (!result.data) {
        toast.error(result.error?.message ?? '取得に失敗しました')
        return false
      }
      const failed = result.data.sources.filter((source) => source.status !== 'succeeded').length
      toast.success(`取得して保存しました（採用 ${result.data.acceptedCount}件）`)
      if (failed > 0) toast.error(`${failed}件のURLを取得できませんでした`)
      return true
    })
  const exclude = (item: ProductCrawlResult) =>
    perform(async () => {
      if (!window.confirm(`「${item.name}」を除外しますか？`)) return false
      const result = await excludeProductCrawlResult(productCrawlSetting.id, item.externalId)
      if (!result.data) {
        toast.error('除外に失敗しました')
        return false
      }
      return true
    })

  return (
    <section className='space-y-3' aria-label={productCrawlSetting.name}>
      <div className='flex flex-wrap items-center justify-between gap-2'>
        <h3 className='text-lg font-semibold leading-tight'>
          {productCrawlSetting.name}（{productCrawlResults.length}件）
        </h3>
        <button type='button' className='btn btn-sm btn-primary' disabled={busy} onClick={sync}>
          {busy ? '処理中…' : '取得して保存'}
        </button>
      </div>
      {productCrawlResults.length === 0 ? (
        <p>商品計測結果はありません。「取得して保存」で取得してください。</p>
      ) : (
        <div className='grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-4 xl:grid-cols-6'>
          {productCrawlResults.map((item) => (
            <ProductCrawlResultCard
              key={item.id}
              productCrawlResult={item}
              disabled={busy}
              onExclude={exclude}
            />
          ))}
        </div>
      )}
    </section>
  )
}
