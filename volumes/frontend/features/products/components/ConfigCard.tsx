'use client'

import { useCreateCrawlSettingModal } from '../hooks/useCreateCrawlSettingModal'

const ConfigCard = () => {
  const [_, setModal] = useCreateCrawlSettingModal()

  return (
    <>
      <div className='flex justify-end'>
        <button onClick={() => setModal(true)} className='btn btn-neutral no-animation'>
          計測設定を追加
        </button>
      </div>
    </>
  )
}

export default ConfigCard
