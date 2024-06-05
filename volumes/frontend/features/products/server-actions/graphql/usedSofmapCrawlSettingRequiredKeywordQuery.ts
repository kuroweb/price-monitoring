'use server'

import { revalidateProductPaths } from '../../lib/revalidatePaths'

import type {
  CreateUsedSofmapCrawlSettingRequiredKeywordInput,
  CreateUsedSofmapCrawlSettingRequiredKeywordMutation,
  UpdateUsedSofmapCrawlSettingRequiredKeywordInput,
  UpdateUsedSofmapCrawlSettingRequiredKeywordMutation,
  DeleteUsedSofmapCrawlSettingRequiredKeywordMutation,
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
  id: string,
  productId: string,
) => {
  const result = getClient().mutate<DeleteUsedSofmapCrawlSettingRequiredKeywordMutation>({
    mutation: DeleteUsedSofmapCrawlSettingRequiredKeywordDocument,
    variables: { id, productId },
  })
  revalidateProductPaths()

  return result
}
