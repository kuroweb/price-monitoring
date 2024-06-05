'use server'

import { revalidateProductPaths } from '../../lib/revalidatePaths'

import type {
  CreateUsedSofmapCrawlSettingExcludeKeywordInput,
  CreateUsedSofmapCrawlSettingExcludeKeywordMutation,
  UpdateUsedSofmapCrawlSettingExcludeKeywordInput,
  UpdateUsedSofmapCrawlSettingExcludeKeywordMutation,
  DeleteUsedSofmapCrawlSettingExcludeKeywordMutation,
} from '@/graphql/dist/client'

import {
  CreateUsedSofmapCrawlSettingExcludeKeywordDocument,
  UpdateUsedSofmapCrawlSettingExcludeKeywordDocument,
  DeleteUsedSofmapCrawlSettingExcludeKeywordDocument,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'

export const createUsedSofmapCrawlSettingExcludeKeyword = async (
  input: CreateUsedSofmapCrawlSettingExcludeKeywordInput,
) => {
  const result = getClient().mutate<CreateUsedSofmapCrawlSettingExcludeKeywordMutation>({
    mutation: CreateUsedSofmapCrawlSettingExcludeKeywordDocument,
    variables: { input },
  })
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
  revalidateProductPaths()

  return result
}

export const deleteUsedSofmapCrawlSettingExcludeKeyword = async (id: string, productId: string) => {
  const result = getClient().mutate<DeleteUsedSofmapCrawlSettingExcludeKeywordMutation>({
    mutation: DeleteUsedSofmapCrawlSettingExcludeKeywordDocument,
    variables: { id, productId },
  })
  revalidateProductPaths()

  return result
}
