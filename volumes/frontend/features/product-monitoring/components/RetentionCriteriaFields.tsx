import { useId } from 'react'

import KeywordTextarea from '@/features/product-monitoring/components/KeywordTextarea'

type Props = {
  required: string
  excluded: string
  minPrice: number | null
  maxPrice: number | null
  onRequiredChange: (value: string) => void
  onExcludedChange: (value: string) => void
  onPriceChange: (patch: { minPrice?: number | null; maxPrice?: number | null }) => void
}

export default function RetentionCriteriaFields({
  required,
  excluded,
  minPrice,
  maxPrice,
  onRequiredChange,
  onExcludedChange,
  onPriceChange,
}: Props) {
  const id = useId()

  return (
    <>
      <div>
        <label className='block' htmlFor={`${id}-required`}>必須語（すべて含む・スペースまたは改行区切り）</label>
        <span id={`${id}-required-hint`} className='block text-xs text-base-content/70'>スペースを含む語句は半角の「&quot;」で囲みます</span>
        <KeywordTextarea
          id={`${id}-required`}
          aria-describedby={`${id}-required-hint`}
          className='textarea w-full'
          placeholder='例：iPad 64GB'
          value={required}
          onChange={(event) => onRequiredChange(event.target.value)}
        />
      </div>
      <div>
        <label className='block' htmlFor={`${id}-excluded`}>除外語（いずれかを含む・スペースまたは改行区切り）</label>
        <span id={`${id}-excluded-hint`} className='block text-xs text-base-content/70'>スペースを含む語句は半角の「&quot;」で囲みます</span>
        <KeywordTextarea
          id={`${id}-excluded`}
          aria-describedby={`${id}-excluded-hint`}
          className='textarea w-full'
          placeholder='例：ジャンク ケース'
          value={excluded}
          onChange={(event) => onExcludedChange(event.target.value)}
        />
      </div>
      <div className='grid gap-3 sm:grid-cols-2'>
        <label>
          最低価格（円）
          <input
            className='input w-full'
            type='number'
            min={0}
            step={1}
            value={minPrice ?? ''}
            onChange={(event) =>
              onPriceChange({
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
            value={maxPrice ?? ''}
            onChange={(event) =>
              onPriceChange({
                maxPrice: event.target.value === '' ? null : Number(event.target.value),
              })
            }
          />
        </label>
      </div>
    </>
  )
}
