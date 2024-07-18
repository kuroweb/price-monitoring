'use server'

import type {
  CreateMercariCrawlSettingExcludeProductInput,
  CreateMercariCrawlSettingExcludeProductMutation,
  UpdateMercariCrawlSettingExcludeProductInput,
  UpdateMercariCrawlSettingExcludeProductMutation,
  DeleteMercariCrawlSettingExcludeProductMutation,
  DeleteMercariCrawlSettingExcludeProductInput,
} from '@/graphql/dist/client'

import {
  CreateMercariCrawlSettingExcludeProductDocument,
  UpdateMercariCrawlSettingExcludeProductDocument,
  DeleteMercariCrawlSettingExcludeProductDocument,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'
import {
  revalidateAdminProductPaths,
  revalidateRecommendPaths,
  revalidateProductPaths,
} from '@/lib/revalidatePaths'

export const createMercariCrawlSettingExcludeProduct = async (
  input: CreateMercariCrawlSettingExcludeProductInput,
) => {
  const result = getClient().mutate<CreateMercariCrawlSettingExcludeProductMutation>({
    mutation: CreateMercariCrawlSettingExcludeProductDocument,
    variables: { input },
  })
  revalidateAdminProductPaths()
  revalidateProductPaths()
  revalidateRecommendPaths()

  return result
}

export const updateMercariCrawlSettingExcludeProduct = async (
  input: UpdateMercariCrawlSettingExcludeProductInput,
) => {
  const result = getClient().mutate<UpdateMercariCrawlSettingExcludeProductMutation>({
    mutation: UpdateMercariCrawlSettingExcludeProductDocument,
    variables: { input },
  })
  revalidateAdminProductPaths()
  revalidateProductPaths()
  revalidateRecommendPaths()

  return result
}

export const deleteMercariCrawlSettingExcludeProduct = async (
  input: DeleteMercariCrawlSettingExcludeProductInput,
) => {
  const result = getClient().mutate<DeleteMercariCrawlSettingExcludeProductMutation>({
    mutation: DeleteMercariCrawlSettingExcludeProductDocument,
    variables: { input },
  })
  revalidateAdminProductPaths()
  revalidateProductPaths()
  revalidateRecommendPaths()

  return result
}
