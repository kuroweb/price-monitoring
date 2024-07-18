'use server'

import type {
  CreateJanparaCrawlSettingRequiredKeywordInput,
  CreateJanparaCrawlSettingRequiredKeywordMutation,
  UpdateJanparaCrawlSettingRequiredKeywordInput,
  UpdateJanparaCrawlSettingRequiredKeywordMutation,
  DeleteJanparaCrawlSettingRequiredKeywordMutation,
  DeleteJanparaCrawlSettingRequiredKeywordInput,
} from '@/graphql/dist/client'

import {
  CreateJanparaCrawlSettingRequiredKeywordDocument,
  UpdateJanparaCrawlSettingRequiredKeywordDocument,
  DeleteJanparaCrawlSettingRequiredKeywordDocument,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'
import {
  revalidateAdminProductPaths,
  revalidateRecommendPaths,
  revalidateProductPaths,
} from '@/lib/revalidatePaths'

export const createJanparaCrawlSettingRequiredKeyword = async (
  input: CreateJanparaCrawlSettingRequiredKeywordInput,
) => {
  const result = getClient().mutate<CreateJanparaCrawlSettingRequiredKeywordMutation>({
    mutation: CreateJanparaCrawlSettingRequiredKeywordDocument,
    variables: { input },
  })
  revalidateAdminProductPaths()
  revalidateProductPaths()
  revalidateRecommendPaths()

  return result
}

export const updateJanparaCrawlSettingRequiredKeyword = async (
  input: UpdateJanparaCrawlSettingRequiredKeywordInput,
) => {
  const result = getClient().mutate<UpdateJanparaCrawlSettingRequiredKeywordMutation>({
    mutation: UpdateJanparaCrawlSettingRequiredKeywordDocument,
    variables: { input },
  })
  revalidateAdminProductPaths()
  revalidateProductPaths()
  revalidateRecommendPaths()

  return result
}

export const deleteJanparaCrawlSettingRequiredKeyword = async (
  input: DeleteJanparaCrawlSettingRequiredKeywordInput,
) => {
  const result = getClient().mutate<DeleteJanparaCrawlSettingRequiredKeywordMutation>({
    mutation: DeleteJanparaCrawlSettingRequiredKeywordDocument,
    variables: { input },
  })
  revalidateAdminProductPaths()
  revalidateProductPaths()
  revalidateRecommendPaths()

  return result
}
