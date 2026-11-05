'use client'

import { useRef, useState } from 'react'

import Link from 'next/link'

import { words } from '@/features/admin/product-crawl-settings/lib/platform'
import {
  createProductAggregationSetting,
  destroyProductAggregationSetting,
  updateProductAggregationSetting,
} from '@/lib/actions'
import type { ProductAggregationSetting, ProductAggregationSettingDraft } from '@/lib/api'

const empty = (): ProductAggregationSettingDraft => ({
  name: '',
  requiredKeywords: [],
  excludeKeywords: [],
  minPrice: null,
  maxPrice: null,
})

export default function ProductAggregationSettings({
  initial,
}: {
  initial: ProductAggregationSetting[]
}) {
  const [items, setItems] = useState(initial)
  const [draft, setDraft] = useState<ProductAggregationSettingDraft>(empty)
  const [editing, setEditing] = useState<number | null>(null)
  const [required, setRequired] = useState('')
  const [excluded, setExcluded] = useState('')
  const [error, setError] = useState('')
  const [notice, setNotice] = useState('')
  const [busy, setBusy] = useState(false)
  const inFlightRef = useRef(false)
  const change = (patch: Partial<ProductAggregationSettingDraft>) => {
    setDraft((value) => ({ ...value, ...patch }))
    setNotice('')
  }
  const reset = () => {
    setEditing(null)
    setDraft(empty())
    setRequired('')
    setExcluded('')
  }
  const perform = async (action: () => Promise<void>) => {
    if (inFlightRef.current) return
    inFlightRef.current = true
    setBusy(true)
    setError('')
    setNotice('')
    try {
      await action()
    } catch {
      setError('通信に失敗しました。時間をおいて再試行してください。')
    } finally {
      inFlightRef.current = false
      setBusy(false)
    }
  }
  const submit = () =>
    perform(async () => {
      if (!draft.name.trim()) {
        setError('名前を入力してください')
        return
      }
      if (draft.minPrice != null && draft.maxPrice != null && draft.minPrice > draft.maxPrice) {
        setError('最低価格は最高価格以下にしてください')
        return
      }
      const payload = {
        ...draft,
        requiredKeywords: words(required),
        excludeKeywords: words(excluded),
      }
      const result =
        editing === null
          ? await createProductAggregationSetting(payload)
          : await updateProductAggregationSetting(editing, payload)
      if (!result.data) {
        setError(result.error?.message ?? '保存に失敗しました')
        return
      }
      const saved = result.data
      setItems((values) =>
        editing === null
          ? [saved, ...values]
          : values.map((value) => (value.id === editing ? saved : value)),
      )
      reset()
      setNotice('商品相場設定を保存しました')
    })
  const destroy = (item: ProductAggregationSetting) =>
    perform(async () => {
      if (!window.confirm(`商品相場設定「${item.name}」を削除しますか？`)) return
      const result = await destroyProductAggregationSetting(item.id)
      if (result.status !== 200) {
        setError(result.error?.message ?? '削除に失敗しました')
        return
      }
      setItems((values) => values.filter((value) => value.id !== item.id))
      if (editing === item.id) reset()
    })

  return (
    <div className='space-y-6'>
      <p>全商品計測設定の商品計測結果をフィルターし、売れた出品の価格を日ごとに集計します。</p>
      <fieldset disabled={busy} className='space-y-2'>
        <legend className='font-semibold'>商品相場設定一覧</legend>
        {items.length === 0 && <p>商品相場設定はありません。</p>}
        {items.map((item) => (
          <div key={item.id} className='flex flex-wrap items-center gap-2 rounded border p-3'>
            <span className='min-w-0 flex-1'>{item.name}</span>
            <Link className='btn btn-sm' href={`/admin/product-aggregation-settings/${item.id}`}>
              商品相場
            </Link>
            <button
              type='button'
              className='btn btn-sm'
              onClick={() => {
                setEditing(item.id)
                setDraft(item)
                setRequired(item.requiredKeywords.join(', '))
                setExcluded(item.excludeKeywords.join(', '))
                setError('')
                setNotice('')
              }}
            >
              編集
            </button>
            <button type='button' className='btn btn-sm' onClick={() => destroy(item)}>
              削除
            </button>
          </div>
        ))}
        <button type='button' className='btn btn-sm' onClick={reset}>
          新しい商品相場設定
        </button>
      </fieldset>
      <fieldset disabled={busy} className='space-y-4 rounded border p-4'>
        <legend className='px-2 font-semibold'>
          {editing === null ? '商品相場設定の登録' : '商品相場設定の編集'}
        </legend>
        <label className='block'>
          名前
          <input
            className='input w-full'
            maxLength={255}
            value={draft.name}
            onChange={(event) => change({ name: event.target.value })}
          />
        </label>
        <label className='block'>
          必須語（すべて含む・カンマ/改行区切り）
          <textarea
            className='textarea w-full'
            value={required}
            onChange={(event) => setRequired(event.target.value)}
          />
        </label>
        <label className='block'>
          除外語（いずれかを含む・カンマ/改行区切り）
          <textarea
            className='textarea w-full'
            value={excluded}
            onChange={(event) => setExcluded(event.target.value)}
          />
        </label>
        <div className='grid gap-3 sm:grid-cols-2'>
          <label>
            最低価格（円）
            <input
              className='input w-full'
              type='number'
              min={0}
              step={1}
              value={draft.minPrice ?? ''}
              onChange={(event) =>
                change({ minPrice: event.target.value === '' ? null : Number(event.target.value) })
              }
            />
          </label>
          <label>
            最高価格（円）
            <input
              className='input w-full'
              type='number'
              min={0}
              step={1}
              value={draft.maxPrice ?? ''}
              onChange={(event) =>
                change({ maxPrice: event.target.value === '' ? null : Number(event.target.value) })
              }
            />
          </label>
        </div>
        <button type='button' className='btn btn-primary' onClick={submit}>
          保存
        </button>
      </fieldset>
      {error && (
        <p role='alert' className='text-error'>
          {error}
        </p>
      )}
      {notice && <p role='status'>{notice}</p>}
    </div>
  )
}
