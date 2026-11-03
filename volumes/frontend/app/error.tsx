'use client'

import Layout from '@/components/layouts/Layout'

export default function Error({ reset }: { reset: () => void }) {
  return (
    <Layout>
      <div className='card w-full bg-base-300'>
        <div className='card-body'>
          <h1 className='card-title'>ページの読み込みに失敗しました</h1>
          <button type='button' className='btn' onClick={reset}>再試行</button>
        </div>
      </div>
    </Layout>
  )
}
