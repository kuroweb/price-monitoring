'use client'

import { usePerState } from '../hooks/usePerState'
import { usePlatformMaskState } from '../hooks/usePlatformMaskState'
import { usePublishedState } from '../hooks/usePublishedState'
import { useYahooAuctionBuyableState } from '../hooks/useYahooAuctionBuyableState'

const SearchForm = () => {
  const [platformMask, setPlatformMask] = usePlatformMaskState()
  const [published, setPublished] = usePublishedState()
  const [yahooAuctionBuyable, setYahooAuctionBuyable] = useYahooAuctionBuyableState()
  const [per, setPer] = usePerState()

  const handlePlatformMaskChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    setPlatformMask(e.target.value)
  }

  const handlePublishedChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    setPublished(e.target.value === 'true')
  }

  const handleYahooAuctionBuyableChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    setYahooAuctionBuyable(e.target.value === 'true')
  }

  const handlePerChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    setPer(Number(e.target.value))
  }

  return (
    <>
      <div className='flex flex-wrap'>
        <label className='form-control w-32 pr-2'>
          <div className='label'>
            <span className='label-text'>プラットフォーム</span>
          </div>
          <select
            className='select select-bordered'
            onChange={handlePlatformMaskChange}
            value={platformMask}
          >
            <option value='yahoo_auction,yahoo_fleamarket,mercari,janpara'>すべて</option>
            <option value='yahoo_auction'>ヤフオク</option>
            <option value='yahoo_fleamarket'>ペイペイ</option>
            <option value='mercari'>メルカリ</option>
            <option value='janpara'>じゃんぱら</option>
          </select>
        </label>
        <label className='form-control w-32 pr-2'>
          <div className='label'>
            <span className='label-text'>ステータス</span>
          </div>
          <select
            className='select select-bordered'
            onChange={handlePublishedChange}
            value={published ? 'true' : 'false'}
          >
            <option value='true'>出品中</option>
            <option value='false'>売り切れ</option>
          </select>
        </label>
        {(platformMask == 'yahoo_auction,yahoo_fleamarket,mercari,janpara' ||
          platformMask == 'yahoo_auction') &&
          published && (
            <label className='form-control w-32 pr-2'>
              <div className='label'>
                <span className='label-text'>ヤフオク表示</span>
              </div>
              <select
                className='select select-bordered'
                onChange={handleYahooAuctionBuyableChange}
                value={yahooAuctionBuyable ? 'true' : 'false'}
              >
                <option value='true'>直近</option>
                <option value='false'>すべて</option>
              </select>
            </label>
          )}
        <label className='form-control w-32 pr-2'>
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
