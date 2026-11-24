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
        <input
          id={`${id}-required`}
          className='input w-full'
          type='text'
          placeholder='例：iPad 64GB'
          value={required}
          onChange={(event) => onRequiredChange(event.target.value)}
        />
      </div>
      <div className='min-w-0 space-y-1'>
        <label className='block font-medium' htmlFor={`${id}-excluded`}>除外語</label>
        <input
          id={`${id}-excluded`}
          className='input w-full'
          type='text'
          placeholder='例：ジャンク ケース'
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
