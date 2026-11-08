'use client'

import { usePageState } from '../hooks/usePageState'

const Pagination = () => {
  const [page, setPage] = usePageState()

  return (
    <>
      <div className='flex justify-end pt-6'>
        <div className='join'>
          <button className='btn join-item' disabled={page <= 1} onClick={() => setPage(page - 1)}>
            «
          </button>
          <button className='btn join-item no-animation cursor-default'>Page {page}</button>
          <button className='btn join-item' onClick={() => setPage(page + 1)}>
            »
          </button>
        </div>
      </div>
    </>
  )
}

export default Pagination
