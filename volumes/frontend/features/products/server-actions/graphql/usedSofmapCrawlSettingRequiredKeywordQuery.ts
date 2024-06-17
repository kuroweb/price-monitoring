'use server'

import { revalidateProductPaths } from '../../lib/revalidatePaths'

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

export const createUsedSofmapCrawlSettingRequiredKeyword = async (
  input: CreateUsedSofmapCrawlSettingRequiredKeywordInput,
) => {
  const result = getClient().mutate<CreateUsedSofmapCrawlSettingRequiredKeywordMutation>({
    mutation: CreateUsedSofmapCrawlSettingRequiredKeywordDocument,
    variables: { input },
  })
  revalidateProductPaths()

  return result
}

export const updateUsedSofmapCrawlSettingRequiredKeyword = async (
  input: UpdateUsedSofmapCrawlSettingRequiredKeywordInput,
) => {
  const result = getClient().mutate<UpdateUsedSofmapCrawlSettingRequiredKeywordMutation>({
    mutation: UpdateUsedSofmapCrawlSettingRequiredKeywordDocument,
    variables: { input },
  })
  revalidateProductPaths()

  return result
}

export const deleteUsedSofmapCrawlSettingRequiredKeyword = async (
  input: DeleteUsedSofmapCrawlSettingRequiredKeywordInput,
) => {
  const result = getClient().mutate<DeleteUsedSofmapCrawlSettingRequiredKeywordMutation>({
    mutation: DeleteUsedSofmapCrawlSettingRequiredKeywordDocument,
    variables: { input },
  })
  revalidateProductPaths()

  return result
}
