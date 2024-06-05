'use server'

import { revalidateProductPaths } from '../../lib/revalidatePaths'

import type {
  CreateUsedSofmapCrawlSettingExcludeProductInput,
  CreateUsedSofmapCrawlSettingExcludeProductMutation,
  UpdateUsedSofmapCrawlSettingExcludeProductInput,
  UpdateUsedSofmapCrawlSettingExcludeProductMutation,
  DeleteUsedSofmapCrawlSettingExcludeProductMutation,
} from '@/graphql/dist/client'

import {
  CreateUsedSofmapCrawlSettingExcludeProductDocument,
  UpdateUsedSofmapCrawlSettingExcludeProductDocument,
  DeleteUsedSofmapCrawlSettingExcludeProductDocument,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'

export const createUsedSofmapCrawlSettingExcludeProduct = async (
  input: CreateUsedSofmapCrawlSettingExcludeProductInput,
) => {
  const result = getClient().mutate<CreateUsedSofmapCrawlSettingExcludeProductMutation>({
    mutation: CreateUsedSofmapCrawlSettingExcludeProductDocument,
    variables: { input },
  })
  revalidateProductPaths()

  return result
}

export const updateUsedSofmapCrawlSettingExcludeProduct = async (
  input: UpdateUsedSofmapCrawlSettingExcludeProductInput,
) => {
  const result = getClient().mutate<UpdateUsedSofmapCrawlSettingExcludeProductMutation>({
    mutation: UpdateUsedSofmapCrawlSettingExcludeProductDocument,
    variables: { input },
  })
  revalidateProductPaths()

  return result
}

export const deleteUsedSofmapCrawlSettingExcludeProduct = async (id: string, productId: string) => {
  const result = getClient().mutate<DeleteUsedSofmapCrawlSettingExcludeProductMutation>({
    mutation: DeleteUsedSofmapCrawlSettingExcludeProductDocument,
    variables: { id, productId },
  })
  revalidateProductPaths()

  return result
}
