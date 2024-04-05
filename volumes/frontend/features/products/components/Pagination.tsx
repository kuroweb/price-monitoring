'use client'

import { usePageState } from '../hooks/usePageState'

const Pagination = () => {
  const [page, setPage] = usePageState()

  return (
    <>
      <div className='pt-6 flex justify-end'>
        <div className='join'>
          <button className='join-item btn' disabled={page <= 1} onClick={() => setPage(page - 1)}>
            «
          </button>
          <button className='join-item btn cursor-default no-animation'>Page {page}</button>
          <button className='join-item btn' onClick={() => setPage(page + 1)}>
            »
          </button>
        </div>
      </div>
    </>
  )
}

export default Pagination
