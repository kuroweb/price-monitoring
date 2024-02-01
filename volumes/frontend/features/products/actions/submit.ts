'use server'

import {
  CreateProductInput,
  CreateProductDocument,
  CreateProductMutation,
  DeleteProductDocument,
  DeleteProductMutation,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/rsc-client'

export const createProduct = async (input: CreateProductInput) => {
  if (input.yahoo_auction_crawl_setting.category_id == 0) {
    delete input.yahoo_auction_crawl_setting.category_id
  }

  return await getClient().mutate<CreateProductMutation>({
    mutation: CreateProductDocument,
    variables: { input: input },
  })
}

export const updateProduct = async (data: any) => {
  console.log(data)
}

export const deleteProduct = async (id: String) => {
  return await getClient().mutate<DeleteProductMutation>({
    mutation: DeleteProductDocument,
    variables: { id: id },
  })
}
