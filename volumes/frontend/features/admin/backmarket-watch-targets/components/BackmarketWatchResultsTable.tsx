import Link from 'next/link'

import type { BackmarketWatchResultList } from '@/lib/api'

interface Props {
  backmarketWatchResults: BackmarketWatchResultList['backmarketWatchResults']
}

const BackmarketWatchResultsTable = ({ backmarketWatchResults }: Props) => {
  return (
    <div className='overflow-x-auto overflow-y-hidden'>
      <table className='table min-w-[980px]'>
        <thead>
          <tr>
            <th>監視設定</th>
            <th>商品名</th>
            <th>価格</th>
            <th>コンディション</th>
            <th>メモリ</th>
            <th>ストレージ</th>
            <th>CPU</th>
            <th>在庫</th>
            <th>取得日時</th>
          </tr>
        </thead>
        <tbody>
          {backmarketWatchResults.map((result) => (
            <tr key={result.backmarketWatchTargetId}>
              <td className='whitespace-normal break-words'>
                <Link
                  href={result.url}
                  target='_blank'
                  rel='noopener noreferrer'
                  className='link-hover link'
                >
                  {result.watchName}
                </Link>
              </td>
              <td className='whitespace-normal break-words'>{result.name}</td>
              <td>{result.price ?? '-'}</td>
              <td>{result.condition ?? '-'}</td>
              <td>{result.memory}</td>
              <td>{result.storage}</td>
              <td className='whitespace-normal break-words'>{result.cpu}</td>
              <td>{result.stockStatus === 'in_stock' ? '在庫あり' : '在庫切れ'}</td>
              <td className='whitespace-nowrap'>
                {new Date(result.crawledAt).toLocaleString('ja-JP')}
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}

export default BackmarketWatchResultsTable
