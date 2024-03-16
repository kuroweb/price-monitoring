'use server'

import { gql } from '@apollo/client'

import { Product } from '@/graphql/dist/client'
import { getClient } from '@/lib/rsc-client'

// TODO: ファイル構成は肥大化したときに改めて考える

/*
  MercariProductsTable
*/

export type mercariProductsTableResponse = {
  product: Pick<Product, 'mercariProducts'>
}

export const fetchMercariProductsTableData = async (id: string, published: Boolean) => {
  const Query = gql`
    query ($id: ID!, $published: Boolean) {
      product(id: $id) {
        mercariProducts(published: $published) {
          id
          productId
          mercariId
          name
          thumbnailUrl
          price
          published
        }
      }
    }
  `

  return await getClient().query<mercariProductsTableResponse>({
    query: Query,
    variables: { id, published },
  })
}
