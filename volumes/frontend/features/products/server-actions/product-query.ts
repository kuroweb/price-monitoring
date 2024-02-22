'use server'

import {
  CreateProductInput,
  CreateProductDocument,
  CreateProductMutation,
  DeleteProductDocument,
  DeleteProductMutation,
  GetProductsDocument,
  GetProductsQuery,
  UpdateProductDocument,
  UpdateProductMutation,
  UpdateProductInput,
  CreateYahooAuctionCrawlSettingExcludeConditionDocument,
  CreateYahooAuctionCrawlSettingExcludeConditionInput,
  CreateYahooAuctionCrawlSettingExcludeConditionMutation,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/rsc-client'

/* Product */

export const getProducts = async () => {
  return await getClient().query<GetProductsQuery>({
    query: GetProductsDocument,
  })
}

export const createProduct = async (input: CreateProductInput) => {
  if (input.yahoo_auction_crawl_setting.category_id == 0) {
    delete input.yahoo_auction_crawl_setting.category_id
  }

  return await getClient().mutate<CreateProductMutation>({
    mutation: CreateProductDocument,
    variables: { input: input },
  })
}

export const updateProduct = async (id: String, input: UpdateProductInput) => {
  return await getClient().mutate<UpdateProductMutation>({
    mutation: UpdateProductDocument,
    variables: { id: id, input: input },
  })
}

export const deleteProduct = async (id: String) => {
  return await getClient().mutate<DeleteProductMutation>({
    mutation: DeleteProductDocument,
    variables: { id: id },
  })
}

/* YahooAuctionCrawlSettingExcludeCondition */

export const createYahooAuctionCrawlSettingExcludeCondition = async (
  input: CreateYahooAuctionCrawlSettingExcludeConditionInput,
) => {
  return await getClient().mutate<CreateYahooAuctionCrawlSettingExcludeConditionMutation>({
    mutation: CreateYahooAuctionCrawlSettingExcludeConditionDocument,
    variables: { input: input },
  })
}
