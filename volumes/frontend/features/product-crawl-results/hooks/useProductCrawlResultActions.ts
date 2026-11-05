'use client'

import { useRef, useState } from 'react'

import { useRouter } from 'next/navigation'
import { toast } from 'react-toastify'

import { setProductCrawlResultExcluded, syncProductCrawlSetting } from '@/lib/actions'
import type { ProductCrawlResult, ProductCrawlSetting } from '@/lib/api'

// 一覧と詳細で共有する「取得して保存」と「除外」。どちらかの実行中は二重に実行しない
export const useProductCrawlResultActions = (productCrawlSetting: ProductCrawlSetting) => {
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
      const result = await setProductCrawlResultExcluded(item.id, true)
      if (!result.data) {
        toast.error('除外に失敗しました')
        return false
      }
      return true
    })

  return { busy, sync, exclude }
}
