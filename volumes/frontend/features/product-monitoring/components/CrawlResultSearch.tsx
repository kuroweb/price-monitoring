'use client'

import { useRef, useState } from 'react'

import { searchCrawlResults } from '@/features/product-monitoring/api/actions'
import type {
  ExtractionCriteria,
  MonitorCrawlResultSort,
  SearchCrawlResultsPage,
} from '@/features/product-monitoring/api/types'
import CrawlResultCard from '@/features/product-monitoring/components/CrawlResultCard'
import ExtractionCriteriaFields from '@/features/product-monitoring/components/ExtractionCriteriaFields'
import MonitorFormModal from '@/features/product-monitoring/components/MonitorFormModal'
import ResultPagination from '@/features/product-monitoring/components/ResultPagination'
import { words } from '@/features/product-monitoring/lib/words'

const SORTS = [
  ['newest', '新着順'],
  ['price_asc', '価格の安い順'],
  ['price_desc', '価格の高い順'],
] as const

type SearchInput = Pick<ExtractionCriteria, 'minPrice' | 'maxPrice'> & {
  required: string
  excluded: string
}

type DisplayedSearch = { input: SearchInput; sort: MonitorCrawlResultSort; results: SearchCrawlResultsPage }

function extractionCriteria({ required, excluded, minPrice, maxPrice }: SearchInput): ExtractionCriteria {
  return { requiredKeywords: words(required), negativeKeywords: words(excluded), minPrice, maxPrice }
}

export default function CrawlResultSearch() {
  const [input, setInput] = useState<SearchInput>({
    required: '', excluded: '', minPrice: null, maxPrice: null,
  })
  const [displayed, setDisplayed] = useState<DisplayedSearch | null>(null)
  const [creatingMonitor, setCreatingMonitor] = useState(false)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const inFlightRef = useRef(false)
  const hasDraftChanges = displayed && (
    input.required !== displayed.input.required || input.excluded !== displayed.input.excluded ||
    input.minPrice !== displayed.input.minPrice || input.maxPrice !== displayed.input.maxPrice
  )

  const change = (patch: Partial<SearchInput>) => setInput((value) => ({ ...value, ...patch }))

  const search = async (submitted: SearchInput, sort: MonitorCrawlResultSort, page: number) => {
    if (inFlightRef.current) return

    inFlightRef.current = true
    setLoading(true)
    setError('')
    try {
      const response = await searchCrawlResults({ ...extractionCriteria(submitted), sort, page })
      if (response.data) {
        setDisplayed({ input: submitted, sort, results: response.data })
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
      <h1 className='card-title'>収集結果を検索</h1>
      <form
        aria-labelledby='search-criteria'
        className='rounded-box bg-base-200 p-4'
        onSubmit={(event) => {
          event.preventDefault()
          void search(input, displayed?.sort ?? 'newest', 1)
        }}
      >
        <h2 id='search-criteria' className='mb-4 font-semibold'>検索条件</h2>
        <fieldset disabled={loading} className='grid min-w-0 gap-4 lg:grid-cols-2'>
          <ExtractionCriteriaFields
            className='contents'
            required={input.required}
            excluded={input.excluded}
            minPrice={input.minPrice}
            maxPrice={input.maxPrice}
            onRequiredChange={(required) => change({ required })}
            onExcludedChange={(excluded) => change({ excluded })}
            onPriceChange={change}
          />
          <button type='submit' className='btn btn-primary w-full self-end lg:w-auto lg:min-w-28 lg:justify-self-start'>
            検索
          </button>
        </fieldset>
      </form>
      {(displayed || loading || error) && (
        <section className='space-y-4 rounded-box bg-base-200 p-4' aria-label='検索結果'>
          <header className='grid grid-cols-[1fr_auto] items-center gap-3 sm:grid-cols-[1fr_auto_auto]'>
            <h2 className='text-lg font-semibold'>検索結果</h2>
            {displayed && (
              <>
                <select
                  className='select select-sm min-h-10 w-auto'
                  aria-label='並び順'
                  value={displayed.sort}
                  disabled={loading}
                  onChange={(event) => void search(displayed.input, event.target.value as MonitorCrawlResultSort, 1)}
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
          {hasDraftChanges && (
            <p className='text-sm text-base-content/70'>
              編集中の条件は未反映です。モニタリングの作成には表示中の検索条件を使います。
            </p>
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
                      <CrawlResultCard crawlResult={item} alignPrice />
                    </li>
                  ))}
                </ul>
              )}
              <ResultPagination
                label='検索結果のページ'
                page={displayed.results.page}
                hasMore={displayed.results.hasMore}
                disabled={loading}
                onChange={(page) => void search(displayed.input, displayed.sort, page)}
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
