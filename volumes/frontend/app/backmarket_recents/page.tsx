import Layout from '@/components/layouts/Layout'
import BackmarketRecentsTable from '@/features/backmarket-recents/components/BackmarketRecentsTable'
import { getBackmarketRecents } from '@/lib/actions'

const Page = async () => {
  const backmarketRecentsResponse = await getBackmarketRecents()
  const backmarketRecentSections = backmarketRecentsResponse?.data?.backmarketRecentSections || []

  return (
    <Layout>
      <div className='grid grid-cols-1 gap-4'>
        <div className='card w-full bg-neutral'>
          <div className='card-body'>
            <h2 className='card-title'>Backmarket計測結果</h2>
            <div className='space-y-4 pt-6'>
              {backmarketRecentSections.map((section, index) => (
                <section key={section.backmarketWatchTargetId} className='space-y-3'>
                  <h3 className='text-lg font-semibold leading-tight'>{section.watchName}</h3>
                  <BackmarketRecentsTable
                    backmarketRecents={section.results}
                    watchUrl={section.url}
                  />
                  {index < backmarketRecentSections.length - 1 && <div className='divider py-4' />}
                </section>
              ))}
            </div>
          </div>
        </div>
      </div>
    </Layout>
  )
}

export default Page
