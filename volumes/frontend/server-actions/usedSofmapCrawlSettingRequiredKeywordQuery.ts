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
import { revalidateAdminPaths, revalidateProductsPaths } from '@/lib/revalidate-paths'

export const createUsedSofmapCrawlSettingRequiredKeyword = async (
  input: CreateUsedSofmapCrawlSettingRequiredKeywordInput,
) => {
  const result = getClient().mutate<CreateUsedSofmapCrawlSettingRequiredKeywordMutation>({
    mutation: CreateUsedSofmapCrawlSettingRequiredKeywordDocument,
    variables: { input },
  })
  revalidateAdminPaths()
  revalidateProductsPaths()

  return result
}

export const updateUsedSofmapCrawlSettingRequiredKeyword = async (
  input: UpdateUsedSofmapCrawlSettingRequiredKeywordInput,
) => {
  const result = getClient().mutate<UpdateUsedSofmapCrawlSettingRequiredKeywordMutation>({
    mutation: UpdateUsedSofmapCrawlSettingRequiredKeywordDocument,
    variables: { input },
  })
  revalidateAdminPaths()
  revalidateProductsPaths()

  return result
}

export const deleteUsedSofmapCrawlSettingRequiredKeyword = async (
  input: DeleteUsedSofmapCrawlSettingRequiredKeywordInput,
) => {
  const result = getClient().mutate<DeleteUsedSofmapCrawlSettingRequiredKeywordMutation>({
    mutation: DeleteUsedSofmapCrawlSettingRequiredKeywordDocument,
    variables: { input },
  })
  revalidateAdminPaths()
  revalidateProductsPaths()

  return result
}
