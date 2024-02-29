'use client'

import { useEditCrawlSettingModal } from '../../hooks/useEditCrawlSettingModal'

const EditCrawlSettingModal = () => {
  const [modal, setModal] = useEditCrawlSettingModal()

  return (
    <>
      <input
        type='checkbox'
        className='modal-toggle'
        checked={modal}
        onChange={(e) => setModal(e.target.checked)}
      />
      <div className='modal' role='dialog'>
        <div className='modal-box h-3/4 md:h-1/2'>
          <div
            onClick={() => setModal(false)}
            className='btn btn-sm btn-circle btn-ghost absolute right-4 top-4'
          >
            ✕
          </div>
          <h3 className='font-bold text-lg'>計測設定を更新</h3>
        </div>
        <div onClick={() => setModal(false)} className='modal-backdrop' />
      </div>
    </>
  )
}

export default EditCrawlSettingModal
