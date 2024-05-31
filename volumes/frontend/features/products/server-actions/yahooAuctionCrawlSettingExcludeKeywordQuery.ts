'use server'

import { revalidatePath } from 'next/cache'

import type {
  CreateYahooAuctionCrawlSettingExcludeKeywordInput,
  CreateYahooAuctionCrawlSettingExcludeKeywordMutation,
  UpdateYahooAuctionCrawlSettingExcludeKeywordInput,
  UpdateYahooAuctionCrawlSettingExcludeKeywordMutation,
  DeleteYahooAuctionCrawlSettingExcludeKeywordMutation,
} from '@/graphql/dist/client'

import {
  CreateYahooAuctionCrawlSettingExcludeKeywordDocument,
  UpdateYahooAuctionCrawlSettingExcludeKeywordDocument,
  DeleteYahooAuctionCrawlSettingExcludeKeywordDocument,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'

export const createYahooAuctionCrawlSettingExcludeKeyword = async (
  input: CreateYahooAuctionCrawlSettingExcludeKeywordInput,
  pathname: string,
) => {
  const result = getClient().mutate<CreateYahooAuctionCrawlSettingExcludeKeywordMutation>({
    mutation: CreateYahooAuctionCrawlSettingExcludeKeywordDocument,
    variables: { input },
  })
  revalidatePath(pathname)

  return result
}

export const updateYahooAuctionCrawlSettingExcludeKeyword = async (
  input: UpdateYahooAuctionCrawlSettingExcludeKeywordInput,
  pathname: string,
) => {
  const result = getClient().mutate<UpdateYahooAuctionCrawlSettingExcludeKeywordMutation>({
    mutation: UpdateYahooAuctionCrawlSettingExcludeKeywordDocument,
    variables: { input },
  })
  revalidatePath(pathname)

  return result
}

export const deleteYahooAuctionCrawlSettingExcludeKeyword = async (
  id: string,
  productId: string,
  pathname: string,
) => {
  const result = getClient().mutate<DeleteYahooAuctionCrawlSettingExcludeKeywordMutation>({
    mutation: DeleteYahooAuctionCrawlSettingExcludeKeywordDocument,
    variables: { id, productId },
  })
  revalidatePath(pathname)

  return result
}
