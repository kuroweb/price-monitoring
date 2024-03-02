'use server'

import {
  CreateProductInput,
  CreateProductDocument,
  CreateProductMutation,
  DeleteProductDocument,
  DeleteProductMutation,
  UpdateProductDocument,
  UpdateProductMutation,
  UpdateProductInput,
  CreateYahooAuctionCrawlSettingExcludeKeywordDocument,
  CreateYahooAuctionCrawlSettingExcludeKeywordInput,
  CreateYahooAuctionCrawlSettingExcludeKeywordMutation,
  DeleteYahooAuctionCrawlSettingExcludeKeywordMutation,
  DeleteYahooAuctionCrawlSettingExcludeKeywordDocument,
  UpdateYahooAuctionCrawlSettingExcludeKeywordInput,
  UpdateYahooAuctionCrawlSettingExcludeKeywordDocument,
  UpdateYahooAuctionCrawlSettingExcludeKeywordMutation,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/rsc-client'

/* Product */

export const createProduct = async (input: CreateProductInput) => {
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

/* YahooAuctionCrawlSettingExcludeKeyword */

export const createYahooAuctionCrawlSettingExcludeKeyword = async (
  input: CreateYahooAuctionCrawlSettingExcludeKeywordInput,
) => {
  return await getClient().mutate<CreateYahooAuctionCrawlSettingExcludeKeywordMutation>({
    mutation: CreateYahooAuctionCrawlSettingExcludeKeywordDocument,
    variables: { input: input },
  })
}

export const updateYahooAuctionCrawlSettingExcludeKeyword = async (
  input: UpdateYahooAuctionCrawlSettingExcludeKeywordInput,
) => {
  return await getClient().mutate<UpdateYahooAuctionCrawlSettingExcludeKeywordMutation>({
    mutation: UpdateYahooAuctionCrawlSettingExcludeKeywordDocument,
    variables: { input: input },
  })
}

export const deleteYahooAuctionCrawlSettingExcludeKeyword = async (
  id: String,
  productId: String,
) => {
  return await getClient().mutate<DeleteYahooAuctionCrawlSettingExcludeKeywordMutation>({
    mutation: DeleteYahooAuctionCrawlSettingExcludeKeywordDocument,
    variables: { id: id, productId: productId },
  })
}
