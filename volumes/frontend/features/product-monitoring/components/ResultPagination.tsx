type Props = {
  label: string
  page: number
  hasMore: boolean
  disabled?: boolean
  onChange: (page: number) => void
}

export default function ResultPagination({ label, page, hasMore, disabled, onChange }: Props) {
  if (page === 1 && !hasMore) return null

  const pageNumbers = [page - 1, page, page + 1].filter(
    (number) => number >= 1 && (number <= page || hasMore),
  )

  return (
    <nav className='join flex-wrap' aria-label={label}>
      {page > 1 && (
        <button type='button' className='btn join-item btn-sm' disabled={disabled} onClick={() => onChange(page - 1)}>
          前へ
        </button>
      )}
      {pageNumbers.map((number) => (
        <button
          key={number}
          type='button'
          className={`btn join-item btn-sm ${number === page ? 'btn-active' : ''}`}
          aria-label={`${number}ページ`}
          aria-current={number === page ? 'page' : undefined}
          disabled={disabled || number === page}
          onClick={() => onChange(number)}
        >
          {number}
        </button>
      ))}
      {hasMore && (
        <button type='button' className='btn join-item btn-sm' disabled={disabled} onClick={() => onChange(page + 1)}>
          次へ
        </button>
      )}
    </nav>
  )
}
