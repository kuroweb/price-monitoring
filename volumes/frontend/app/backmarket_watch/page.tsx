import Layout from '@/components/layouts/Layout'
import BackmarketWatchResultsTable from '@/features/admin/backmarket-watch-targets/components/BackmarketWatchResultsTable'
import BackmarketWatchTargetsTable from '@/features/admin/backmarket-watch-targets/components/BackmarketWatchTargetsTable'
import { getBackmarketWatchResults, getBackmarketWatchTargets } from '@/lib/actions'

const Page = async () => {
  const backmarketWatchTargetResponse = await getBackmarketWatchTargets()
  const backmarketWatchResultsResponse = await getBackmarketWatchResults()

  return (
    <Layout>
      <div className='grid grid-cols-1 gap-4'>
        <div className='card w-full bg-neutral'>
          <div className='card-body'>
            <h2 className='card-title'>Backmarket監視設定</h2>
            <BackmarketWatchTargetsTable
              backmarketWatchTargets={backmarketWatchTargetResponse?.data?.backmarketWatchTargets || []}
            />
          </div>
        </div>
        <div className='card w-full bg-neutral'>
          <div className='card-body'>
            <h2 className='card-title'>計測結果</h2>
            <BackmarketWatchResultsTable
              backmarketWatchResults={backmarketWatchResultsResponse?.data?.backmarketWatchResults || []}
            />
          </div>
        </div>
      </div>
    </Layout>
  )
}

export default Page
