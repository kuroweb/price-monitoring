'use client'

import { useRef, useState } from 'react'

import { useRouter } from 'next/navigation'
import { toast } from 'react-toastify'

import {
  ScrollableModalBody,
  ScrollableModalBox,
  ScrollableModalFooter,
  ScrollableModalForm,
} from '@/components/ui/ScrollableModalBox'
import {
  createProductCrawlSetting,
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

type Props = {
  onClose: () => void
  setting?: ProductCrawlSetting
}

// 開くたびに描画し直し、編集対象の値で初期化する
export default function ProductCrawlSettingFormModal({ onClose, setting }: Props) {
  const router = useRouter()
  const [draft, setDraft] = useState<ProductCrawlSettingDraft>(() =>
    setting
      ? { ...setting, searchUrls: setting.searchUrls.length ? setting.searchUrls : [''] }
      : empty(),
  )
  const [required, setRequired] = useState(setting?.requiredKeywords.join(', ') ?? '')
  const [excluded, setExcluded] = useState(setting?.excludeKeywords.join(', ') ?? '')
  const nextKeyRef = useRef(draft.searchUrls.length)
  const [rowKeys, setRowKeys] = useState(() => draft.searchUrls.map((_, i) => i))
  const [preview, setPreview] = useState<ProductCrawlPreview | null>(null)
  const [error, setError] = useState('')
  const [busy, setBusy] = useState(false)
  const inFlightRef = useRef(false)
  const change = (patch: Partial<ProductCrawlSettingDraft>) => {
    setDraft((value) => ({ ...value, ...patch }))
    setPreview(null)
  }
  const payload = () => ({
    ...draft,
    requiredKeywords: words(required),
    excludeKeywords: words(excluded),
  })
  const perform = async (action: () => Promise<void>) => {
    if (inFlightRef.current) return
    inFlightRef.current = true
    setBusy(true)
    setError('')
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
      const result = setting
        ? await updateProductCrawlSetting(setting.id, payload())
        : await createProductCrawlSetting(payload())
      if (!result.data) {
        setError(result.error?.message ?? '保存に失敗しました')
        return
      }
      toast.success(setting ? '商品計測設定を更新しました' : '商品計測設定を登録しました')
      onClose()
      router.refresh()
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

  return (
    <>
      <input type='checkbox' className='modal-toggle' checked onChange={() => onClose()} />
      <div className='modal' role='dialog'>
        <ScrollableModalBox
          title={setting ? '商品計測設定を更新' : '商品計測設定を追加'}
          onClose={onClose}
        >
          <ScrollableModalForm
            onSubmit={(event) => {
              event.preventDefault()
              submit()
            }}
          >
            <ScrollableModalBody>
              <fieldset disabled={busy} className='space-y-4 pt-4 max-sm:pt-0'>
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
                    className='checkbox checkbox-sm'
                    checked={draft.enabled}
                    onChange={(event) => change({ enabled: event.target.checked })}
                  />
                  計測を有効にする
                </label>
                <h4 className='font-semibold'>検索結果URL</h4>
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
                <h4 className='font-semibold'>全URL共通の追加条件（任意）</h4>
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
                        change({
                          minPrice: event.target.value === '' ? null : Number(event.target.value),
                        })
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
                        change({
                          maxPrice: event.target.value === '' ? null : Number(event.target.value),
                        })
                      }
                    />
                  </label>
                </div>
                {draft.excludeExternalIds.map((externalId) => (
                  <div key={externalId} className='flex flex-wrap gap-2 break-all'>
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
                <button type='button' className='btn w-full' onClick={runPreview}>
                  実際に取得して確認
                </button>
              </fieldset>
              {busy && (
                <p role='status' className='pt-3'>
                  処理中です。取得には時間がかかることがあります。
                </p>
              )}
              {error && (
                <p role='alert' className='pt-3 text-error'>
                  {error}
                </p>
              )}
              {preview && (
                <section className='space-y-3 pt-4' aria-label='取得結果'>
                  <h4 className='font-semibold'>
                    取得結果: {preview.fetchedCount}件 / 採用 {preview.acceptedCount}件
                  </h4>
                  {preview.sources.map((source) => (
                    <div key={source.url} className='break-all border-b pb-2'>
                      {platformName(source.platform)} / {statusNames[source.status]} /{' '}
                      {source.fetchedCount}件<div>{source.url}</div>
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
            </ScrollableModalBody>
            <ScrollableModalFooter>
              <button disabled={busy} type='submit' className='btn btn-primary w-full'>
                {busy ? '処理中…' : setting ? '更新' : '登録'}
              </button>
            </ScrollableModalFooter>
          </ScrollableModalForm>
        </ScrollableModalBox>
        <button
          type='button'
          onClick={onClose}
          className='modal-backdrop'
          aria-label='背景から閉じる'
        />
      </div>
    </>
  )
}
