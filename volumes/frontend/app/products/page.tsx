'use client'

import { useQuery } from '@apollo/client'
import Layout from '@/components/layouts/Layout'

import { GetProductsDocument, GetProductsQuery } from '@/graphql/dist/client'

const Page = () => {
  const { data, loading, error } = useQuery<GetProductsQuery>(GetProductsDocument, { variables: { id: 2 } })

  if (loading) return <div>LOADING...</div>
  if (error) return <div>{error.message}</div>

  return (
    <Layout>
      <p>Products</p>
      {data?.products.map((product) => (
        <p key={product.id}>
          {product.id}, {product.user_id}, {product.name}, {product.price}
        </p>
      ))}
    </Layout>
  )
}

export default Page
