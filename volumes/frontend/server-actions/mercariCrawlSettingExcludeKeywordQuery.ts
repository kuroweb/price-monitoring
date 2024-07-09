'use server'

import type {
  CreateMercariCrawlSettingExcludeKeywordInput,
  CreateMercariCrawlSettingExcludeKeywordMutation,
  UpdateMercariCrawlSettingExcludeKeywordInput,
  UpdateMercariCrawlSettingExcludeKeywordMutation,
  DeleteMercariCrawlSettingExcludeKeywordMutation,
  DeleteMercariCrawlSettingExcludeKeywordInput,
} from '@/graphql/dist/client'

import {
  CreateMercariCrawlSettingExcludeKeywordDocument,
  UpdateMercariCrawlSettingExcludeKeywordDocument,
  DeleteMercariCrawlSettingExcludeKeywordDocument,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'
import { revalidateAdminProductPaths, revalidateRecommendPaths } from '@/lib/revalidatePaths'

export const createMercariCrawlSettingExcludeKeyword = async (
  input: CreateMercariCrawlSettingExcludeKeywordInput,
) => {
  const result = getClient().mutate<CreateMercariCrawlSettingExcludeKeywordMutation>({
    mutation: CreateMercariCrawlSettingExcludeKeywordDocument,
    variables: { input },
  })
  revalidateAdminProductPaths()
  revalidateRecommendPaths()

  return result
}

export const updateMercariCrawlSettingExcludeKeyword = async (
  input: UpdateMercariCrawlSettingExcludeKeywordInput,
) => {
  const result = getClient().mutate<UpdateMercariCrawlSettingExcludeKeywordMutation>({
    mutation: UpdateMercariCrawlSettingExcludeKeywordDocument,
    variables: { input },
  })
  revalidateAdminProductPaths()
  revalidateRecommendPaths()

  return result
}

export const deleteMercariCrawlSettingExcludeKeyword = async (
  input: DeleteMercariCrawlSettingExcludeKeywordInput,
) => {
  const result = getClient().mutate<DeleteMercariCrawlSettingExcludeKeywordMutation>({
    mutation: DeleteMercariCrawlSettingExcludeKeywordDocument,
    variables: { input },
  })
  revalidateAdminProductPaths()
  revalidateRecommendPaths()

  return result
}
