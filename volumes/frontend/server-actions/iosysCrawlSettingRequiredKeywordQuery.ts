'use server'

import type {
  CreateIosysCrawlSettingRequiredKeywordInput,
  CreateIosysCrawlSettingRequiredKeywordMutation,
  UpdateIosysCrawlSettingRequiredKeywordInput,
  UpdateIosysCrawlSettingRequiredKeywordMutation,
  DeleteIosysCrawlSettingRequiredKeywordMutation,
  DeleteIosysCrawlSettingRequiredKeywordInput,
} from '@/graphql/dist/client'

import {
  CreateIosysCrawlSettingRequiredKeywordDocument,
  UpdateIosysCrawlSettingRequiredKeywordDocument,
  DeleteIosysCrawlSettingRequiredKeywordDocument,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'
import { revalidateAdminPaths, revalidateProductPaths } from '@/lib/revalidate-paths'

export const createIosysCrawlSettingRequiredKeyword = async (
  input: CreateIosysCrawlSettingRequiredKeywordInput,
) => {
  const result = getClient().mutate<CreateIosysCrawlSettingRequiredKeywordMutation>({
    mutation: CreateIosysCrawlSettingRequiredKeywordDocument,
    variables: { input },
  })
  revalidateAdminPaths()
  revalidateProductPaths()

  return result
}

export const updateIosysCrawlSettingRequiredKeyword = async (
  input: UpdateIosysCrawlSettingRequiredKeywordInput,
) => {
  const result = getClient().mutate<UpdateIosysCrawlSettingRequiredKeywordMutation>({
    mutation: UpdateIosysCrawlSettingRequiredKeywordDocument,
    variables: { input },
  })
  revalidateAdminPaths()
  revalidateProductPaths()

  return result
}

export const deleteIosysCrawlSettingRequiredKeyword = async (
  input: DeleteIosysCrawlSettingRequiredKeywordInput,
) => {
  const result = getClient().mutate<DeleteIosysCrawlSettingRequiredKeywordMutation>({
    mutation: DeleteIosysCrawlSettingRequiredKeywordDocument,
    variables: { input },
  })
  revalidateAdminPaths()
  revalidateProductPaths()

  return result
}
