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
  CreateMercariCrawlSettingExcludeKeywordInput,
  UpdateMercariCrawlSettingExcludeKeywordInput,
  CreateMercariCrawlSettingExcludeKeywordDocument,
  CreateMercariCrawlSettingExcludeKeywordMutation,
  DeleteMercariCrawlSettingExcludeKeywordDocument,
  DeleteMercariCrawlSettingExcludeKeywordMutation,
  UpdateMercariCrawlSettingExcludeKeywordDocument,
  UpdateMercariCrawlSettingExcludeKeywordMutation,
  CreateYahooAuctionCrawlSettingRequiredKeywordDocument,
  CreateYahooAuctionCrawlSettingRequiredKeywordInput,
  CreateYahooAuctionCrawlSettingRequiredKeywordMutation,
  DeleteYahooAuctionCrawlSettingRequiredKeywordDocument,
  DeleteYahooAuctionCrawlSettingRequiredKeywordMutation,
  UpdateYahooAuctionCrawlSettingRequiredKeywordDocument,
  UpdateYahooAuctionCrawlSettingRequiredKeywordInput,
  UpdateYahooAuctionCrawlSettingRequiredKeywordMutation,
  CreateMercariCrawlSettingRequiredKeywordInput,
  CreateMercariCrawlSettingRequiredKeywordDocument,
  CreateMercariCrawlSettingRequiredKeywordMutation,
  DeleteMercariCrawlSettingRequiredKeywordDocument,
  DeleteMercariCrawlSettingRequiredKeywordMutation,
  UpdateMercariCrawlSettingRequiredKeywordDocument,
  UpdateMercariCrawlSettingRequiredKeywordInput,
  UpdateMercariCrawlSettingRequiredKeywordMutation,
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

/* YahooAuctionCrawlSettingRequiredKeyword */

export const createYahooAuctionCrawlSettingRequiredKeyword = async (
  input: CreateYahooAuctionCrawlSettingRequiredKeywordInput,
) => {
  return await getClient().mutate<CreateYahooAuctionCrawlSettingRequiredKeywordMutation>({
    mutation: CreateYahooAuctionCrawlSettingRequiredKeywordDocument,
    variables: { input: input },
  })
}

export const updateYahooAuctionCrawlSettingRequiredKeyword = async (
  input: UpdateYahooAuctionCrawlSettingRequiredKeywordInput,
) => {
  return await getClient().mutate<UpdateYahooAuctionCrawlSettingRequiredKeywordMutation>({
    mutation: UpdateYahooAuctionCrawlSettingRequiredKeywordDocument,
    variables: { input: input },
  })
}

export const deleteYahooAuctionCrawlSettingRequiredKeyword = async (
  id: String,
  productId: String,
) => {
  return await getClient().mutate<DeleteYahooAuctionCrawlSettingRequiredKeywordMutation>({
    mutation: DeleteYahooAuctionCrawlSettingRequiredKeywordDocument,
    variables: { id: id, productId: productId },
  })
}

/* MercariCrawlSettingExcludeKeyword */

export const createMercariCrawlSettingExcludeKeyword = async (
  input: CreateMercariCrawlSettingExcludeKeywordInput,
) => {
  return await getClient().mutate<CreateMercariCrawlSettingExcludeKeywordMutation>({
    mutation: CreateMercariCrawlSettingExcludeKeywordDocument,
    variables: { input: input },
  })
}

export const updateMercariCrawlSettingExcludeKeyword = async (
  input: UpdateMercariCrawlSettingExcludeKeywordInput,
) => {
  return await getClient().mutate<UpdateMercariCrawlSettingExcludeKeywordMutation>({
    mutation: UpdateMercariCrawlSettingExcludeKeywordDocument,
    variables: { input: input },
  })
}

export const deleteMercariCrawlSettingExcludeKeyword = async (id: String, productId: String) => {
  return await getClient().mutate<DeleteMercariCrawlSettingExcludeKeywordMutation>({
    mutation: DeleteMercariCrawlSettingExcludeKeywordDocument,
    variables: { id: id, productId: productId },
  })
}

/* MercariCrawlSettingRequiredKeyword */

export const createMercariCrawlSettingRequiredKeyword = async (
  input: CreateMercariCrawlSettingRequiredKeywordInput,
) => {
  return await getClient().mutate<CreateMercariCrawlSettingRequiredKeywordMutation>({
    mutation: CreateMercariCrawlSettingRequiredKeywordDocument,
    variables: { input: input },
  })
}

export const updateMercariCrawlSettingRequiredKeyword = async (
  input: UpdateMercariCrawlSettingRequiredKeywordInput,
) => {
  return await getClient().mutate<UpdateMercariCrawlSettingRequiredKeywordMutation>({
    mutation: UpdateMercariCrawlSettingRequiredKeywordDocument,
    variables: { input: input },
  })
}

export const deleteMercariCrawlSettingRequiredKeyword = async (id: String, productId: String) => {
  return await getClient().mutate<DeleteMercariCrawlSettingRequiredKeywordMutation>({
    mutation: DeleteMercariCrawlSettingRequiredKeywordDocument,
    variables: { id: id, productId: productId },
  })
}
