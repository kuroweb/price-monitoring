import Layout from '@/components/layouts/Layout'
import BackmarketWatchTargetsTable from '@/features/backmarket/components/BackmarketWatchTargetsTable'
import { getBackmarketWatchTargets } from '@/lib/actions'

const Page = async () => {
  const backmarketWatchTargetResponse = await getBackmarketWatchTargets()
  if (
    backmarketWatchTargetResponse.status < 200 ||
    backmarketWatchTargetResponse.status >= 300 ||
    !backmarketWatchTargetResponse.data
  )
    throw new Error('計測対象を取得できませんでした')

  return (
    <Layout>
      <div className='grid grid-cols-1 gap-4'>
        <div className='card w-full bg-base-300'>
          <div className='card-body'>
            <h2 className='card-title'>Backmarket 計測対象の管理</h2>
            <BackmarketWatchTargetsTable
              backmarketWatchTargets={
                backmarketWatchTargetResponse.data.backmarketWatchTargets ?? []
              }
            />
          </div>
        </div>
      </div>
    </Layout>
  )
}

export default Page
