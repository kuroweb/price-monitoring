'use client'

import { useQueryState } from 'nuqs'

const ConfigCard = () => {
  const [_, setModal] = useQueryState('create_crawl_setting_modal')

  return (
    <>
      <div className='flex justify-end'>
        <button onClick={() => setModal('open')} className='btn btn-neutral no-animation'>
          計測設定を追加
        </button>
      </div>
    </>
  )
}

export default ConfigCard
