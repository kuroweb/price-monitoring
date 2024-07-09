'use server'

import type {
  CreateYahooAuctionCrawlSettingRequiredKeywordInput,
  CreateYahooAuctionCrawlSettingRequiredKeywordMutation,
  UpdateYahooAuctionCrawlSettingRequiredKeywordInput,
  UpdateYahooAuctionCrawlSettingRequiredKeywordMutation,
  DeleteYahooAuctionCrawlSettingRequiredKeywordMutation,
  DeleteYahooAuctionCrawlSettingRequiredKeywordInput,
} from '@/graphql/dist/client'

import {
  CreateYahooAuctionCrawlSettingRequiredKeywordDocument,
  UpdateYahooAuctionCrawlSettingRequiredKeywordDocument,
  DeleteYahooAuctionCrawlSettingRequiredKeywordDocument,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'
import { revalidateAdminProductPaths, revalidateRecommendPaths } from '@/lib/revalidatePaths'

export const createYahooAuctionCrawlSettingRequiredKeyword = async (
  input: CreateYahooAuctionCrawlSettingRequiredKeywordInput,
) => {
  const result = getClient().mutate<CreateYahooAuctionCrawlSettingRequiredKeywordMutation>({
    mutation: CreateYahooAuctionCrawlSettingRequiredKeywordDocument,
    variables: { input },
  })
  revalidateAdminProductPaths()
  revalidateRecommendPaths()

  return result
}

export const updateYahooAuctionCrawlSettingRequiredKeyword = async (
  input: UpdateYahooAuctionCrawlSettingRequiredKeywordInput,
) => {
  const result = getClient().mutate<UpdateYahooAuctionCrawlSettingRequiredKeywordMutation>({
    mutation: UpdateYahooAuctionCrawlSettingRequiredKeywordDocument,
    variables: { input },
  })
  revalidateAdminProductPaths()
  revalidateRecommendPaths()

  return result
}

export const deleteYahooAuctionCrawlSettingRequiredKeyword = async (
  input: DeleteYahooAuctionCrawlSettingRequiredKeywordInput,
) => {
  const result = getClient().mutate<DeleteYahooAuctionCrawlSettingRequiredKeywordMutation>({
    mutation: DeleteYahooAuctionCrawlSettingRequiredKeywordDocument,
    variables: { input },
  })
  revalidateAdminProductPaths()
  revalidateRecommendPaths()

  return result
}
