'use client'

import { useRef, useState } from 'react'

import {
  createProductSearchSetting,
  deleteProductSearchSetting,
  previewProductSearchSetting,
  updateProductSearchSetting,
} from '@/lib/actions'
import type { ProductSearchSetting, ProductSearchDraft, ProductSearchPreview } from '@/lib/api'

const empty = (): ProductSearchDraft => ({
  name: '',
  enabled: true,
  minPrice: null,
  maxPrice: null,
  requiredKeywords: [],
  excludeKeywords: [],
  excludedListings: [],
  urls: [{ url: '', enabled: true }],
})
const words = (value: string) => [
  ...new Set(
    value
      .split(/[\n,、]/)
      .map((word) => word.trim())
      .filter(Boolean),
  ),
]
const statusNames = {
  succeeded: '取得成功',
  failed: '取得失敗',
  unsupported: '非対応URL',
  disabled: '停止',
}
const reasonNames: Record<string, string> = {
  below_min_price: '最低価格未満・価格不明',
  above_max_price: '最高価格超過・価格不明',
  missing_required_keyword: '必須語に不一致',
  excluded_keyword: '除外語に一致',
  excluded_listing: '個別出品除外',
}

export default function ProductSearchSettings({ initial }: { initial: ProductSearchSetting[] }) {
  const [items, setItems] = useState(initial)
  const [draft, setDraft] = useState<ProductSearchDraft>(empty)
  const [editing, setEditing] = useState<number | null>(null)
  const [required, setRequired] = useState('')
  const [excluded, setExcluded] = useState('')
  const [rowKeys, setRowKeys] = useState([0])
  const nextKeyRef = useRef(1)
  const [preview, setPreview] = useState<ProductSearchPreview | null>(null)
  const [error, setError] = useState('')
  const [notice, setNotice] = useState('')
  const [busy, setBusy] = useState(false)
  const inFlightRef = useRef(false)
  const change = (patch: Partial<ProductSearchDraft>) => {
    setDraft((value) => ({ ...value, ...patch }))
    setPreview(null)
    setNotice('')
  }
  const payload = () => ({
    ...draft,
    requiredKeywords: words(required),
    excludeKeywords: words(excluded),
  })
  const reset = () => {
    setEditing(null)
    setDraft(empty())
    setRequired('')
    setExcluded('')
    setRowKeys([nextKeyRef.current++])
    setPreview(null)
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
  const valid = () => {
    if (draft.urls.length === 0 || draft.urls.some((row) => !row.url.trim())) {
      setError('取得URLを1〜5件入力してください')
      return false
    }
    if (
      [draft.minPrice, draft.maxPrice].some(
        (price) => price != null && (!Number.isSafeInteger(price) || price < 0),
      ) ||
      (draft.minPrice != null && draft.maxPrice != null && draft.minPrice > draft.maxPrice)
    ) {
      setError('価格は0以上の整数で、最低価格は最高価格以下にしてください')
      return false
    }
    return true
  }
  const submit = () =>
    perform(async () => {
      if (!valid()) return
      if (!draft.name.trim()) {
        setError('名前を入力してください')
        return
      }
      const result =
        editing === null
          ? await createProductSearchSetting(payload())
          : await updateProductSearchSetting(editing, payload())
      if (!result.data) {
        setError(result.error?.message ?? '保存に失敗しました')
        return
      }
      const saved = result.data
      setItems((values) =>
        editing === null
          ? [...values, saved]
          : values.map((value) => (value.id === editing ? saved : value)),
      )
      reset()
      setNotice('計測設定を保存しました。取得は手動プレビューで実行します。')
    })
  const runPreview = () =>
    perform(async () => {
      if (!valid()) return
      setPreview(null)
      const result = await previewProductSearchSetting(payload())
      if (!result.data) {
        setError(result.error?.message ?? '取得に失敗しました')
        return
      }
      setPreview(result.data)
    })
  return (
    <div className='space-y-6'>
      <p>
        共通条件を一度だけ設定し、メルカリ・イオシスの検索URLを取得します。各URLの先頭1ページ、最大100件を確認するPoCです。定期実行・相場集計への反映は行いません。
      </p>
      <fieldset disabled={busy} className='space-y-4'>
        <legend className='font-semibold'>保存済み計測設定</legend>
        {items.length === 0 && <p>保存済みの設定はありません。</p>}
        {items.map((item) => (
          <div key={item.id} className='flex flex-wrap items-center gap-2 rounded border p-3'>
            <span className='flex-1'>
              {item.name} / {item.enabled ? '有効' : '停止'} / {item.urls.length} URL
            </span>
            <button
              type='button'
              className='btn btn-sm'
              onClick={() => {
                setEditing(item.id)
                setDraft(item)
                setRequired(item.requiredKeywords.join(', '))
                setExcluded(item.excludeKeywords.join(', '))
                setRowKeys(item.urls.map(() => nextKeyRef.current++))
                setPreview(null)
                setError('')
                setNotice('')
              }}
            >
              編集・取得
            </button>
            <button
              type='button'
              className='btn btn-sm'
              onClick={() =>
                perform(async () => {
                  const result = await deleteProductSearchSetting(item.id)
                  if (result.status === 200) {
                    setItems((values) => values.filter((value) => value.id !== item.id))
                    if (editing === item.id) reset()
                  } else setError(result.error?.message ?? '削除に失敗しました')
                })
              }
            >
              削除
            </button>
          </div>
        ))}
        <button type='button' className='btn btn-sm' onClick={reset}>
          新しい計測設定
        </button>
      </fieldset>
      <fieldset disabled={busy} className='space-y-4 rounded border p-4'>
        <legend className='px-2 font-semibold'>
          {editing === null ? '新規登録' : '計測設定を編集'}
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
        <label className='flex items-center gap-2'>
          <input
            type='checkbox'
            className='checkbox'
            checked={draft.enabled}
            onChange={(event) => change({ enabled: event.target.checked })}
          />
          計測を有効にする
        </label>
        <h3 className='font-semibold'>取得URL</h3>
        {draft.urls.map((row, index) => (
          <div key={rowKeys[index]} className='flex flex-wrap items-center gap-2'>
            <label className='min-w-0 flex-1'>
              取得URL {index + 1}
              <input
                className='input w-full'
                value={row.url}
                placeholder='https://…'
                onChange={(event) =>
                  change({
                    urls: draft.urls.map((value, i) =>
                      i === index ? { ...value, url: event.target.value } : value,
                    ),
                  })
                }
              />
            </label>
            <label className='flex items-center gap-1'>
              <input
                type='checkbox'
                className='checkbox'
                checked={row.enabled}
                onChange={(event) =>
                  change({
                    urls: draft.urls.map((value, i) =>
                      i === index ? { ...value, enabled: event.target.checked } : value,
                    ),
                  })
                }
              />
              URL {index + 1}を有効
            </label>
            <button
              type='button'
              className='btn btn-sm'
              aria-label={`取得URL ${index + 1}を削除`}
              onClick={() => {
                change({ urls: draft.urls.filter((_, i) => i !== index) })
                setRowKeys((keys) => keys.filter((_, i) => i !== index))
              }}
            >
              削除
            </button>
          </div>
        ))}
        <button
          type='button'
          className='btn btn-sm'
          disabled={draft.urls.length >= 5}
          onClick={() => {
            change({ urls: [...draft.urls, { url: '', enabled: true }] })
            setRowKeys((keys) => [...keys, nextKeyRef.current++])
          }}
        >
          URLを追加
        </button>
        <h3 className='font-semibold'>全URL共通のフィルター（任意）</h3>
        <p>URLで取得した範囲を絞り込みます。URL側の検索条件を広げるものではありません。</p>
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
        <label className='block'>
          必須語（すべて含む・カンマ/改行区切り）
          <textarea
            className='textarea w-full'
            value={required}
            onChange={(event) => {
              setRequired(event.target.value)
              setPreview(null)
            }}
          />
        </label>
        <label className='block'>
          除外語（いずれかを含む・カンマ/改行区切り）
          <textarea
            className='textarea w-full'
            value={excluded}
            onChange={(event) => {
              setExcluded(event.target.value)
              setPreview(null)
            }}
          />
        </label>
        {draft.excludedListings.map((item) => (
          <div key={`${item.platform}:${item.externalId}`} className='flex flex-wrap gap-2'>
            個別除外: {item.platform} / {item.externalId}
            <button
              type='button'
              className='link'
              onClick={() =>
                change({
                  excludedListings: draft.excludedListings.filter(
                    (value) =>
                      value.platform !== item.platform || value.externalId !== item.externalId,
                  ),
                })
              }
            >
              除外を取り消す
            </button>
          </div>
        ))}
        <div className='flex flex-wrap gap-2'>
          <button type='button' className='btn btn-primary' onClick={submit}>
            保存
          </button>
          <button type='button' className='btn' disabled={!draft.enabled} onClick={runPreview}>
            実際に取得して確認
          </button>
        </div>
        {!draft.enabled && <p>取得するには計測を有効にしてください。</p>}
      </fieldset>
      {busy && <p role='status'>処理中です。取得には時間がかかることがあります。</p>}
      {error && (
        <p role='alert' className='text-error'>
          {error}
        </p>
      )}
      {notice && <p role='status'>{notice}</p>}
      {preview && (
        <section className='space-y-3' aria-label='取得結果'>
          <h3 className='font-semibold'>
            取得結果: {preview.fetchedCount}件 / 採用 {preview.acceptedCount}件
          </h3>
          {preview.sources.map((source) => (
            <div key={`${source.url}`} className='break-all border-b pb-2'>
              {source.platform ?? '未判定'} / {statusNames[source.status]} / {source.fetchedCount}件
              <div>{source.url}</div>
              {source.error && <p className='text-error'>{source.error}</p>}
            </div>
          ))}
          {preview.results.map((item) => (
            <article
              className='space-y-2 border-b py-3'
              key={`${item.platform}:${item.externalId}`}
            >
              <div>
                {item.name} / {item.price == null ? '価格不明' : `${item.price.toLocaleString()}円`}{' '}
                / {item.platform}
              </div>
              <p>
                {item.accepted
                  ? '採用'
                  : `不採用: ${item.reasons.map((reason) => reasonNames[reason] ?? reason).join('、')}`}
              </p>
              {!draft.excludedListings.some(
                (value) => value.platform === item.platform && value.externalId === item.externalId,
              ) && (
                <button
                  type='button'
                  disabled={busy}
                  className='btn btn-sm'
                  onClick={() =>
                    change({
                      excludedListings: [
                        ...draft.excludedListings,
                        { platform: item.platform, externalId: item.externalId },
                      ],
                    })
                  }
                >
                  この計測から出品 {item.externalId}を除外
                </button>
              )}
            </article>
          ))}
        </section>
      )}
    </div>
  )
}
