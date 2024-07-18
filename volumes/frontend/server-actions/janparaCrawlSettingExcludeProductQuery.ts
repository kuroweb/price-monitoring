'use server'

import type {
  CreateJanparaCrawlSettingExcludeProductInput,
  CreateJanparaCrawlSettingExcludeProductMutation,
  UpdateJanparaCrawlSettingExcludeProductInput,
  UpdateJanparaCrawlSettingExcludeProductMutation,
  DeleteJanparaCrawlSettingExcludeProductMutation,
  DeleteJanparaCrawlSettingExcludeProductInput,
} from '@/graphql/dist/client'

import {
  CreateJanparaCrawlSettingExcludeProductDocument,
  UpdateJanparaCrawlSettingExcludeProductDocument,
  DeleteJanparaCrawlSettingExcludeProductDocument,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'
import { revalidateAdminPaths, revalidateProductPaths } from '@/lib/revalidatePaths'

export const createJanparaCrawlSettingExcludeProduct = async (
  input: CreateJanparaCrawlSettingExcludeProductInput,
) => {
  const result = getClient().mutate<CreateJanparaCrawlSettingExcludeProductMutation>({
    mutation: CreateJanparaCrawlSettingExcludeProductDocument,
    variables: { input },
  })
  revalidateAdminPaths()
  revalidateProductPaths()

  return result
}

export const updateJanparaCrawlSettingExcludeProduct = async (
  input: UpdateJanparaCrawlSettingExcludeProductInput,
) => {
  const result = getClient().mutate<UpdateJanparaCrawlSettingExcludeProductMutation>({
    mutation: UpdateJanparaCrawlSettingExcludeProductDocument,
    variables: { input },
  })
  revalidateAdminPaths()
  revalidateProductPaths()

  return result
}

export const deleteJanparaCrawlSettingExcludeProduct = async (
  input: DeleteJanparaCrawlSettingExcludeProductInput,
) => {
  const result = getClient().mutate<DeleteJanparaCrawlSettingExcludeProductMutation>({
    mutation: DeleteJanparaCrawlSettingExcludeProductDocument,
    variables: { input },
  })
  revalidateAdminPaths()
  revalidateProductPaths()

  return result
}
