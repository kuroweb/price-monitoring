'use client'

import { usePerState } from '../hooks/usePerState'
import { usePublishedState } from '../hooks/usePublishedState'

const SearchForm = () => {
  const [published, setPublished] = usePublishedState()
  const [per, setPer] = usePerState()

  const handlePublishedChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    setPublished(e.target.value === 'true')
  }

  const handlePerChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    setPer(Number(e.target.value))
  }

  return (
    <>
      <div className='space-x-4'>
        <select
          className='select select-bordered w-28'
          onChange={handlePublishedChange}
          value={published ? 'true' : 'false'}
        >
          <option value='true'>出品中</option>
          <option value='false'>売り切れ</option>
        </select>
        <select
          className='select select-bordered w-28'
          onChange={handlePerChange}
          value={per.toString()}
        >
          <option value='10'>10件</option>
          <option value='50'>50件</option>
          <option value='100'>100件</option>
        </select>
      </div>
    </>
  )
}

export default SearchForm
