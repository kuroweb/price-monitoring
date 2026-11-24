import Layout from '@/components/layouts/Layout'
import CrawlResultSearch from '@/features/product-monitoring/components/CrawlResultSearch'

export default function Page() {
  return (
    <Layout>
      <div className='card w-full bg-base-300'>
        <div className='card-body'>
          <CrawlResultSearch />
        </div>
      </div>
    </Layout>
  )
}
