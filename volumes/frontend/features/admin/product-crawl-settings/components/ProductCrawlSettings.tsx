'use client'

import { useRef, useState } from 'react'

import Link from 'next/link'

import {
  createProductCrawlSetting,
  destroyProductCrawlSetting,
  previewProductCrawlSetting,
  updateProductCrawlSetting,
} from '@/lib/actions'
import type { ProductCrawlPreview, ProductCrawlSetting, ProductCrawlSettingDraft } from '@/lib/api'

import { platformName, searchUrlPlatform, words } from '../lib/platform'

const MAX_SEARCH_URLS = 5

const empty = (): ProductCrawlSettingDraft => ({
  name: '',
  enabled: false,
  searchUrls: [''],
  requiredKeywords: [],
  excludeKeywords: [],
  excludeExternalIds: [],
  minPrice: null,
  maxPrice: null,
})
const statusNames = {
  succeeded: '取得成功',
  failed: '取得失敗',
  unsupported: '非対応URL',
}
const reasonNames: Record<string, string> = {
  below_min_price: '最低価格未満・価格不明',
  above_max_price: '最高価格超過・価格不明',
  missing_required_keyword: '必須語に不一致',
  excluded_keyword: '除外語に一致',
  excluded_listing: '除外した出品',
}

export default function ProductCrawlSettings({ initial }: { initial: ProductCrawlSetting[] }) {
  const [items, setItems] = useState(initial)
  const [draft, setDraft] = useState<ProductCrawlSettingDraft>(empty)
  const [editing, setEditing] = useState<number | null>(null)
  const [required, setRequired] = useState('')
  const [excluded, setExcluded] = useState('')
  const [rowKeys, setRowKeys] = useState([0])
  const nextKeyRef = useRef(1)
  const [preview, setPreview] = useState<ProductCrawlPreview | null>(null)
  const [error, setError] = useState('')
  const [notice, setNotice] = useState('')
  const [busy, setBusy] = useState(false)
  const inFlightRef = useRef(false)
  const change = (patch: Partial<ProductCrawlSettingDraft>) => {
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
  const edit = (item: ProductCrawlSetting) => {
    setEditing(item.id)
    setDraft(item)
    setRequired(item.requiredKeywords.join(', '))
    setExcluded(item.excludeKeywords.join(', '))
    setRowKeys(item.searchUrls.map(() => nextKeyRef.current++))
    setPreview(null)
    setError('')
    setNotice('')
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
    if (draft.searchUrls.length === 0 || draft.searchUrls.some((url) => !url.trim())) {
      setError(`検索結果URLを1〜${MAX_SEARCH_URLS}件入力してください`)
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
          ? await createProductCrawlSetting(payload())
          : await updateProductCrawlSetting(editing, payload())
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
      setNotice('商品計測設定を保存しました。結果の保存は商品計測結果の画面から実行します。')
    })
  const runPreview = () =>
    perform(async () => {
      if (!valid()) return
      setPreview(null)
      const result = await previewProductCrawlSetting(payload())
      if (!result.data) {
        setError(result.error?.message ?? '取得に失敗しました')
        return
      }
      setPreview(result.data)
    })
  const destroy = (item: ProductCrawlSetting) =>
    perform(async () => {
      if (!window.confirm(`商品計測設定「${item.name}」を削除しますか？`)) return
      const result = await destroyProductCrawlSetting(item.id)
      if (result.status !== 200) {
        setError(result.error?.message ?? '削除に失敗しました')
        return
      }
      setItems((values) => values.filter((value) => value.id !== item.id))
      if (editing === item.id) reset()
    })
  return (
    <div className='space-y-6'>
      <p>
        条件を一度だけ設定し、メルカリ・イオシスの検索結果URLを取得します。各URLの先頭1ページ、最大100件を確認するPoCです。
      </p>
      <fieldset disabled={busy} className='space-y-2'>
        <legend className='font-semibold'>商品計測設定一覧</legend>
        {items.length === 0 && <p>商品計測設定はありません。</p>}
        {items.map((item) => (
          <div key={item.id} className='flex flex-wrap items-center gap-2 rounded border p-3'>
            <span className='min-w-0 flex-1'>
              {item.name} / {item.enabled ? '有効' : '停止'} / {item.searchUrls.length} URL
            </span>
            <Link className='btn btn-sm' href={`/admin/product-crawl-settings/${item.id}/results`}>
              商品計測結果
            </Link>
            <button type='button' className='btn btn-sm' onClick={() => edit(item)}>
              編集
            </button>
            <button type='button' className='btn btn-sm' onClick={() => destroy(item)}>
              削除
            </button>
          </div>
        ))}
        <button type='button' className='btn btn-sm' onClick={reset}>
          新しい商品計測設定
        </button>
      </fieldset>
      <fieldset disabled={busy} className='space-y-4 rounded border p-4'>
        <legend className='px-2 font-semibold'>
          {editing === null ? '商品計測設定の登録' : '商品計測設定の編集'}
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
        <h3 className='font-semibold'>検索結果URL</h3>
        {draft.searchUrls.map((url, index) => (
          <div key={rowKeys[index]} className='flex flex-wrap items-end gap-2'>
            <label className='min-w-0 flex-1'>
              検索結果URL {index + 1}
              <input
                className='input w-full'
                value={url}
                placeholder='https://…'
                onChange={(event) =>
                  change({
                    searchUrls: draft.searchUrls.map((value, i) =>
                      i === index ? event.target.value : value,
                    ),
                  })
                }
              />
            </label>
            <span className='badge badge-outline mb-2'>
              {url.trim() ? platformName(searchUrlPlatform(url)) : 'サイト'}
            </span>
            <button
              type='button'
              className='btn btn-sm mb-1'
              aria-label={`検索結果URL ${index + 1}を削除`}
              onClick={() => {
                change({ searchUrls: draft.searchUrls.filter((_, i) => i !== index) })
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
          disabled={draft.searchUrls.length >= MAX_SEARCH_URLS}
          onClick={() => {
            change({ searchUrls: [...draft.searchUrls, ''] })
            setRowKeys((keys) => [...keys, nextKeyRef.current++])
          }}
        >
          URLを追加
        </button>
        <h3 className='font-semibold'>全URL共通の追加条件（任意）</h3>
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
        {draft.excludeExternalIds.map((externalId) => (
          <div key={externalId} className='flex flex-wrap gap-2'>
            除外した出品: {externalId}
            <button
              type='button'
              className='link'
              onClick={() =>
                change({
                  excludeExternalIds: draft.excludeExternalIds.filter(
                    (value) => value !== externalId,
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
          <button type='button' className='btn' onClick={runPreview}>
            実際に取得して確認
          </button>
        </div>
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
            <div key={source.url} className='break-all border-b pb-2'>
              {platformName(source.platform)} / {statusNames[source.status]} / {source.fetchedCount}
              件<div>{source.url}</div>
              {source.error && <p className='text-error'>{source.error}</p>}
            </div>
          ))}
          {preview.results.map((item) => (
            <article className='space-y-2 border-b py-3' key={item.externalId}>
              <div>
                <a className='link' href={item.productUrl} target='_blank' rel='noreferrer'>
                  {item.name}
                </a>{' '}
                / {item.price == null ? '価格不明' : `${item.price.toLocaleString()}円`} /{' '}
                {platformName(item.platform)}
              </div>
              <p>
                {item.accepted
                  ? '採用'
                  : `不採用: ${item.reasons.map((reason) => reasonNames[reason] ?? reason).join('、')}`}
              </p>
              {!draft.excludeExternalIds.includes(item.externalId) && (
                <button
                  type='button'
                  disabled={busy}
                  className='btn btn-sm'
                  onClick={() =>
                    setDraft((value) => ({
                      ...value,
                      excludeExternalIds: [...value.excludeExternalIds, item.externalId],
                    }))
                  }
                >
                  出品 {item.externalId} を除外
                </button>
              )}
            </article>
          ))}
        </section>
      )}
    </div>
  )
}
