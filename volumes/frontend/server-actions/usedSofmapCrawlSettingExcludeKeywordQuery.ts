'use server'

import type {
  CreateUsedSofmapCrawlSettingExcludeKeywordInput,
  CreateUsedSofmapCrawlSettingExcludeKeywordMutation,
  UpdateUsedSofmapCrawlSettingExcludeKeywordInput,
  UpdateUsedSofmapCrawlSettingExcludeKeywordMutation,
  DeleteUsedSofmapCrawlSettingExcludeKeywordMutation,
  DeleteUsedSofmapCrawlSettingExcludeKeywordInput,
} from '@/graphql/dist/client'

import {
  CreateUsedSofmapCrawlSettingExcludeKeywordDocument,
  UpdateUsedSofmapCrawlSettingExcludeKeywordDocument,
  DeleteUsedSofmapCrawlSettingExcludeKeywordDocument,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'
import { revalidateAdminPaths, revalidateProductPaths } from '@/lib/revalidate-paths'

export const createUsedSofmapCrawlSettingExcludeKeyword = async (
  input: CreateUsedSofmapCrawlSettingExcludeKeywordInput,
) => {
  const result = getClient().mutate<CreateUsedSofmapCrawlSettingExcludeKeywordMutation>({
    mutation: CreateUsedSofmapCrawlSettingExcludeKeywordDocument,
    variables: { input },
  })
  revalidateAdminPaths()
  revalidateProductPaths()

  return result
}

export const updateUsedSofmapCrawlSettingExcludeKeyword = async (
  input: UpdateUsedSofmapCrawlSettingExcludeKeywordInput,
) => {
  const result = getClient().mutate<UpdateUsedSofmapCrawlSettingExcludeKeywordMutation>({
    mutation: UpdateUsedSofmapCrawlSettingExcludeKeywordDocument,
    variables: { input },
  })
  revalidateAdminPaths()
  revalidateProductPaths()

  return result
}

export const deleteUsedSofmapCrawlSettingExcludeKeyword = async (
  input: DeleteUsedSofmapCrawlSettingExcludeKeywordInput,
) => {
  const result = getClient().mutate<DeleteUsedSofmapCrawlSettingExcludeKeywordMutation>({
    mutation: DeleteUsedSofmapCrawlSettingExcludeKeywordDocument,
    variables: { input },
  })
  revalidateAdminPaths()
  revalidateProductPaths()

  return result
}
