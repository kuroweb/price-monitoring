'use client'

import { useRef, useState, type KeyboardEvent } from 'react'

import { searchCrawlResults } from '@/features/product-monitoring/api/actions'
import type {
  ExtractionCriteria,
  MonitorCrawlResultSort,
  MonitorSaleStatus,
  SearchCrawlResultsPage,
} from '@/features/product-monitoring/api/types'
import CrawlResultCard from '@/features/product-monitoring/components/CrawlResultCard'
import MonitorFormModal from '@/features/product-monitoring/components/MonitorFormModal'
import ResultPagination from '@/features/product-monitoring/components/ResultPagination'
import { words } from '@/features/product-monitoring/lib/words'
import { formatYen } from '@/lib/format'

const STATUS_FILTERS = [
  ['all', 'すべて'],
  ['on_sale', '販売中'],
  ['sold', '売り切れ'],
] as const
const SORTS = [
  ['newest', '新着順'],
  ['price_asc', '価格の安い順'],
  ['price_desc', '価格の高い順'],
] as const
const PRICE_FIELDS = [
  ['minPrice', '最低価格（円）'],
  ['maxPrice', '最高価格（円）'],
] as const

type SearchInput = Pick<ExtractionCriteria, 'minPrice' | 'maxPrice'> & {
  required: string
  excluded: string
}

type DisplayedSearch = {
  input: SearchInput
  saleStatus: MonitorSaleStatus
  sort: MonitorCrawlResultSort
  results: SearchCrawlResultsPage
}

function extractionCriteria({ required, excluded, minPrice, maxPrice }: SearchInput): ExtractionCriteria {
  return { requiredKeywords: words(required), negativeKeywords: words(excluded), minPrice, maxPrice }
}

function filterLabels({ negativeKeywords, minPrice, maxPrice }: ExtractionCriteria) {
  const labels = []
  if (negativeKeywords.length) labels.push(`除外：${negativeKeywords.join('、')}`)
  if (minPrice != null || maxPrice != null) {
    labels.push(`価格：${minPrice == null ? '下限なし' : formatYen(minPrice)}〜${maxPrice == null ? '上限なし' : formatYen(maxPrice)}`)
  }
  return labels
}

function CriteriaSummary({ label, values }: { label: string; values: string[] }) {
  return (
    <div className='flex flex-wrap items-center gap-x-2 gap-y-1.5 text-sm'>
      <span className='text-base-content/65'>{label}</span>
      <ul className='flex min-w-0 flex-wrap gap-1.5'>
        {values.map((value) => (
          <li key={value} className='max-w-full rounded-box bg-base-300 px-2 py-1 text-xs wrap-anywhere'>
            {value}
          </li>
        ))}
      </ul>
    </div>
  )
}

export default function CrawlResultSearch() {
  const [input, setInput] = useState<SearchInput>({
    required: '', excluded: '', minPrice: null, maxPrice: null,
  })
  const [displayed, setDisplayed] = useState<DisplayedSearch | null>(null)
  const [filtersOpen, setFiltersOpen] = useState(false)
  const [creatingMonitor, setCreatingMonitor] = useState(false)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const inFlightRef = useRef(false)
  const filterToggleRef = useRef<HTMLButtonElement>(null)
  const draftFilters = filterLabels(extractionCriteria(input))
  const appliedCriteria = displayed && extractionCriteria(displayed.input)
  const appliedLabels = appliedCriteria
    ? [...(appliedCriteria.requiredKeywords.length ? [`必須：${appliedCriteria.requiredKeywords.join('、')}`] : []),
      ...filterLabels(appliedCriteria)]
    : []
  const showDraftFilters = !filtersOpen && draftFilters.length > 0 &&
    (!displayed || input.excluded !== displayed.input.excluded ||
      input.minPrice !== displayed.input.minPrice || input.maxPrice !== displayed.input.maxPrice)

  const change = (patch: Partial<SearchInput>) => setInput((value) => ({ ...value, ...patch }))

  const dismissFilters = (event: KeyboardEvent) => {
    if (event.key !== 'Escape' || event.nativeEvent.isComposing) return

    event.preventDefault()
    setFiltersOpen(false)
    filterToggleRef.current?.focus()
  }

  const search = async (
    submitted: SearchInput, saleStatus: MonitorSaleStatus, sort: MonitorCrawlResultSort, page: number,
  ) => {
    if (inFlightRef.current) return

    inFlightRef.current = true
    setLoading(true)
    setError('')
    try {
      const response = await searchCrawlResults({ ...extractionCriteria(submitted), saleStatus, sort, page })
      if (response.data) {
        setDisplayed({ input: submitted, saleStatus, sort, results: response.data })
      } else {
        setError(response.error?.message ?? '収集結果を取得できませんでした。')
      }
    } catch {
      setError('収集結果を取得できませんでした。再試行してください。')
    } finally {
      setLoading(false)
      inFlightRef.current = false
    }
  }

  return (
    <>
      <div className='max-w-3xl space-y-3'>
        <h1 className='text-2xl font-semibold tracking-tight'>収集結果を検索</h1>
        <form
          aria-label='検索条件'
          onSubmit={(event) => {
            event.preventDefault()
            void search(input, displayed?.saleStatus ?? 'all', displayed?.sort ?? 'newest', 1)
          }}
        >
          <fieldset disabled={loading} className='grid min-w-0 gap-3'>
            <div className='grid grid-cols-[minmax(0,1fr)_auto_auto] items-start gap-2'>
              <div className='min-w-0'>
                <label htmlFor='search-keywords' className='sr-only'>必須語</label>
                <textarea
                  id='search-keywords'
                  className='textarea block min-h-11 w-full resize-none py-2.5 text-base sm:text-sm'
                  rows={Math.min(4, input.required.split('\n').length)}
                  placeholder='例：iPad Air, 64GB'
                  aria-describedby='search-keyword-help'
                  value={input.required}
                  onChange={(event) => change({ required: event.target.value })}
                  onKeyDown={(event) => {
                    if (event.key === 'Enter' && !event.shiftKey && !event.nativeEvent.isComposing &&
                        event.nativeEvent.keyCode !== 229) {
                      event.preventDefault()
                      event.currentTarget.form?.requestSubmit()
                    }
                  }}
                />
                <span id='search-keyword-help' className='sr-only'>
                  カンマ・読点・改行で区切った語句をすべて含む商品を検索します。Shift と Enter で改行します。
                </span>
              </div>
              <button type='submit' className='btn btn-primary h-11 px-3 sm:min-w-24'>検索</button>
              <button
                type='button'
                className={`btn h-11 gap-1.5 px-3 ${filtersOpen ? 'btn-active' : ''}`}
                ref={filterToggleRef}
                aria-expanded={filtersOpen}
                aria-controls='search-optional-filters'
                onClick={() => setFiltersOpen(!filtersOpen)}
                onKeyDown={filtersOpen ? dismissFilters : undefined}
              >
                絞り込み
              </button>
            </div>
            <fieldset id='search-optional-filters' className='min-w-0' disabled={!filtersOpen} hidden={!filtersOpen}>
              <div className='space-y-3 rounded-box bg-base-200 p-3 sm:p-4'>
                <div className='grid grid-cols-2 gap-3 sm:grid-cols-[minmax(0,2fr)_1fr_1fr]'>
                  <label className='col-span-2 min-w-0 space-y-1 sm:col-span-1'>
                    <span className='block text-sm font-medium'>除外語</span>
                    <textarea
                      className='textarea block min-h-10 w-full resize-y text-base sm:text-sm'
                      rows={1}
                      placeholder='例：ジャンク, ケース'
                      value={input.excluded}
                      onChange={(event) => change({ excluded: event.target.value })}
                      onKeyDown={dismissFilters}
                    />
                  </label>
                  {PRICE_FIELDS.map(([field, label]) => (
                    <label key={field} className='min-w-0 space-y-1'>
                      <span className='block text-sm font-medium'>{label}</span>
                      <input
                        className='input w-full text-base sm:text-sm'
                        type='number'
                        min={0}
                        step={1}
                        value={input[field] ?? ''}
                        onChange={(event) => change({ [field]: event.target.value === '' ? null : event.target.valueAsNumber })}
                        onKeyDown={dismissFilters}
                      />
                    </label>
                  ))}
                </div>
                <button type='submit' className='btn btn-sm btn-primary btn-outline text-base-content' onKeyDown={dismissFilters}>
                  絞り込んで検索
                </button>
              </div>
            </fieldset>
          </fieldset>
        </form>
        {showDraftFilters && <CriteriaSummary label='未送信の絞り込み' values={draftFilters} />}
      </div>
      {(displayed || loading || error) && (
        <section className='space-y-3 border-t border-base-content/15 pt-4' aria-label='検索結果'>
          <header className='grid grid-cols-[1fr_auto] items-center gap-3 sm:grid-cols-[1fr_auto_auto]'>
            <h2 className='text-lg font-semibold'>検索結果</h2>
            {displayed && (
              <>
                <select
                  className='select select-sm min-h-10 w-auto'
                  aria-label='並び順'
                  value={displayed.sort}
                  disabled={loading}
                  onChange={(event) => void search(
                    displayed.input, displayed.saleStatus, event.target.value as MonitorCrawlResultSort, 1,
                  )}
                >
                  {SORTS.map(([value, label]) => <option key={value} value={value}>{label}</option>)}
                </select>
                <button
                  type='button'
                  className='btn btn-outline btn-primary col-span-2 h-auto min-h-10 w-full py-2 whitespace-normal text-base-content sm:col-span-1 sm:w-auto'
                  disabled={loading}
                  onClick={() => setCreatingMonitor(true)}
                >
                  この条件でモニタリングを作成
                </button>
              </>
            )}
          </header>
          {loading && <p role='status' className='text-sm text-base-content/70'>検索中…</p>}
          {error && <p role='alert' className='text-sm text-error'>{error}</p>}
          {displayed && appliedLabels.length > 0 && <CriteriaSummary label='適用中' values={appliedLabels} />}
          {displayed && (
            <div className='join' role='group' aria-label='販売状態'>
              {STATUS_FILTERS.map(([value, label]) => (
                <button
                  key={value}
                  type='button'
                  className={`btn join-item btn-sm ${displayed.saleStatus === value ? 'btn-primary' : 'btn-ghost'}`}
                  aria-pressed={displayed.saleStatus === value}
                  disabled={loading}
                  onClick={() => {
                    if (value === displayed.saleStatus) return
                    void search(displayed.input, value, displayed.sort, 1)
                  }}
                >
                  {label}
                </button>
              ))}
            </div>
          )}
          {displayed && (
            <>
              {displayed.results.crawlResults.length === 0 ? (
                <p className='rounded-box bg-base-300 px-3 py-6 text-center text-sm text-base-content/70'>
                  該当する収集結果はありません。
                </p>
              ) : (
                <ul className='grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-4 xl:grid-cols-6'>
                  {displayed.results.crawlResults.map((item) => (
                    <li key={item.id} className='min-w-0'>
                      <CrawlResultCard crawlResult={item} variant='search' />
                    </li>
                  ))}
                </ul>
              )}
              <ResultPagination
                label='検索結果のページ'
                page={displayed.results.page}
                hasMore={displayed.results.hasMore}
                disabled={loading}
                onChange={(page) => void search(displayed.input, displayed.saleStatus, displayed.sort, page)}
              />
              {creatingMonitor && (
                <MonitorFormModal
                  initial={{
                    ...extractionCriteria(displayed.input),
                    name: '',
                    enabled: false,
                    discordEnabled: true,
                    newestNotificationEnabled: false,
                  }}
                  onClose={() => setCreatingMonitor(false)}
                />
              )}
            </>
          )}
        </section>
      )}
    </>
  )
}
