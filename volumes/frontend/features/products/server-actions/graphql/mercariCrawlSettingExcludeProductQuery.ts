'use server'

import { revalidateProductPaths } from '../../lib/revalidatePaths'

import type {
  CreateMercariCrawlSettingExcludeProductInput,
  CreateMercariCrawlSettingExcludeProductMutation,
  UpdateMercariCrawlSettingExcludeProductInput,
  UpdateMercariCrawlSettingExcludeProductMutation,
  DeleteMercariCrawlSettingExcludeProductMutation,
} from '@/graphql/dist/client'

import {
  CreateMercariCrawlSettingExcludeProductDocument,
  UpdateMercariCrawlSettingExcludeProductDocument,
  DeleteMercariCrawlSettingExcludeProductDocument,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'

export const createMercariCrawlSettingExcludeProduct = async (
  input: CreateMercariCrawlSettingExcludeProductInput,
) => {
  const result = getClient().mutate<CreateMercariCrawlSettingExcludeProductMutation>({
    mutation: CreateMercariCrawlSettingExcludeProductDocument,
    variables: { input },
  })
  revalidateProductPaths()

  return result
}

export const updateMercariCrawlSettingExcludeProduct = async (
  input: UpdateMercariCrawlSettingExcludeProductInput,
) => {
  const result = getClient().mutate<UpdateMercariCrawlSettingExcludeProductMutation>({
    mutation: UpdateMercariCrawlSettingExcludeProductDocument,
    variables: { input },
  })
  revalidateProductPaths()

  return result
}

export const deleteMercariCrawlSettingExcludeProduct = async (id: string, productId: string) => {
  const result = getClient().mutate<DeleteMercariCrawlSettingExcludeProductMutation>({
    mutation: DeleteMercariCrawlSettingExcludeProductDocument,
    variables: { id, productId },
  })
  revalidateProductPaths()

  return result
}
