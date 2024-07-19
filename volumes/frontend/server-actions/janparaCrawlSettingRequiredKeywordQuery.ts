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
import { revalidateAdminPaths, revalidateProductsPaths } from '@/lib/revalidate-paths'

export const createJanparaCrawlSettingRequiredKeyword = async (
  input: CreateJanparaCrawlSettingRequiredKeywordInput,
) => {
  const result = getClient().mutate<CreateJanparaCrawlSettingRequiredKeywordMutation>({
    mutation: CreateJanparaCrawlSettingRequiredKeywordDocument,
    variables: { input },
  })
  revalidateAdminPaths()
  revalidateProductsPaths()

  return result
}

export const updateJanparaCrawlSettingRequiredKeyword = async (
  input: UpdateJanparaCrawlSettingRequiredKeywordInput,
) => {
  const result = getClient().mutate<UpdateJanparaCrawlSettingRequiredKeywordMutation>({
    mutation: UpdateJanparaCrawlSettingRequiredKeywordDocument,
    variables: { input },
  })
  revalidateAdminPaths()
  revalidateProductsPaths()

  return result
}

export const deleteJanparaCrawlSettingRequiredKeyword = async (
  input: DeleteJanparaCrawlSettingRequiredKeywordInput,
) => {
  const result = getClient().mutate<DeleteJanparaCrawlSettingRequiredKeywordMutation>({
    mutation: DeleteJanparaCrawlSettingRequiredKeywordDocument,
    variables: { input },
  })
  revalidateAdminPaths()
  revalidateProductsPaths()

  return result
}
