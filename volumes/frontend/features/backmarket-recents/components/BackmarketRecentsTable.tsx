import Link from 'next/link'

import type { BackmarketRecent } from '@/lib/api'

interface Props {
  backmarketRecents: BackmarketRecent[]
  watchUrl: string
}

const BackmarketRecentsTable = ({ backmarketRecents, watchUrl }: Props) => {
  return (
    <div className='overflow-x-auto overflow-y-hidden'>
      <table className='table min-w-[980px]'>
        <thead>
          <tr>
            <th>商品名</th>
            <th>価格</th>
            <th>メモリ</th>
            <th>ストレージ</th>
            <th>CPU</th>
            <th>コンディション</th>
            <th>在庫</th>
            <th>取得日時</th>
          </tr>
        </thead>
        <tbody>
          {backmarketRecents.map((result) => (
            <tr key={`${result.name}-${result.crawledAt}`}>
              <td className='whitespace-normal break-words'>
                <Link
                  href={watchUrl}
                  target='_blank'
                  rel='noopener noreferrer'
                  className='link-hover link'
                >
                  {result.name}
                </Link>
              </td>
              <td>{result.price ?? '-'}</td>
              <td>{result.memory ?? '-'}</td>
              <td>{result.storage ?? '-'}</td>
              <td className='whitespace-normal break-words'>{result.cpu ?? '-'}</td>
              <td>{result.condition ?? '-'}</td>
              <td>{result.stockStatus === 'in_stock' ? '在庫あり' : '在庫切れ'}</td>
              <td className='whitespace-nowrap'>
                {new Date(result.crawledAt).toLocaleString('ja-JP', { timeZone: 'Asia/Tokyo' })}
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}

export default BackmarketRecentsTable
