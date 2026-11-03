import Layout from '@/components/layouts/Layout'
import BackmarketRecentsTable from '@/features/backmarket-recents/components/BackmarketRecentsTable'
import EditWatchTargetButton from '@/features/backmarket-recents/components/EditWatchTargetButton'
import { getBackmarketRecents, getBackmarketWatchTargets } from '@/lib/actions'

const Page = async () => {
  const [backmarketRecentsResponse, backmarketWatchTargetResponse] = await Promise.all([
    getBackmarketRecents(),
    getBackmarketWatchTargets(),
  ])
  const backmarketRecentSections = backmarketRecentsResponse?.data?.backmarketRecentSections || []
  const backmarketWatchTargets = backmarketWatchTargetResponse?.data?.backmarketWatchTargets || []
  if (
    [backmarketRecentsResponse, backmarketWatchTargetResponse].some(
      (response) => response.status < 200 || response.status >= 300 || !response.data,
    )
  )
    throw new Error('Backmarket情報を取得できませんでした')

  return (
    <Layout>
      <div className='grid grid-cols-1 gap-4'>
        <div className='card w-full bg-base-300'>
          <div className='card-body'>
            <h2 className='card-title'>Backmarket 計測結果</h2>
            <div className='space-y-4 pt-6'>
              {backmarketRecentSections.length === 0 && (
                <p>計測結果はまだありません。管理画面で計測対象を追加してください。</p>
              )}
              {backmarketRecentSections.map((section, index) => {
                const target = backmarketWatchTargets.find(
                  (target) => target.id === section.backmarketWatchTargetId,
                )

                return (
                  <section key={section.backmarketWatchTargetId} className='space-y-3'>
                    <div className='flex items-center justify-between gap-4'>
                      <h3 className='text-lg font-semibold leading-tight'>{section.watchName}</h3>
                      {target && <EditWatchTargetButton target={target} />}
                    </div>
                    <BackmarketRecentsTable
                      backmarketRecents={section.results}
                      watchUrl={section.url}
                    />
                    {index < backmarketRecentSections.length - 1 && (
                      <div className='divider py-4' />
                    )}
                  </section>
                )
              })}
            </div>
          </div>
        </div>
      </div>
    </Layout>
  )
}

export default Page
