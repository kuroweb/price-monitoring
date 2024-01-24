'use server'

import { getClient } from '@/lib/rsc-client'
import { CreateProductInput } from '@/graphql/dist/client'
import { CreateProductDocument, CreateProductMutation } from '@/graphql/dist/client'

export const createProduct = async (input: CreateProductInput) => {
  if (input.yahoo_auction_crawl_setting.category_id == 0) {
    delete input.yahoo_auction_crawl_setting.category_id
  }

  await getClient().mutate<CreateProductMutation>({
    mutation: CreateProductDocument,
    variables: { input: input },
  })
}

export const updateProduct = async (data: any) => {
  console.log(data)
}

export const destroyProduct = async (data: any) => {
  console.log(data)
}
