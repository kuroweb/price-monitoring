'use server'

import { revalidatePath } from 'next/cache'

import type {
  CreateMercariCrawlSettingExcludeKeywordInput,
  CreateMercariCrawlSettingExcludeKeywordMutation,
  UpdateMercariCrawlSettingExcludeKeywordInput,
  UpdateMercariCrawlSettingExcludeKeywordMutation,
  DeleteMercariCrawlSettingExcludeKeywordMutation,
} from '@/graphql/dist/client'

import {
  CreateMercariCrawlSettingExcludeKeywordDocument,
  UpdateMercariCrawlSettingExcludeKeywordDocument,
  DeleteMercariCrawlSettingExcludeKeywordDocument,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'

export const createMercariCrawlSettingExcludeKeyword = async (
  input: CreateMercariCrawlSettingExcludeKeywordInput,
  pathname: string,
) => {
  const result = getClient().mutate<CreateMercariCrawlSettingExcludeKeywordMutation>({
    mutation: CreateMercariCrawlSettingExcludeKeywordDocument,
    variables: { input },
  })
  revalidatePath(pathname)

  return result
}

export const updateMercariCrawlSettingExcludeKeyword = async (
  input: UpdateMercariCrawlSettingExcludeKeywordInput,
  pathname: string,
) => {
  const result = getClient().mutate<UpdateMercariCrawlSettingExcludeKeywordMutation>({
    mutation: UpdateMercariCrawlSettingExcludeKeywordDocument,
    variables: { input },
  })
  revalidatePath(pathname)

  return result
}

export const deleteMercariCrawlSettingExcludeKeyword = async (
  id: string,
  productId: string,
  pathname: string,
) => {
  const result = getClient().mutate<DeleteMercariCrawlSettingExcludeKeywordMutation>({
    mutation: DeleteMercariCrawlSettingExcludeKeywordDocument,
    variables: { id, productId },
  })
  revalidatePath(pathname)

  return result
}
