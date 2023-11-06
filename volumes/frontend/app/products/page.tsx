'use client'

import { useQuery } from '@apollo/client'
import Layout from '@/components/layouts/Layout'

import { GetProductsDocument, GetProductsQuery } from '@/graphql/dist/client'

const Page = () => {
  const { data, loading, error } = useQuery<GetProductsQuery>(GetProductsDocument, { variables: { user_id: 1 } })

  return (
    <Layout>
      {/* TODO: 別コンポーネントに切り出す */}
      <ol className="flex items-center whitespace-nowrap min-w-0" aria-label="Breadcrumb">
        <li className="text-sm text-gray-500">
          <div className="flex items-center">
            <span className="font-semibold">Products</span>
          </div>
        </li>
      </ol>
      {/* TODO: 別コンポーネントに切り出す */}
      {loading && (
        <div>Loading...</div>
      )}
      {/* TODO: 別コンポーネントに切り出す */}
      {error && (
        <div>{error.message}</div>
      )}
      {data?.getProducts.map((product) => (
        <p key={product.id}>
          {product.id}, {product.user_id}, {product.name}, {product.price}
        </p>
      ))}
    </Layout>
  )
}

export default Page
