import Layout from '@/components/layouts/Layout'
import CrawlResultSearch from '@/features/product-monitoring/components/CrawlResultSearch'

export default function Page() {
  return (
    <Layout>
      <div className='mx-auto w-full max-w-7xl space-y-6'>
        <CrawlResultSearch />
      </div>
    </Layout>
  )
}
