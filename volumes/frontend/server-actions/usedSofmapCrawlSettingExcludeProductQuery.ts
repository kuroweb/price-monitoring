'use server'

import type {
  CreateUsedSofmapCrawlSettingExcludeProductInput,
  CreateUsedSofmapCrawlSettingExcludeProductMutation,
  UpdateUsedSofmapCrawlSettingExcludeProductInput,
  UpdateUsedSofmapCrawlSettingExcludeProductMutation,
  DeleteUsedSofmapCrawlSettingExcludeProductMutation,
  DeleteUsedSofmapCrawlSettingExcludeProductInput,
} from '@/graphql/dist/client'

import {
  CreateUsedSofmapCrawlSettingExcludeProductDocument,
  UpdateUsedSofmapCrawlSettingExcludeProductDocument,
  DeleteUsedSofmapCrawlSettingExcludeProductDocument,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'
import { revalidateAdminPaths, revalidateProductsPaths } from '@/lib/revalidate-paths'

export const createUsedSofmapCrawlSettingExcludeProduct = async (
  input: CreateUsedSofmapCrawlSettingExcludeProductInput,
) => {
  const result = getClient().mutate<CreateUsedSofmapCrawlSettingExcludeProductMutation>({
    mutation: CreateUsedSofmapCrawlSettingExcludeProductDocument,
    variables: { input },
  })
  revalidateAdminPaths()
  revalidateProductsPaths()

  return result
}

export const updateUsedSofmapCrawlSettingExcludeProduct = async (
  input: UpdateUsedSofmapCrawlSettingExcludeProductInput,
) => {
  const result = getClient().mutate<UpdateUsedSofmapCrawlSettingExcludeProductMutation>({
    mutation: UpdateUsedSofmapCrawlSettingExcludeProductDocument,
    variables: { input },
  })
  revalidateAdminPaths()
  revalidateProductsPaths()

  return result
}

export const deleteUsedSofmapCrawlSettingExcludeProduct = async (
  input: DeleteUsedSofmapCrawlSettingExcludeProductInput,
) => {
  const result = getClient().mutate<DeleteUsedSofmapCrawlSettingExcludeProductMutation>({
    mutation: DeleteUsedSofmapCrawlSettingExcludeProductDocument,
    variables: { input },
  })
  revalidateAdminPaths()
  revalidateProductsPaths()

  return result
}
