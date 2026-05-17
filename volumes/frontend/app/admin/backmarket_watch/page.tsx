import Layout from '@/components/layouts/Layout'
import BackmarketWatchTargetsTable from '@/features/admin/backmarket-watch-targets/components/BackmarketWatchTargetsTable'
import { getBackmarketWatchTargets } from '@/lib/actions'

const Page = async () => {
  const backmarketWatchTargetResponse = await getBackmarketWatchTargets()

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
      </div>
    </Layout>
  )
}

export default Page
