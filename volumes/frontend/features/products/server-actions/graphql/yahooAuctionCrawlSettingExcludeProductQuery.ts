'use server'

import { revalidateProductPaths } from '../../lib/revalidatePaths'

import type {
  CreateYahooAuctionCrawlSettingExcludeProductInput,
  CreateYahooAuctionCrawlSettingExcludeProductMutation,
  UpdateYahooAuctionCrawlSettingExcludeProductInput,
  UpdateYahooAuctionCrawlSettingExcludeProductMutation,
  DeleteYahooAuctionCrawlSettingExcludeProductMutation,
} from '@/graphql/dist/client'

import {
  CreateYahooAuctionCrawlSettingExcludeProductDocument,
  UpdateYahooAuctionCrawlSettingExcludeProductDocument,
  DeleteYahooAuctionCrawlSettingExcludeProductDocument,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'

export const createYahooAuctionCrawlSettingExcludeProduct = async (
  input: CreateYahooAuctionCrawlSettingExcludeProductInput,
) => {
  const result = await getClient().mutate<CreateYahooAuctionCrawlSettingExcludeProductMutation>({
    mutation: CreateYahooAuctionCrawlSettingExcludeProductDocument,
    variables: { input },
  })
  revalidateProductPaths()

  return result
}

export const updateYahooAuctionCrawlSettingExcludeProduct = async (
  input: UpdateYahooAuctionCrawlSettingExcludeProductInput,
) => {
  const result = getClient().mutate<UpdateYahooAuctionCrawlSettingExcludeProductMutation>({
    mutation: UpdateYahooAuctionCrawlSettingExcludeProductDocument,
    variables: { input },
  })
  revalidateProductPaths()

  return result
}

export const deleteYahooAuctionCrawlSettingExcludeProduct = async (
  id: string,
  productId: string,
) => {
  const result = getClient().mutate<DeleteYahooAuctionCrawlSettingExcludeProductMutation>({
    mutation: DeleteYahooAuctionCrawlSettingExcludeProductDocument,
    variables: { id, productId },
  })
  revalidateProductPaths()

  return result
}
