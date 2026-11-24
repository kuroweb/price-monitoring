import { useId, useState, type ComponentProps } from 'react'

import { hasCommaAtWordBoundary } from '@/features/product-monitoring/lib/words'

type Props = Omit<ComponentProps<'textarea'>, 'value'> & { value: string }

export default function KeywordTextarea({
  value,
  onChange,
  onBlur,
  'aria-describedby': describedBy,
  ...props
}: Props) {
  const hintId = useId()
  const [editing, setEditing] = useState(false)

  return (
    <>
      <textarea
        {...props}
        value={value}
        aria-describedby={describedBy ? `${describedBy} ${hintId}` : hintId}
        onChange={(event) => {
          setEditing(true)
          onChange?.(event)
        }}
        onBlur={(event) => {
          setEditing(false)
          onBlur?.(event)
        }}
      />
      <span id={hintId} aria-live='polite' className='block text-xs text-base-content/70'>
        {editing && hasCommaAtWordBoundary(value) && (
          '語句を分けるにはスペースを使います（例：iPad 64GB）。カンマ・読点は語句の一部です。'
        )}
      </span>
    </>
  )
}
