type Props = {
  required: string
  excluded: string
  minPrice: number | null
  maxPrice: number | null
  onRequiredChange: (value: string) => void
  onExcludedChange: (value: string) => void
  onPriceChange: (patch: { minPrice?: number | null; maxPrice?: number | null }) => void
}

export default function ProductFilterFields({
  required,
  excluded,
  minPrice,
  maxPrice,
  onRequiredChange,
  onExcludedChange,
  onPriceChange,
}: Props) {
  return (
    <>
      <label className='block'>
        必須語（すべて含む・カンマ/改行区切り）
        <textarea
          className='textarea w-full'
          value={required}
          onChange={(event) => onRequiredChange(event.target.value)}
        />
      </label>
      <label className='block'>
        除外語（いずれかを含む・カンマ/改行区切り）
        <textarea
          className='textarea w-full'
          value={excluded}
          onChange={(event) => onExcludedChange(event.target.value)}
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
