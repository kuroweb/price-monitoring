'use server'

import type {
  CreateIosysCrawlSettingExcludeKeywordInput,
  CreateIosysCrawlSettingExcludeKeywordMutation,
  UpdateIosysCrawlSettingExcludeKeywordInput,
  UpdateIosysCrawlSettingExcludeKeywordMutation,
  DeleteIosysCrawlSettingExcludeKeywordMutation,
  DeleteIosysCrawlSettingExcludeKeywordInput,
} from '@/graphql/dist/client'

import {
  CreateIosysCrawlSettingExcludeKeywordDocument,
  UpdateIosysCrawlSettingExcludeKeywordDocument,
  DeleteIosysCrawlSettingExcludeKeywordDocument,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'
import {
  revalidateAdminProductPaths,
  revalidateRecommendPaths,
  revalidateProductPaths,
} from '@/lib/revalidatePaths'

export const createIosysCrawlSettingExcludeKeyword = async (
  input: CreateIosysCrawlSettingExcludeKeywordInput,
) => {
  const result = getClient().mutate<CreateIosysCrawlSettingExcludeKeywordMutation>({
    mutation: CreateIosysCrawlSettingExcludeKeywordDocument,
    variables: { input },
  })
  revalidateAdminProductPaths()
  revalidateProductPaths()
  revalidateRecommendPaths()

  return result
}

export const updateIosysCrawlSettingExcludeKeyword = async (
  input: UpdateIosysCrawlSettingExcludeKeywordInput,
) => {
  const result = getClient().mutate<UpdateIosysCrawlSettingExcludeKeywordMutation>({
    mutation: UpdateIosysCrawlSettingExcludeKeywordDocument,
    variables: { input },
  })
  revalidateAdminProductPaths()
  revalidateProductPaths()
  revalidateRecommendPaths()

  return result
}

export const deleteIosysCrawlSettingExcludeKeyword = async (
  input: DeleteIosysCrawlSettingExcludeKeywordInput,
) => {
  const result = getClient().mutate<DeleteIosysCrawlSettingExcludeKeywordMutation>({
    mutation: DeleteIosysCrawlSettingExcludeKeywordDocument,
    variables: { input },
  })
  revalidateAdminProductPaths()
  revalidateProductPaths()
  revalidateRecommendPaths()

  return result
}
