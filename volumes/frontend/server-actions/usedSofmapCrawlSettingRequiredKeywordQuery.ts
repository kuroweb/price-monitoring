'use server'

import type {
  CreateUsedSofmapCrawlSettingRequiredKeywordInput,
  CreateUsedSofmapCrawlSettingRequiredKeywordMutation,
  UpdateUsedSofmapCrawlSettingRequiredKeywordInput,
  UpdateUsedSofmapCrawlSettingRequiredKeywordMutation,
  DeleteUsedSofmapCrawlSettingRequiredKeywordMutation,
  DeleteUsedSofmapCrawlSettingRequiredKeywordInput,
} from '@/graphql/dist/client'

import {
  CreateUsedSofmapCrawlSettingRequiredKeywordDocument,
  UpdateUsedSofmapCrawlSettingRequiredKeywordDocument,
  DeleteUsedSofmapCrawlSettingRequiredKeywordDocument,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'
import { revalidateAdminProductPaths, revalidateRecommendPaths } from '@/lib/revalidatePaths'

export const createUsedSofmapCrawlSettingRequiredKeyword = async (
  input: CreateUsedSofmapCrawlSettingRequiredKeywordInput,
) => {
  const result = getClient().mutate<CreateUsedSofmapCrawlSettingRequiredKeywordMutation>({
    mutation: CreateUsedSofmapCrawlSettingRequiredKeywordDocument,
    variables: { input },
  })
  revalidateAdminProductPaths()
  revalidateRecommendPaths()

  return result
}

export const updateUsedSofmapCrawlSettingRequiredKeyword = async (
  input: UpdateUsedSofmapCrawlSettingRequiredKeywordInput,
) => {
  const result = getClient().mutate<UpdateUsedSofmapCrawlSettingRequiredKeywordMutation>({
    mutation: UpdateUsedSofmapCrawlSettingRequiredKeywordDocument,
    variables: { input },
  })
  revalidateAdminProductPaths()
  revalidateRecommendPaths()

  return result
}

export const deleteUsedSofmapCrawlSettingRequiredKeyword = async (
  input: DeleteUsedSofmapCrawlSettingRequiredKeywordInput,
) => {
  const result = getClient().mutate<DeleteUsedSofmapCrawlSettingRequiredKeywordMutation>({
    mutation: DeleteUsedSofmapCrawlSettingRequiredKeywordDocument,
    variables: { input },
  })
  revalidateAdminProductPaths()
  revalidateRecommendPaths()

  return result
}
