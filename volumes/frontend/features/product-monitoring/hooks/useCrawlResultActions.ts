'use client'

import { useRef, useState } from 'react'

import { useRouter } from 'next/navigation'
import { toast } from 'react-toastify'

import { destroyCrawlResult, setCrawlResultExcluded, syncCrawlSetting } from '@/features/product-monitoring/api/actions'
import type { CrawlResult } from '@/features/product-monitoring/api/types'

// 検索結果はクライアントの状態なので、呼び出し側は画面の再読み込みではなく検索のやり直しを onChanged に渡す
export const useCrawlResultActions = (onChanged?: () => Promise<void> | void) => {
  const router = useRouter()
  const [busy, setBusy] = useState(false)
  const inFlightRef = useRef(false)
  const perform = async (action: () => Promise<boolean>) => {
    if (inFlightRef.current) return
    inFlightRef.current = true
    setBusy(true)
    try {
      if (await action()) {
        if (onChanged) await onChanged()
        else router.refresh()
      }
    } catch {
      toast.error('通信に失敗しました')
    } finally {
      inFlightRef.current = false
      setBusy(false)
    }
  }
  const sync = (crawlSettingId: number) =>
    perform(async () => {
      const result = await syncCrawlSetting(crawlSettingId)
      if (!result.data) {
        toast.error(result.error?.message ?? '取得に失敗しました')
        return false
      }
      toast.success('取得を開始しました。しばらくしてから再読み込みしてください')
      return false
    })
  const exclude = (item: CrawlResult) =>
    perform(async () => {
      if (!window.confirm(`「${item.name}」を除外しますか？`)) return false
      const result = await setCrawlResultExcluded(item.id, true)
      if (!result.data) {
        toast.error('除外に失敗しました')
        return false
      }
      return true
    })

  const remove = (item: CrawlResult) =>
    perform(async () => {
      if (!window.confirm(`「${item.name}」を削除しますか？再取得時に再登録されることがあります。`)) return false
      const result = await destroyCrawlResult(item.id)
      if (result.status !== 200) {
        toast.error('削除に失敗しました')
        return false
      }
      return true
    })

  return { busy, sync, exclude, remove }
}
