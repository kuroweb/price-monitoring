'use server'

import { revalidatePath } from 'next/cache'

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
  pathname: string,
) => {
  const result = await getClient().mutate<CreateYahooAuctionCrawlSettingExcludeProductMutation>({
    mutation: CreateYahooAuctionCrawlSettingExcludeProductDocument,
    variables: { input },
  })
  revalidatePath(pathname)

  return result
}

export const updateYahooAuctionCrawlSettingExcludeProduct = async (
  input: UpdateYahooAuctionCrawlSettingExcludeProductInput,
  pathname: string,
) => {
  const result = getClient().mutate<UpdateYahooAuctionCrawlSettingExcludeProductMutation>({
    mutation: UpdateYahooAuctionCrawlSettingExcludeProductDocument,
    variables: { input },
  })
  revalidatePath(pathname)

  return result
}

export const deleteYahooAuctionCrawlSettingExcludeProduct = async (
  id: string,
  productId: string,
  pathname: string,
) => {
  const result = getClient().mutate<DeleteYahooAuctionCrawlSettingExcludeProductMutation>({
    mutation: DeleteYahooAuctionCrawlSettingExcludeProductDocument,
    variables: { id, productId },
  })
  revalidatePath(pathname)

  return result
}
