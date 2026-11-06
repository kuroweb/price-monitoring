'use client'

import { useEffect, useRef, useState } from 'react'

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
  getProductCrawlResults,
  setProductCrawlResultExcluded,
  updateProductCrawlSetting,
} from '@/features/product-monitoring/api/actions'
import type { ProductCrawlResult, ProductCrawlSetting, ProductCrawlSettingInput } from '@/features/product-monitoring/api/types'
import ProductFilterFields from '@/features/product-monitoring/components/ProductFilterFields'
import { words } from '@/features/product-monitoring/lib/words'
import { platformName } from '@/lib/format'

import { searchUrlPlatform } from '../lib/platform'

import ExcludedListings from './ExcludedListings'


const MAX_SEARCH_URLS = 5

const empty = (): ProductCrawlSettingInput => ({
  name: '',
  enabled: false,
  searchUrls: [''],
  requiredKeywords: [],
  excludeKeywords: [],
  minPrice: null,
  maxPrice: null,
})

type Props = {
  onClose: () => void
  setting?: ProductCrawlSetting
}

// 開くたびに描画し直し、編集対象の値で初期化する
export default function ProductCrawlSettingFormModal({ onClose, setting }: Props) {
  const router = useRouter()
  const [input, setInput] = useState<ProductCrawlSettingInput>(() =>
    setting
      ? { ...setting, searchUrls: setting.searchUrls.length ? setting.searchUrls : [''] }
      : empty(),
  )
  const [required, setRequired] = useState(setting?.requiredKeywords.join(', ') ?? '')
  const [excluded, setExcluded] = useState(setting?.excludeKeywords.join(', ') ?? '')
  const nextKeyRef = useRef(input.searchUrls.length)
  const [rowKeys, setRowKeys] = useState(() => input.searchUrls.map((_, i) => i))
  const [error, setError] = useState('')
  // 更新では、保存済みの除外した出品を画像・名前・リンクつきで並べ、その場で取り消す
  const [excludedResults, setExcludedResults] = useState<ProductCrawlResult[]>([])
  const [busy, setBusy] = useState(false)
  const inFlightRef = useRef(false)
  useEffect(() => {
    if (!setting) return
    getProductCrawlResults({ productCrawlSettingId: setting.id, excluded: true })
      .then((result) => setExcludedResults(result.data?.productCrawlResults ?? []))
      .catch(() => setError('除外した出品を取得できませんでした'))
  }, [setting])
  const change = (patch: Partial<ProductCrawlSettingInput>) => {
    setInput((value) => ({ ...value, ...patch }))
  }
  const payload = () => ({
    ...input,
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
    if (input.searchUrls.length === 0 || input.searchUrls.some((url) => !url.trim())) {
      setError(`検索結果URLを1〜${MAX_SEARCH_URLS}件入力してください`)
      return false
    }
    if (
      [input.minPrice, input.maxPrice].some(
        (price) => price != null && (!Number.isSafeInteger(price) || price < 0),
      ) ||
      (input.minPrice != null && input.maxPrice != null && input.minPrice > input.maxPrice)
    ) {
      setError('価格は0以上の整数で、最低価格は最高価格以下にしてください')
      return false
    }
    return true
  }
  const submit = () =>
    perform(async () => {
      if (!valid()) return
      if (!input.name.trim()) {
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
  const restore = (key: string) =>
    perform(async () => {
      const result = await setProductCrawlResultExcluded(Number(key), false)
      if (!result.data) {
        setError('除外の取り消しに失敗しました')
        return
      }
      setExcludedResults((values) => values.filter((value) => String(value.id) !== key))
      router.refresh()
    })
  const excludedItems = excludedResults.map((item) => ({ ...item, key: String(item.id) }))

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
                    value={input.name}
                    onChange={(event) => change({ name: event.target.value })}
                  />
                </label>
                <label className='flex items-center gap-2'>
                  <input
                    type='checkbox'
                    className='checkbox checkbox-sm'
                    checked={input.enabled}
                    onChange={(event) => change({ enabled: event.target.checked })}
                  />
                  計測を有効にする
                </label>
                <h4 className='font-semibold'>検索結果URL</h4>
                {input.searchUrls.map((url, index) => (
                  <div key={rowKeys[index]} className='flex flex-wrap items-end gap-2'>
                    <label className='min-w-0 flex-1'>
                      検索結果URL {index + 1}
                      <input
                        className='input w-full'
                        value={url}
                        placeholder='https://…'
                        onChange={(event) =>
                          change({
                            searchUrls: input.searchUrls.map((value, i) =>
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
                        change({ searchUrls: input.searchUrls.filter((_, i) => i !== index) })
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
                  disabled={input.searchUrls.length >= MAX_SEARCH_URLS}
                  onClick={() => {
                    change({ searchUrls: [...input.searchUrls, ''] })
                    setRowKeys((keys) => [...keys, nextKeyRef.current++])
                  }}
                >
                  URLを追加
                </button>
                <h4 className='font-semibold'>全URL共通の追加条件（任意）</h4>
                <ProductFilterFields
                  required={required}
                  excluded={excluded}
                  minPrice={input.minPrice}
                  maxPrice={input.maxPrice}
                  onRequiredChange={setRequired}
                  onExcludedChange={setExcluded}
                  onPriceChange={change}
                />
                <ExcludedListings items={excludedItems} disabled={busy} onRestore={restore} />
              </fieldset>
              {error && (
                <p role='alert' className='pt-3 text-error'>
                  {error}
                </p>
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
