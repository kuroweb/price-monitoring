'use client'

import ProductsTable from './ProductsTable'

import { GetProductsQuery } from '@/graphql/dist/client'

const ProductsCard = ({ data }: { data: GetProductsQuery }) => {
  return (
    <>
      <div className='card w-full bg-neutral'>
        <div className='card-body'>
          <h2 className='card-title'>計測対象一覧</h2>
          <ProductsTable data={data} />
        </div>
      </div>
    </>
  )
}

export default ProductsCard
