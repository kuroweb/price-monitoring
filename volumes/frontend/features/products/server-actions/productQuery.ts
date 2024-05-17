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
  CreateYahooAuctionCrawlSettingExcludeProductDocument,
  CreateYahooAuctionCrawlSettingExcludeProductInput,
  CreateYahooAuctionCrawlSettingExcludeProductMutation,
  DeleteYahooAuctionCrawlSettingExcludeProductMutation,
  DeleteYahooAuctionCrawlSettingExcludeProductDocument,
  UpdateYahooAuctionCrawlSettingExcludeProductInput,
  UpdateYahooAuctionCrawlSettingExcludeProductDocument,
  UpdateYahooAuctionCrawlSettingExcludeProductMutation,
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
  CreateMercariCrawlSettingExcludeProductInput,
  UpdateMercariCrawlSettingExcludeProductInput,
  CreateMercariCrawlSettingExcludeProductDocument,
  CreateMercariCrawlSettingExcludeProductMutation,
  DeleteMercariCrawlSettingExcludeProductDocument,
  DeleteMercariCrawlSettingExcludeProductMutation,
  UpdateMercariCrawlSettingExcludeProductDocument,
  UpdateMercariCrawlSettingExcludeProductMutation,
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
  CreateJanparaCrawlSettingExcludeProductInput,
  UpdateJanparaCrawlSettingExcludeProductInput,
  CreateJanparaCrawlSettingExcludeProductDocument,
  CreateJanparaCrawlSettingExcludeProductMutation,
  DeleteJanparaCrawlSettingExcludeProductDocument,
  DeleteJanparaCrawlSettingExcludeProductMutation,
  UpdateJanparaCrawlSettingExcludeProductDocument,
  UpdateJanparaCrawlSettingExcludeProductMutation,
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
  CreateIosysCrawlSettingExcludeProductInput,
  UpdateIosysCrawlSettingExcludeProductInput,
  CreateIosysCrawlSettingExcludeProductDocument,
  CreateIosysCrawlSettingExcludeProductMutation,
  DeleteIosysCrawlSettingExcludeProductDocument,
  DeleteIosysCrawlSettingExcludeProductMutation,
  UpdateIosysCrawlSettingExcludeProductDocument,
  UpdateIosysCrawlSettingExcludeProductMutation,
  CreateIosysCrawlSettingRequiredKeywordInput,
  CreateIosysCrawlSettingRequiredKeywordDocument,
  CreateIosysCrawlSettingRequiredKeywordMutation,
  DeleteIosysCrawlSettingRequiredKeywordDocument,
  DeleteIosysCrawlSettingRequiredKeywordMutation,
  UpdateIosysCrawlSettingRequiredKeywordDocument,
  UpdateIosysCrawlSettingRequiredKeywordInput,
  UpdateIosysCrawlSettingRequiredKeywordMutation,
  CreatePcKoubouCrawlSettingExcludeKeywordInput,
  UpdatePcKoubouCrawlSettingExcludeKeywordInput,
  CreatePcKoubouCrawlSettingExcludeKeywordDocument,
  CreatePcKoubouCrawlSettingExcludeKeywordMutation,
  DeletePcKoubouCrawlSettingExcludeKeywordDocument,
  DeletePcKoubouCrawlSettingExcludeKeywordMutation,
  UpdatePcKoubouCrawlSettingExcludeKeywordDocument,
  UpdatePcKoubouCrawlSettingExcludeKeywordMutation,
  CreatePcKoubouCrawlSettingExcludeProductInput,
  UpdatePcKoubouCrawlSettingExcludeProductInput,
  CreatePcKoubouCrawlSettingExcludeProductDocument,
  CreatePcKoubouCrawlSettingExcludeProductMutation,
  DeletePcKoubouCrawlSettingExcludeProductDocument,
  DeletePcKoubouCrawlSettingExcludeProductMutation,
  UpdatePcKoubouCrawlSettingExcludeProductDocument,
  UpdatePcKoubouCrawlSettingExcludeProductMutation,
  CreatePcKoubouCrawlSettingRequiredKeywordInput,
  CreatePcKoubouCrawlSettingRequiredKeywordDocument,
  CreatePcKoubouCrawlSettingRequiredKeywordMutation,
  DeletePcKoubouCrawlSettingRequiredKeywordDocument,
  DeletePcKoubouCrawlSettingRequiredKeywordMutation,
  UpdatePcKoubouCrawlSettingRequiredKeywordDocument,
  UpdatePcKoubouCrawlSettingRequiredKeywordInput,
  UpdatePcKoubouCrawlSettingRequiredKeywordMutation,
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

/* YahooAuctionCrawlSettingExcludeProduct */

export const createYahooAuctionCrawlSettingExcludeProduct = async (
  input: CreateYahooAuctionCrawlSettingExcludeProductInput,
) => {
  return await getClient().mutate<CreateYahooAuctionCrawlSettingExcludeProductMutation>({
    mutation: CreateYahooAuctionCrawlSettingExcludeProductDocument,
    variables: { input: input },
  })
}

export const updateYahooAuctionCrawlSettingExcludeProduct = async (
  input: UpdateYahooAuctionCrawlSettingExcludeProductInput,
) => {
  return await getClient().mutate<UpdateYahooAuctionCrawlSettingExcludeProductMutation>({
    mutation: UpdateYahooAuctionCrawlSettingExcludeProductDocument,
    variables: { input: input },
  })
}

export const deleteYahooAuctionCrawlSettingExcludeProduct = async (
  id: String,
  productId: String,
) => {
  return await getClient().mutate<DeleteYahooAuctionCrawlSettingExcludeProductMutation>({
    mutation: DeleteYahooAuctionCrawlSettingExcludeProductDocument,
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

/* MercariCrawlSettingExcludeProduct */

export const createMercariCrawlSettingExcludeProduct = async (
  input: CreateMercariCrawlSettingExcludeProductInput,
) => {
  return await getClient().mutate<CreateMercariCrawlSettingExcludeProductMutation>({
    mutation: CreateMercariCrawlSettingExcludeProductDocument,
    variables: { input: input },
  })
}

export const updateMercariCrawlSettingExcludeProduct = async (
  input: UpdateMercariCrawlSettingExcludeProductInput,
) => {
  return await getClient().mutate<UpdateMercariCrawlSettingExcludeProductMutation>({
    mutation: UpdateMercariCrawlSettingExcludeProductDocument,
    variables: { input: input },
  })
}

export const deleteMercariCrawlSettingExcludeProduct = async (id: String, productId: String) => {
  return await getClient().mutate<DeleteMercariCrawlSettingExcludeProductMutation>({
    mutation: DeleteMercariCrawlSettingExcludeProductDocument,
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

/* JanparaCrawlSettingExcludeProduct */

export const createJanparaCrawlSettingExcludeProduct = async (
  input: CreateJanparaCrawlSettingExcludeProductInput,
) => {
  return await getClient().mutate<CreateJanparaCrawlSettingExcludeProductMutation>({
    mutation: CreateJanparaCrawlSettingExcludeProductDocument,
    variables: { input: input },
  })
}

export const updateJanparaCrawlSettingExcludeProduct = async (
  input: UpdateJanparaCrawlSettingExcludeProductInput,
) => {
  return await getClient().mutate<UpdateJanparaCrawlSettingExcludeProductMutation>({
    mutation: UpdateJanparaCrawlSettingExcludeProductDocument,
    variables: { input: input },
  })
}

export const deleteJanparaCrawlSettingExcludeProduct = async (id: String, productId: String) => {
  return await getClient().mutate<DeleteJanparaCrawlSettingExcludeProductMutation>({
    mutation: DeleteJanparaCrawlSettingExcludeProductDocument,
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

/* IosysCrawlSettingExcludeProduct */

export const createIosysCrawlSettingExcludeProduct = async (
  input: CreateIosysCrawlSettingExcludeProductInput,
) => {
  return await getClient().mutate<CreateIosysCrawlSettingExcludeProductMutation>({
    mutation: CreateIosysCrawlSettingExcludeProductDocument,
    variables: { input: input },
  })
}

export const updateIosysCrawlSettingExcludeProduct = async (
  input: UpdateIosysCrawlSettingExcludeProductInput,
) => {
  return await getClient().mutate<UpdateIosysCrawlSettingExcludeProductMutation>({
    mutation: UpdateIosysCrawlSettingExcludeProductDocument,
    variables: { input: input },
  })
}

export const deleteIosysCrawlSettingExcludeProduct = async (id: String, productId: String) => {
  return await getClient().mutate<DeleteIosysCrawlSettingExcludeProductMutation>({
    mutation: DeleteIosysCrawlSettingExcludeProductDocument,
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

/*
  PcKoubou
*/

/* PcKoubouCrawlSettingExcludeKeyword */

export const createPcKoubouCrawlSettingExcludeKeyword = async (
  input: CreatePcKoubouCrawlSettingExcludeKeywordInput,
) => {
  return await getClient().mutate<CreatePcKoubouCrawlSettingExcludeKeywordMutation>({
    mutation: CreatePcKoubouCrawlSettingExcludeKeywordDocument,
    variables: { input: input },
  })
}

export const updatePcKoubouCrawlSettingExcludeKeyword = async (
  input: UpdatePcKoubouCrawlSettingExcludeKeywordInput,
) => {
  return await getClient().mutate<UpdatePcKoubouCrawlSettingExcludeKeywordMutation>({
    mutation: UpdatePcKoubouCrawlSettingExcludeKeywordDocument,
    variables: { input: input },
  })
}

export const deletePcKoubouCrawlSettingExcludeKeyword = async (id: String, productId: String) => {
  return await getClient().mutate<DeletePcKoubouCrawlSettingExcludeKeywordMutation>({
    mutation: DeletePcKoubouCrawlSettingExcludeKeywordDocument,
    variables: { id: id, productId: productId },
  })
}

/* PcKoubouCrawlSettingExcludeProduct */

export const createPcKoubouCrawlSettingExcludeProduct = async (
  input: CreatePcKoubouCrawlSettingExcludeProductInput,
) => {
  return await getClient().mutate<CreatePcKoubouCrawlSettingExcludeProductMutation>({
    mutation: CreatePcKoubouCrawlSettingExcludeProductDocument,
    variables: { input: input },
  })
}

export const updatePcKoubouCrawlSettingExcludeProduct = async (
  input: UpdatePcKoubouCrawlSettingExcludeProductInput,
) => {
  return await getClient().mutate<UpdatePcKoubouCrawlSettingExcludeProductMutation>({
    mutation: UpdatePcKoubouCrawlSettingExcludeProductDocument,
    variables: { input: input },
  })
}

export const deletePcKoubouCrawlSettingExcludeProduct = async (id: String, productId: String) => {
  return await getClient().mutate<DeletePcKoubouCrawlSettingExcludeProductMutation>({
    mutation: DeletePcKoubouCrawlSettingExcludeProductDocument,
    variables: { id: id, productId: productId },
  })
}

/* PcKoubouCrawlSettingRequiredKeyword */

export const createPcKoubouCrawlSettingRequiredKeyword = async (
  input: CreatePcKoubouCrawlSettingRequiredKeywordInput,
) => {
  return await getClient().mutate<CreatePcKoubouCrawlSettingRequiredKeywordMutation>({
    mutation: CreatePcKoubouCrawlSettingRequiredKeywordDocument,
    variables: { input: input },
  })
}

export const updatePcKoubouCrawlSettingRequiredKeyword = async (
  input: UpdatePcKoubouCrawlSettingRequiredKeywordInput,
) => {
  return await getClient().mutate<UpdatePcKoubouCrawlSettingRequiredKeywordMutation>({
    mutation: UpdatePcKoubouCrawlSettingRequiredKeywordDocument,
    variables: { input: input },
  })
}

export const deletePcKoubouCrawlSettingRequiredKeyword = async (id: String, productId: String) => {
  return await getClient().mutate<DeletePcKoubouCrawlSettingRequiredKeywordMutation>({
    mutation: DeletePcKoubouCrawlSettingRequiredKeywordDocument,
    variables: { id: id, productId: productId },
  })
}
