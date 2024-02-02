import Layout from '@/components/layouts/Layout'
import Breadcrumbs from '@/components/ui/Breadcrumbs'
import CreateForm from '@/features/products/components/CreateForm'
import ProductsTable from '@/features/products/components/ProductsTable'

const Page = async () => {
  return (
    <Layout>
      <Breadcrumbs text={'Create Form'} />
      <CreateForm />
      <Breadcrumbs text={'Products'} className='pt-4' />
      <ProductsTable />
    </Layout>
  )
}

export default Page
