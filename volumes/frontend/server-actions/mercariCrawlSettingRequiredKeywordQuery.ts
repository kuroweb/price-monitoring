'use server'

import type {
  CreateMercariCrawlSettingRequiredKeywordInput,
  CreateMercariCrawlSettingRequiredKeywordMutation,
  UpdateMercariCrawlSettingRequiredKeywordInput,
  UpdateMercariCrawlSettingRequiredKeywordMutation,
  DeleteMercariCrawlSettingRequiredKeywordMutation,
  DeleteMercariCrawlSettingRequiredKeywordInput,
} from '@/graphql/dist/client'

import {
  CreateMercariCrawlSettingRequiredKeywordDocument,
  UpdateMercariCrawlSettingRequiredKeywordDocument,
  DeleteMercariCrawlSettingRequiredKeywordDocument,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'
import { revalidateAdminPaths, revalidateProductsPaths } from '@/lib/revalidate-paths'

export const createMercariCrawlSettingRequiredKeyword = async (
  input: CreateMercariCrawlSettingRequiredKeywordInput,
) => {
  const result = getClient().mutate<CreateMercariCrawlSettingRequiredKeywordMutation>({
    mutation: CreateMercariCrawlSettingRequiredKeywordDocument,
    variables: { input },
  })
  revalidateAdminPaths()
  revalidateProductsPaths()

  return result
}

export const updateMercariCrawlSettingRequiredKeyword = async (
  input: UpdateMercariCrawlSettingRequiredKeywordInput,
) => {
  const result = getClient().mutate<UpdateMercariCrawlSettingRequiredKeywordMutation>({
    mutation: UpdateMercariCrawlSettingRequiredKeywordDocument,
    variables: { input },
  })
  revalidateAdminPaths()
  revalidateProductsPaths()

  return result
}

export const deleteMercariCrawlSettingRequiredKeyword = async (
  input: DeleteMercariCrawlSettingRequiredKeywordInput,
) => {
  const result = getClient().mutate<DeleteMercariCrawlSettingRequiredKeywordMutation>({
    mutation: DeleteMercariCrawlSettingRequiredKeywordDocument,
    variables: { input },
  })
  revalidateAdminPaths()
  revalidateProductsPaths()

  return result
}
