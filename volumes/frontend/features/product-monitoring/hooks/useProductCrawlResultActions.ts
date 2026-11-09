'use client'

import { useRef, useState } from 'react'

import { useRouter } from 'next/navigation'
import { toast } from 'react-toastify'

import { destroyProductCrawlResult, setProductCrawlResultExcluded, syncProductCrawlSetting } from '@/features/product-monitoring/api/actions'
import type { ProductCrawlResult } from '@/features/product-monitoring/api/types'

// 一覧と詳細で共有する「取得して保存」と「除外」。どちらかの実行中は二重に実行しない
export const useProductCrawlResultActions = () => {
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
  const sync = (productCrawlSettingId: number) =>
    perform(async () => {
      const result = await syncProductCrawlSetting(productCrawlSettingId)
      if (!result.data) {
        toast.error(result.error?.message ?? '取得に失敗しました')
        return false
      }
      toast.success('取得を開始しました。しばらくしてから再読み込みしてください')
      return false
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

  const remove = (item: ProductCrawlResult) =>
    perform(async () => {
      if (!window.confirm(`「${item.name}」を削除しますか？再取得時に再登録されることがあります。`)) return false
      const result = await destroyProductCrawlResult(item.id)
      if (result.status !== 200) {
        toast.error('削除に失敗しました')
        return false
      }
      return true
    })

  return { busy, sync, exclude, remove }
}
