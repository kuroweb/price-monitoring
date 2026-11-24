import Layout from '@/components/layouts/Layout'
import CrawlResultSearch from '@/features/product-monitoring/components/CrawlResultSearch'

export default function Page() {
  return (
    <Layout>
      <div className='card w-full bg-base-300'>
        <div className='card-body gap-4 p-4 sm:p-6'>
          <CrawlResultSearch />
        </div>
      </div>
    </Layout>
  )
}
