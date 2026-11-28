'use client'

import { useRef, useState } from 'react'
import type { FormEvent } from 'react'

import { useRouter } from 'next/navigation'
import { toast } from 'react-toastify'

import { createExcludedSeller, destroyExcludedSeller } from '@/features/product-monitoring/api/actions'
import type { ExcludedSeller } from '@/features/product-monitoring/api/types'
import { platformName } from '@/features/product-monitoring/lib/platform'

// 選択肢を出すだけで、対象サイトかどうかの判定はバックエンドが行う
const PLATFORMS = ['mercari', 'yahoo_fleamarket', 'yahoo_auction']

interface Props {
  excludedSellers: ExcludedSeller[]
}

export default function ExcludedSellerList({ excludedSellers }: Props) {
  const router = useRouter()
  const [platform, setPlatform] = useState(PLATFORMS[0])
  const [sellerId, setSellerId] = useState('')
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

  const submit = (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault()
    return perform(async () => {
      const result = await createExcludedSeller({ platform, sellerId: sellerId.trim() })
      if (!result.data) {
        toast.error(result.status === 409 ? 'この出品者は登録済みです' : (result.error?.message ?? '登録に失敗しました'))
        return false
      }
      setSellerId('')
      toast.success('出品者を除外しました')
      return true
    })
  }

  const release = (seller: ExcludedSeller) =>
    perform(async () => {
      if (!window.confirm(`${platformName(seller.platform)}の出品者「${seller.sellerId}」の除外を解除しますか？`)) return false
      const result = await destroyExcludedSeller(seller.id)
      if (result.status !== 200) {
        toast.error('解除に失敗しました')
        return false
      }
      toast.success('除外を解除しました')
      return true
    })

  return (
    <div className='space-y-4'>
      <p className='text-sm opacity-80'>
        サイトの出品者IDと完全に一致する出品を、表示・通知・集計から外します。出品者IDが分からない出品は外れません。
      </p>
      <form className='flex flex-wrap items-end gap-2' onSubmit={submit}>
        <label className='form-control'>
          <span className='label-text pb-1'>サイト</span>
          <select
            className='select select-bordered'
            value={platform}
            disabled={busy}
            onChange={(event) => setPlatform(event.target.value)}
          >
            {PLATFORMS.map((value) => (
              <option key={value} value={value}>
                {platformName(value)}
              </option>
            ))}
          </select>
        </label>
        <label className='form-control min-w-0 flex-1'>
          <span className='label-text pb-1'>出品者ID</span>
          <input
            className='input input-bordered w-full'
            value={sellerId}
            disabled={busy}
            maxLength={255}
            required
            onChange={(event) => setSellerId(event.target.value)}
          />
        </label>
        <button type='submit' className='btn btn-primary' disabled={busy || sellerId.trim() === ''}>
          登録
        </button>
      </form>
      {excludedSellers.length === 0 ? (
        <div>除外する出品者はまだありません。</div>
      ) : (
        <div className='overflow-x-auto'>
          <table className='table'>
            <thead>
              <tr>
                <th>サイト</th>
                <th>出品者ID</th>
                <th>操作</th>
              </tr>
            </thead>
            <tbody>
              {excludedSellers.map((seller) => (
                <tr key={seller.id}>
                  <td className='whitespace-nowrap'>{platformName(seller.platform)}</td>
                  <td className='break-all'>{seller.sellerId}</td>
                  <td className='w-1/12'>
                    <button
                      type='button'
                      className='btn btn-ghost btn-sm'
                      disabled={busy}
                      aria-label={`${platformName(seller.platform)}の出品者「${seller.sellerId}」の除外を解除する`}
                      onClick={() => release(seller)}
                    >
                      解除
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
