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
import { revalidateProductPaths } from '@/lib/revalidatePaths'

export const createIosysCrawlSettingExcludeProduct = async (
  input: CreateIosysCrawlSettingExcludeProductInput,
) => {
  const result = getClient().mutate<CreateIosysCrawlSettingExcludeProductMutation>({
    mutation: CreateIosysCrawlSettingExcludeProductDocument,
    variables: { input },
  })
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
  revalidateProductPaths()

  return result
}
