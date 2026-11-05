'use client'

import { useRef, useState } from 'react'

import { useRouter } from 'next/navigation'
import { toast } from 'react-toastify'

import { calculateProductAggregationSetting } from '@/lib/actions'
import type { ProductAggregationResult, ProductAggregationSetting } from '@/lib/api'

interface Props {
  productAggregationSetting: ProductAggregationSetting
  productAggregationResults: ProductAggregationResult[]
}

export default function ProductAggregationResults({
  productAggregationSetting,
  productAggregationResults,
}: Props) {
  const router = useRouter()
  const [busy, setBusy] = useState(false)
  const inFlightRef = useRef(false)
  const calculate = async () => {
    if (inFlightRef.current) return
    inFlightRef.current = true
    setBusy(true)
    try {
      const result = await calculateProductAggregationSetting(productAggregationSetting.id)
      if (result.status !== 200) {
        toast.error('集計に失敗しました')
        return
      }
      toast.success('直近30日を集計しました')
      router.refresh()
    } catch {
      toast.error('通信に失敗しました')
    } finally {
      inFlightRef.current = false
      setBusy(false)
    }
  }

  return (
    <div className='space-y-4'>
      <div className='flex justify-end'>
        <button type='button' className='btn btn-primary' disabled={busy} onClick={calculate}>
          直近30日を集計
        </button>
      </div>
      {productAggregationResults.length === 0 ? (
        <p>商品日次相場はありません。</p>
      ) : (
        <div className='overflow-x-auto'>
          <table className='table'>
            <thead>
              <tr>
                <th>集計日</th>
                <th>平均購入価格</th>
                <th>購入件数</th>
              </tr>
            </thead>
            <tbody>
              {[...productAggregationResults].reverse().map((item) => (
                <tr key={item.id}>
                  <td>{item.date}</td>
                  <td>
                    {item.averagePurchasePrice == null
                      ? '-'
                      : `${item.averagePurchasePrice.toLocaleString()}円`}
                  </td>
                  <td>{item.purchaseCount}件</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  )
}
