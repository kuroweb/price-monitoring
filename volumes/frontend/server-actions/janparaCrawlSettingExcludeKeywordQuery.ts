'use server'

import type {
  CreateJanparaCrawlSettingExcludeKeywordInput,
  CreateJanparaCrawlSettingExcludeKeywordMutation,
  UpdateJanparaCrawlSettingExcludeKeywordInput,
  UpdateJanparaCrawlSettingExcludeKeywordMutation,
  DeleteJanparaCrawlSettingExcludeKeywordMutation,
  DeleteJanparaCrawlSettingExcludeKeywordInput,
} from '@/graphql/dist/client'

import {
  CreateJanparaCrawlSettingExcludeKeywordDocument,
  UpdateJanparaCrawlSettingExcludeKeywordDocument,
  DeleteJanparaCrawlSettingExcludeKeywordDocument,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'
import { revalidateAdminPaths, revalidateProductPaths } from '@/lib/revalidatePaths'

export const createJanparaCrawlSettingExcludeKeyword = async (
  input: CreateJanparaCrawlSettingExcludeKeywordInput,
) => {
  const result = getClient().mutate<CreateJanparaCrawlSettingExcludeKeywordMutation>({
    mutation: CreateJanparaCrawlSettingExcludeKeywordDocument,
    variables: { input },
  })
  revalidateAdminPaths()
  revalidateProductPaths()

  return result
}

export const updateJanparaCrawlSettingExcludeKeyword = async (
  input: UpdateJanparaCrawlSettingExcludeKeywordInput,
) => {
  const result = getClient().mutate<UpdateJanparaCrawlSettingExcludeKeywordMutation>({
    mutation: UpdateJanparaCrawlSettingExcludeKeywordDocument,
    variables: { input },
  })
  revalidateAdminPaths()
  revalidateProductPaths()

  return result
}

export const deleteJanparaCrawlSettingExcludeKeyword = async (
  input: DeleteJanparaCrawlSettingExcludeKeywordInput,
) => {
  const result = getClient().mutate<DeleteJanparaCrawlSettingExcludeKeywordMutation>({
    mutation: DeleteJanparaCrawlSettingExcludeKeywordDocument,
    variables: { input },
  })
  revalidateAdminPaths()
  revalidateProductPaths()

  return result
}
