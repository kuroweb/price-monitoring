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
import { words } from '@/features/admin/product-crawl-settings/lib/platform'
import { createProductAggregationSetting, updateProductAggregationSetting } from '@/lib/actions'
import type { ProductAggregationSetting, ProductAggregationSettingInput } from '@/lib/api'

type Props = {
  onClose: () => void
  setting?: ProductAggregationSetting
}

// 開くたびに描画し直し、編集対象の値で初期化する
export default function ProductAggregationSettingFormModal({ onClose, setting }: Props) {
  const router = useRouter()
  const [input, setInput] = useState<ProductAggregationSettingInput>(() => ({
    name: setting?.name ?? '',
    requiredKeywords: setting?.requiredKeywords ?? [],
    excludeKeywords: setting?.excludeKeywords ?? [],
    minPrice: setting?.minPrice ?? null,
    maxPrice: setting?.maxPrice ?? null,
  }))
  const [required, setRequired] = useState(setting?.requiredKeywords.join(', ') ?? '')
  const [excluded, setExcluded] = useState(setting?.excludeKeywords.join(', ') ?? '')
  const [error, setError] = useState('')
  const [busy, setBusy] = useState(false)
  const inFlightRef = useRef(false)
  const change = (patch: Partial<ProductAggregationSettingInput>) =>
    setInput((value) => ({ ...value, ...patch }))

  const submit = async () => {
    if (inFlightRef.current) return
    if (!input.name.trim()) {
      setError('名前を入力してください')
      return
    }
    if (input.minPrice != null && input.maxPrice != null && input.minPrice > input.maxPrice) {
      setError('最低価格は最高価格以下にしてください')
      return
    }
    inFlightRef.current = true
    setBusy(true)
    setError('')
    try {
      const payload = {
        ...input,
        requiredKeywords: words(required),
        excludeKeywords: words(excluded),
      }
      const result = setting
        ? await updateProductAggregationSetting(setting.id, payload)
        : await createProductAggregationSetting(payload)
      if (!result.data) {
        setError(result.error?.message ?? '保存に失敗しました')
        return
      }
      toast.success(setting ? '商品相場設定を更新しました' : '商品相場設定を登録しました')
      onClose()
      router.refresh()
    } catch {
      setError('通信に失敗しました。時間をおいて再試行してください。')
    } finally {
      inFlightRef.current = false
      setBusy(false)
    }
  }

  return (
    <>
      <input type='checkbox' className='modal-toggle' checked onChange={() => onClose()} />
      <div className='modal' role='dialog'>
        <ScrollableModalBox
          title={setting ? '商品相場設定を更新' : '商品相場設定を追加'}
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
                      value={input.minPrice ?? ''}
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
                      value={input.maxPrice ?? ''}
                      onChange={(event) =>
                        change({
                          maxPrice: event.target.value === '' ? null : Number(event.target.value),
                        })
                      }
                    />
                  </label>
                </div>
              </fieldset>
              {error && (
                <p role='alert' className='pt-3 text-error'>
                  {error}
                </p>
              )}
            </ScrollableModalBody>
            <ScrollableModalFooter>
              <button disabled={busy} type='submit' className='btn btn-primary w-full'>
                {busy ? '保存中…' : setting ? '更新' : '登録'}
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
