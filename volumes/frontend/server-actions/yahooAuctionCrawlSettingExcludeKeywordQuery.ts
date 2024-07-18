'use server'

import type {
  CreateYahooAuctionCrawlSettingExcludeKeywordInput,
  CreateYahooAuctionCrawlSettingExcludeKeywordMutation,
  UpdateYahooAuctionCrawlSettingExcludeKeywordInput,
  UpdateYahooAuctionCrawlSettingExcludeKeywordMutation,
  DeleteYahooAuctionCrawlSettingExcludeKeywordMutation,
  DeleteYahooAuctionCrawlSettingExcludeKeywordInput,
} from '@/graphql/dist/client'

import {
  CreateYahooAuctionCrawlSettingExcludeKeywordDocument,
  UpdateYahooAuctionCrawlSettingExcludeKeywordDocument,
  DeleteYahooAuctionCrawlSettingExcludeKeywordDocument,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'
import { revalidateAdminPaths, revalidateProductPaths } from '@/lib/revalidatePaths'

export const createYahooAuctionCrawlSettingExcludeKeyword = async (
  input: CreateYahooAuctionCrawlSettingExcludeKeywordInput,
) => {
  const result = getClient().mutate<CreateYahooAuctionCrawlSettingExcludeKeywordMutation>({
    mutation: CreateYahooAuctionCrawlSettingExcludeKeywordDocument,
    variables: { input },
  })
  revalidateAdminPaths()
  revalidateProductPaths()

  return result
}

export const updateYahooAuctionCrawlSettingExcludeKeyword = async (
  input: UpdateYahooAuctionCrawlSettingExcludeKeywordInput,
) => {
  const result = getClient().mutate<UpdateYahooAuctionCrawlSettingExcludeKeywordMutation>({
    mutation: UpdateYahooAuctionCrawlSettingExcludeKeywordDocument,
    variables: { input },
  })
  revalidateAdminPaths()
  revalidateProductPaths()

  return result
}

export const deleteYahooAuctionCrawlSettingExcludeKeyword = async (
  input: DeleteYahooAuctionCrawlSettingExcludeKeywordInput,
) => {
  const result = getClient().mutate<DeleteYahooAuctionCrawlSettingExcludeKeywordMutation>({
    mutation: DeleteYahooAuctionCrawlSettingExcludeKeywordDocument,
    variables: { input },
  })
  revalidateAdminPaths()
  revalidateProductPaths()

  return result
}
