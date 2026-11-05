'use client'

import { useRef, useState } from 'react'

import { useRouter } from 'next/navigation'
import { toast } from 'react-toastify'

import { excludeProductCrawlResult, syncProductCrawlSetting } from '@/lib/actions'
import type { ProductCrawlResult, ProductCrawlSetting } from '@/lib/api'

import { platformName } from '../lib/platform'

const soldName = (sold: boolean | null) => (sold == null ? '不明' : sold ? '売り切れ' : '販売中')
const dateTime = (value: string | null) => (value ? new Date(value).toLocaleString('ja-JP') : '-')

interface Props {
  productCrawlSetting: ProductCrawlSetting
  productCrawlResults: ProductCrawlResult[]
}

export default function ProductCrawlResults({ productCrawlSetting, productCrawlResults }: Props) {
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
    <div className='space-y-4'>
      <div className='flex flex-wrap items-center justify-between gap-2'>
        <p>{productCrawlResults.length}件</p>
        <button type='button' className='btn btn-primary' disabled={busy} onClick={sync}>
          取得して保存
        </button>
      </div>
      {busy && <p role='status'>処理中です。取得には時間がかかることがあります。</p>}
      {productCrawlResults.length === 0 ? (
        <p>商品計測結果はありません。</p>
      ) : (
        <div className='overflow-x-auto'>
          <table className='table min-w-[720px]'>
            <thead>
              <tr>
                <th>サイト</th>
                <th>出品名</th>
                <th>価格</th>
                <th>販売状態</th>
                <th>売れた日時</th>
                <th>終了日時</th>
                <th>操作</th>
              </tr>
            </thead>
            <tbody>
              {productCrawlResults.map((item) => (
                <tr key={item.id}>
                  <td>{platformName(item.platform)}</td>
                  <td>
                    <a className='link' href={item.productUrl} target='_blank' rel='noreferrer'>
                      {item.name}
                    </a>
                  </td>
                  <td>
                    {item.price.toLocaleString()}円
                    {item.buyoutPrice != null && ` / 即決 ${item.buyoutPrice.toLocaleString()}円`}
                  </td>
                  <td>{soldName(item.sold)}</td>
                  <td>{dateTime(item.boughtDate)}</td>
                  <td>{dateTime(item.endDate)}</td>
                  <td>
                    <button
                      type='button'
                      className='btn btn-sm'
                      disabled={busy}
                      onClick={() => exclude(item)}
                    >
                      除外
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  )
}
