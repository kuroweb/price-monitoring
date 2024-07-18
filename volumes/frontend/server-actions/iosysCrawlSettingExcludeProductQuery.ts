'use server'

import type {
  CreateIosysCrawlSettingExcludeProductInput,
  CreateIosysCrawlSettingExcludeProductMutation,
  UpdateIosysCrawlSettingExcludeProductInput,
  UpdateIosysCrawlSettingExcludeProductMutation,
  DeleteIosysCrawlSettingExcludeProductMutation,
  DeleteIosysCrawlSettingExcludeProductInput,
} from '@/graphql/dist/client'

import {
  CreateIosysCrawlSettingExcludeProductDocument,
  UpdateIosysCrawlSettingExcludeProductDocument,
  DeleteIosysCrawlSettingExcludeProductDocument,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'
import { revalidateAdminPaths, revalidateProductPaths } from '@/lib/revalidatePaths'

export const createIosysCrawlSettingExcludeProduct = async (
  input: CreateIosysCrawlSettingExcludeProductInput,
) => {
  const result = getClient().mutate<CreateIosysCrawlSettingExcludeProductMutation>({
    mutation: CreateIosysCrawlSettingExcludeProductDocument,
    variables: { input },
  })
  revalidateAdminPaths()
  revalidateProductPaths()

  return result
}

export const updateIosysCrawlSettingExcludeProduct = async (
  input: UpdateIosysCrawlSettingExcludeProductInput,
) => {
  const result = getClient().mutate<UpdateIosysCrawlSettingExcludeProductMutation>({
    mutation: UpdateIosysCrawlSettingExcludeProductDocument,
    variables: { input },
  })
  revalidateAdminPaths()
  revalidateProductPaths()

  return result
}

export const deleteIosysCrawlSettingExcludeProduct = async (
  input: DeleteIosysCrawlSettingExcludeProductInput,
) => {
  const result = getClient().mutate<DeleteIosysCrawlSettingExcludeProductMutation>({
    mutation: DeleteIosysCrawlSettingExcludeProductDocument,
    variables: { input },
  })
  revalidateAdminPaths()
  revalidateProductPaths()

  return result
}
