import { useId } from 'react'

type Props = {
  required: string
  excluded: string
  minPrice: number | null
  maxPrice: number | null
  onRequiredChange: (value: string) => void
  onExcludedChange: (value: string) => void
  onPriceChange: (patch: { minPrice?: number | null; maxPrice?: number | null }) => void
}

export default function ExtractionCriteriaFields({
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
    <div className='grid gap-4'>
      <div className='min-w-0 space-y-1'>
        <label className='block font-medium' htmlFor={`${id}-required`}>必須語</label>
        <p id={`${id}-required-hint`} className='text-xs text-base-content/70'>
          すべて含む。スペースまたは改行区切り。スペースを含む語句は半角の「&quot;」で囲みます
        </p>
        <textarea
          id={`${id}-required`}
          aria-describedby={`${id}-required-hint`}
          className='textarea block min-h-16 w-full resize-y'
          rows={2}
          value={required}
          onChange={(event) => onRequiredChange(event.target.value)}
        />
      </div>
      <div className='min-w-0 space-y-1'>
        <label className='block font-medium' htmlFor={`${id}-excluded`}>除外語</label>
        <p id={`${id}-excluded-hint`} className='text-xs text-base-content/70'>
          いずれかを含むと除外。スペースまたは改行区切り。スペースを含む語句は半角の「&quot;」で囲みます
        </p>
        <textarea
          id={`${id}-excluded`}
          aria-describedby={`${id}-excluded-hint`}
          className='textarea block min-h-16 w-full resize-y'
          rows={2}
          value={excluded}
          onChange={(event) => onExcludedChange(event.target.value)}
        />
      </div>
      <div className='grid min-w-0 grid-cols-2 items-end gap-3'>
        <label className='min-w-0 space-y-1'>
          <span className='block font-medium'>最低価格（円）</span>
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
        <label className='min-w-0 space-y-1'>
          <span className='block font-medium'>最高価格（円）</span>
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
    </div>
  )
}
