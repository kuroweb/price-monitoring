import Link from 'next/link'

import Layout from '@/components/layouts/Layout'

export default function NotFound() {
  return (
    <Layout>
      <div className='card w-full bg-base-300'>
        <div className='card-body'>
          <h1 className='card-title'>ページが見つかりません</h1>
          <p>URLをご確認ください。</p>
          <Link href='/products' className='btn'>最安値一覧へ戻る</Link>
        </div>
      </div>
    </Layout>
  )
}
