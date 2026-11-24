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
  sort: MonitorCrawlResultSort
}

function extractionCriteria({ required, excluded, minPrice, maxPrice }: SearchInput): ExtractionCriteria {
  return { requiredKeywords: words(required), negativeKeywords: words(excluded), minPrice, maxPrice }
}

export default function CrawlResultSearch() {
  const [input, setInput] = useState<SearchInput>({
    required: '', excluded: '', minPrice: null, maxPrice: null, sort: 'newest',
  })
  const [displayed, setDisplayed] = useState<{ input: SearchInput; results: SearchCrawlResultsPage } | null>(null)
  const [creatingMonitor, setCreatingMonitor] = useState(false)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const inFlightRef = useRef(false)

  const change = (patch: Partial<SearchInput>) => setInput((value) => ({ ...value, ...patch }))

  const search = async (submitted: SearchInput, page: number) => {
    if (inFlightRef.current) return

    inFlightRef.current = true
    setLoading(true)
    setError('')
    try {
      const response = await searchCrawlResults({ ...extractionCriteria(submitted), sort: submitted.sort, page })
      if (response.data) {
        setDisplayed({ input: submitted, results: response.data })
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
      <form onSubmit={(event) => {
        event.preventDefault()
        void search(input, 1)
      }}>
        <fieldset disabled={loading} className='space-y-3'>
          <ExtractionCriteriaFields
            required={input.required}
            excluded={input.excluded}
            minPrice={input.minPrice}
            maxPrice={input.maxPrice}
            onRequiredChange={(required) => change({ required })}
            onExcludedChange={(excluded) => change({ excluded })}
            onPriceChange={change}
          />
          <div className='flex flex-wrap items-end gap-3'>
            <label>
              並び順
              <select
                className='select block w-auto'
                value={input.sort}
                onChange={(event) => change({ sort: event.target.value as MonitorCrawlResultSort })}
              >
                {SORTS.map(([value, label]) => <option key={value} value={value}>{label}</option>)}
              </select>
            </label>
            <button type='submit' className='btn btn-primary'>{loading ? '検索中…' : '検索'}</button>
          </div>
        </fieldset>
      </form>
      {error && <p role='alert' className='text-error'>{error}</p>}
      {!displayed && !error && !loading && <p>「検索」を押すと、保存済みの収集結果を表示します。</p>}
      {displayed && (
        <section className='space-y-3 pt-3' aria-label='検索結果' aria-busy={loading}>
          <div className='flex flex-wrap items-center justify-between gap-2'>
            <h2 className='text-lg font-semibold'>検索結果</h2>
            <button type='button' className='btn' disabled={loading} onClick={() => setCreatingMonitor(true)}>
              この条件でモニタリングを作成
            </button>
          </div>
          {displayed.input !== input && <p className='text-sm'>表示中の結果とモニタリング設定には、前回の検索条件が使われます。</p>}
          {displayed.results.crawlResults.length === 0 ? (
            <p>該当する収集結果はありません。</p>
          ) : (
            <div className='grid grid-cols-2 gap-3 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 2xl:grid-cols-8'>
              {displayed.results.crawlResults.map((item) => <CrawlResultCard key={item.id} crawlResult={item} />)}
            </div>
          )}
          <ResultPagination
            label='検索結果のページ'
            page={displayed.results.page}
            hasMore={displayed.results.hasMore}
            disabled={loading}
            onChange={(page) => void search(displayed.input, page)}
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
        </section>
      )}
    </>
  )
}
