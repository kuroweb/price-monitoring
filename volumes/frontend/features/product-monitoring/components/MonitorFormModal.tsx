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
  createMonitor,
  updateMonitor,
} from '@/features/product-monitoring/api/actions'
import type {
  Monitor,
  MonitorInput,
} from '@/features/product-monitoring/api/types'
import ExtractionCriteriaFields from '@/features/product-monitoring/components/ExtractionCriteriaFields'
import { words } from '@/features/product-monitoring/lib/words'

type Props = {
  onClose: () => void
  monitor?: Monitor
  initial?: MonitorInput
}

export default function MonitorFormModal({
  onClose,
  monitor,
  initial,
}: Props) {
  const router = useRouter()
  const values = monitor ?? initial
  const [input, setInput] = useState<MonitorInput>(() => ({
    name: values?.name ?? '',
    enabled: values?.enabled ?? true,
    requiredKeywords: values?.requiredKeywords ?? [],
    negativeKeywords: values?.negativeKeywords ?? [],
    minPrice: values?.minPrice ?? null,
    maxPrice: values?.maxPrice ?? null,
    discordEnabled: values?.discordEnabled ?? true,
  }))
  const [required, setRequired] = useState(values?.requiredKeywords.join(', ') ?? '')
  const [excluded, setExcluded] = useState(values?.negativeKeywords.join(', ') ?? '')
  const [error, setError] = useState('')
  const [busy, setBusy] = useState(false)
  const inFlightRef = useRef(false)
  const change = (patch: Partial<MonitorInput>) =>
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
        negativeKeywords: words(excluded),
      }
      const result = monitor
        ? await updateMonitor(monitor.id, payload)
        : await createMonitor(payload)
      if (!result.data) {
        setError(result.error?.message ?? '保存に失敗しました')
        return
      }
      toast.success(
        monitor ? 'モニタリング設定を更新しました' : 'モニタリング設定を登録しました',
      )
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
      <input type='checkbox' className='modal-toggle' checked onChange={onClose} />
      <div className='modal' role='dialog'>
        <ScrollableModalBox
          title={monitor ? 'モニタリング設定を更新' : 'モニタリング設定を追加'}
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
                <ExtractionCriteriaFields
                  required={required}
                  excluded={excluded}
                  minPrice={input.minPrice}
                  maxPrice={input.maxPrice}
                  onRequiredChange={setRequired}
                  onExcludedChange={setExcluded}
                  onPriceChange={change}
                />
                {monitor && <p className='text-sm opacity-65'>抽出条件を変更すると、現在の日次相場は消去され、次の集計で更新されます。</p>}
                <label className='flex items-center gap-2'>
                  <input
                    type='checkbox'
                    className='checkbox'
                    checked={input.enabled}
                    onChange={(event) => change({ enabled: event.target.checked })}
                  />
                  最安値の変化を通知する
                </label>
              </fieldset>
              {error && (
                <p role='alert' className='pt-3 text-error'>
                  {error}
                </p>
              )}
            </ScrollableModalBody>
            <ScrollableModalFooter>
              <button disabled={busy} type='submit' className='btn btn-primary w-full'>
                {busy ? '保存中…' : monitor ? '更新' : '登録'}
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
