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
  CreateYahooAuctionCrawlSettingRequiredKeywordDocument,
  CreateYahooAuctionCrawlSettingRequiredKeywordInput,
  CreateYahooAuctionCrawlSettingRequiredKeywordMutation,
  DeleteYahooAuctionCrawlSettingRequiredKeywordDocument,
  DeleteYahooAuctionCrawlSettingRequiredKeywordMutation,
  UpdateYahooAuctionCrawlSettingRequiredKeywordDocument,
  UpdateYahooAuctionCrawlSettingRequiredKeywordInput,
  UpdateYahooAuctionCrawlSettingRequiredKeywordMutation,
  CreateMercariCrawlSettingExcludeKeywordInput,
  UpdateMercariCrawlSettingExcludeKeywordInput,
  CreateMercariCrawlSettingExcludeKeywordDocument,
  CreateMercariCrawlSettingExcludeKeywordMutation,
  DeleteMercariCrawlSettingExcludeKeywordDocument,
  DeleteMercariCrawlSettingExcludeKeywordMutation,
  UpdateMercariCrawlSettingExcludeKeywordDocument,
  UpdateMercariCrawlSettingExcludeKeywordMutation,
  CreateMercariCrawlSettingRequiredKeywordInput,
  CreateMercariCrawlSettingRequiredKeywordDocument,
  CreateMercariCrawlSettingRequiredKeywordMutation,
  DeleteMercariCrawlSettingRequiredKeywordDocument,
  DeleteMercariCrawlSettingRequiredKeywordMutation,
  UpdateMercariCrawlSettingRequiredKeywordDocument,
  UpdateMercariCrawlSettingRequiredKeywordInput,
  UpdateMercariCrawlSettingRequiredKeywordMutation,
  CreateJanparaCrawlSettingExcludeKeywordInput,
  UpdateJanparaCrawlSettingExcludeKeywordInput,
  CreateJanparaCrawlSettingExcludeKeywordDocument,
  CreateJanparaCrawlSettingExcludeKeywordMutation,
  DeleteJanparaCrawlSettingExcludeKeywordDocument,
  DeleteJanparaCrawlSettingExcludeKeywordMutation,
  UpdateJanparaCrawlSettingExcludeKeywordDocument,
  UpdateJanparaCrawlSettingExcludeKeywordMutation,
  CreateJanparaCrawlSettingRequiredKeywordInput,
  CreateJanparaCrawlSettingRequiredKeywordDocument,
  CreateJanparaCrawlSettingRequiredKeywordMutation,
  DeleteJanparaCrawlSettingRequiredKeywordDocument,
  DeleteJanparaCrawlSettingRequiredKeywordMutation,
  UpdateJanparaCrawlSettingRequiredKeywordDocument,
  UpdateJanparaCrawlSettingRequiredKeywordInput,
  UpdateJanparaCrawlSettingRequiredKeywordMutation,
  CreateIosysCrawlSettingExcludeKeywordInput,
  UpdateIosysCrawlSettingExcludeKeywordInput,
  CreateIosysCrawlSettingExcludeKeywordDocument,
  CreateIosysCrawlSettingExcludeKeywordMutation,
  DeleteIosysCrawlSettingExcludeKeywordDocument,
  DeleteIosysCrawlSettingExcludeKeywordMutation,
  UpdateIosysCrawlSettingExcludeKeywordDocument,
  UpdateIosysCrawlSettingExcludeKeywordMutation,
  CreateIosysCrawlSettingRequiredKeywordInput,
  CreateIosysCrawlSettingRequiredKeywordDocument,
  CreateIosysCrawlSettingRequiredKeywordMutation,
  DeleteIosysCrawlSettingRequiredKeywordDocument,
  DeleteIosysCrawlSettingRequiredKeywordMutation,
  UpdateIosysCrawlSettingRequiredKeywordDocument,
  UpdateIosysCrawlSettingRequiredKeywordInput,
  UpdateIosysCrawlSettingRequiredKeywordMutation,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/rsc-client'

/*
  Product
*/

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

/*
  YahooAuction
*/

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

/*
  Mercari
*/

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

/*
  Janpara
*/

/* JanparaCrawlSettingExcludeKeyword */

export const createJanparaCrawlSettingExcludeKeyword = async (
  input: CreateJanparaCrawlSettingExcludeKeywordInput,
) => {
  return await getClient().mutate<CreateJanparaCrawlSettingExcludeKeywordMutation>({
    mutation: CreateJanparaCrawlSettingExcludeKeywordDocument,
    variables: { input: input },
  })
}

export const updateJanparaCrawlSettingExcludeKeyword = async (
  input: UpdateJanparaCrawlSettingExcludeKeywordInput,
) => {
  return await getClient().mutate<UpdateJanparaCrawlSettingExcludeKeywordMutation>({
    mutation: UpdateJanparaCrawlSettingExcludeKeywordDocument,
    variables: { input: input },
  })
}

export const deleteJanparaCrawlSettingExcludeKeyword = async (id: String, productId: String) => {
  return await getClient().mutate<DeleteJanparaCrawlSettingExcludeKeywordMutation>({
    mutation: DeleteJanparaCrawlSettingExcludeKeywordDocument,
    variables: { id: id, productId: productId },
  })
}

/* JanparaCrawlSettingRequiredKeyword */

export const createJanparaCrawlSettingRequiredKeyword = async (
  input: CreateJanparaCrawlSettingRequiredKeywordInput,
) => {
  return await getClient().mutate<CreateJanparaCrawlSettingRequiredKeywordMutation>({
    mutation: CreateJanparaCrawlSettingRequiredKeywordDocument,
    variables: { input: input },
  })
}

export const updateJanparaCrawlSettingRequiredKeyword = async (
  input: UpdateJanparaCrawlSettingRequiredKeywordInput,
) => {
  return await getClient().mutate<UpdateJanparaCrawlSettingRequiredKeywordMutation>({
    mutation: UpdateJanparaCrawlSettingRequiredKeywordDocument,
    variables: { input: input },
  })
}

export const deleteJanparaCrawlSettingRequiredKeyword = async (id: String, productId: String) => {
  return await getClient().mutate<DeleteJanparaCrawlSettingRequiredKeywordMutation>({
    mutation: DeleteJanparaCrawlSettingRequiredKeywordDocument,
    variables: { id: id, productId: productId },
  })
}

/*
  Iosys
*/

/* IosysCrawlSettingExcludeKeyword */

export const createIosysCrawlSettingExcludeKeyword = async (
  input: CreateIosysCrawlSettingExcludeKeywordInput,
) => {
  return await getClient().mutate<CreateIosysCrawlSettingExcludeKeywordMutation>({
    mutation: CreateIosysCrawlSettingExcludeKeywordDocument,
    variables: { input: input },
  })
}

export const updateIosysCrawlSettingExcludeKeyword = async (
  input: UpdateIosysCrawlSettingExcludeKeywordInput,
) => {
  return await getClient().mutate<UpdateIosysCrawlSettingExcludeKeywordMutation>({
    mutation: UpdateIosysCrawlSettingExcludeKeywordDocument,
    variables: { input: input },
  })
}

export const deleteIosysCrawlSettingExcludeKeyword = async (id: String, productId: String) => {
  return await getClient().mutate<DeleteIosysCrawlSettingExcludeKeywordMutation>({
    mutation: DeleteIosysCrawlSettingExcludeKeywordDocument,
    variables: { id: id, productId: productId },
  })
}

/* IosysCrawlSettingRequiredKeyword */

export const createIosysCrawlSettingRequiredKeyword = async (
  input: CreateIosysCrawlSettingRequiredKeywordInput,
) => {
  return await getClient().mutate<CreateIosysCrawlSettingRequiredKeywordMutation>({
    mutation: CreateIosysCrawlSettingRequiredKeywordDocument,
    variables: { input: input },
  })
}

export const updateIosysCrawlSettingRequiredKeyword = async (
  input: UpdateIosysCrawlSettingRequiredKeywordInput,
) => {
  return await getClient().mutate<UpdateIosysCrawlSettingRequiredKeywordMutation>({
    mutation: UpdateIosysCrawlSettingRequiredKeywordDocument,
    variables: { input: input },
  })
}

export const deleteIosysCrawlSettingRequiredKeyword = async (id: String, productId: String) => {
  return await getClient().mutate<DeleteIosysCrawlSettingRequiredKeywordMutation>({
    mutation: DeleteIosysCrawlSettingRequiredKeywordDocument,
    variables: { id: id, productId: productId },
  })
}
