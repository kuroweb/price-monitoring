'use server'

import type {
  CreateYahooAuctionCrawlSettingExcludeProductInput,
  CreateYahooAuctionCrawlSettingExcludeProductMutation,
  UpdateYahooAuctionCrawlSettingExcludeProductInput,
  UpdateYahooAuctionCrawlSettingExcludeProductMutation,
  DeleteYahooAuctionCrawlSettingExcludeProductMutation,
  DeleteYahooAuctionCrawlSettingExcludeProductInput,
} from '@/graphql/dist/client'

import {
  CreateYahooAuctionCrawlSettingExcludeProductDocument,
  UpdateYahooAuctionCrawlSettingExcludeProductDocument,
  DeleteYahooAuctionCrawlSettingExcludeProductDocument,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'
import { revalidateAdminPaths, revalidateProductPaths } from '@/lib/revalidatePaths'

export const createYahooAuctionCrawlSettingExcludeProduct = async (
  input: CreateYahooAuctionCrawlSettingExcludeProductInput,
) => {
  const result = await getClient().mutate<CreateYahooAuctionCrawlSettingExcludeProductMutation>({
    mutation: CreateYahooAuctionCrawlSettingExcludeProductDocument,
    variables: { input },
  })
  revalidateAdminPaths()
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
  revalidateAdminPaths()
  revalidateProductPaths()

  return result
}

export const deleteYahooAuctionCrawlSettingExcludeProduct = async (
  input: DeleteYahooAuctionCrawlSettingExcludeProductInput,
) => {
  const result = getClient().mutate<DeleteYahooAuctionCrawlSettingExcludeProductMutation>({
    mutation: DeleteYahooAuctionCrawlSettingExcludeProductDocument,
    variables: { input },
  })
  revalidateAdminPaths()
  revalidateProductPaths()

  return result
}
