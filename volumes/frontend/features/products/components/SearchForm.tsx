'use client'

import { usePerState } from '../hooks/usePerState'
import { usePlatformState } from '../hooks/usePlatformState'
import { useStatusState } from '../hooks/useStatusState'

const SearchForm = () => {
  const [platform, setPlatform] = usePlatformState()
  const [status, setStatus] = useStatusState()
  const [per, setPer] = usePerState()

  const handlePlatformChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    setPlatform(e.target.value)
  }

  const handlePublishedChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    setStatus(e.target.value)
  }

  const handlePerChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    setPer(Number(e.target.value))
  }

  return (
    <>
      <div className='flex flex-wrap'>
        <label className='form-control w-36 pr-2'>
          <div className='label'>
            <span className='label-text'>プラットフォーム</span>
          </div>
          <select
            className='select select-bordered'
            onChange={handlePlatformChange}
            value={platform}
          >
            <option value='all'>すべて</option>
            <option value='yahoo_auction'>ヤフオク</option>
            <option value='yahoo_fleamarket'>ペイペイ</option>
            <option value='mercari'>メルカリ</option>
            <option value='janpara'>じゃんぱら</option>
            <option value='iosys'>イオシス</option>
            <option value='pc_koubou'>パソコン工房</option>
          </select>
        </label>
        {['all', 'yahoo_auction', 'yahoo_fleamarket', 'mercari'].includes(platform) && (
          <label className='form-control w-36 pr-2'>
            <div className='label'>
              <span className='label-text'>ステータス</span>
            </div>
            <select
              className='select select-bordered'
              onChange={handlePublishedChange}
              value={status}
            >
              <option value='published'>出品中</option>
              <option value='unpublished'>売り切れ</option>
            </select>
          </label>
        )}
        <label className='form-control w-36 pr-2'>
          <div className='label'>
            <span className='label-text'>表示数</span>
          </div>
          <select
            className='select select-bordered'
            onChange={handlePerChange}
            value={per.toString()}
          >
            <option value='10'>10件</option>
            <option value='50'>50件</option>
            <option value='100'>100件</option>
          </select>
        </label>
      </div>
    </>
  )
}

export default SearchForm
