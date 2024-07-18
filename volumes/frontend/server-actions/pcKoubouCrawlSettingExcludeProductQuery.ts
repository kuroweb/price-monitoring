'use server'

import type {
  CreatePcKoubouCrawlSettingExcludeProductInput,
  CreatePcKoubouCrawlSettingExcludeProductMutation,
  UpdatePcKoubouCrawlSettingExcludeProductInput,
  UpdatePcKoubouCrawlSettingExcludeProductMutation,
  DeletePcKoubouCrawlSettingExcludeProductMutation,
  DeletePcKoubouCrawlSettingExcludeProductInput,
} from '@/graphql/dist/client'

import {
  CreatePcKoubouCrawlSettingExcludeProductDocument,
  UpdatePcKoubouCrawlSettingExcludeProductDocument,
  DeletePcKoubouCrawlSettingExcludeProductDocument,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'
import {
  revalidateAdminProductPaths,
  revalidateRecommendPaths,
  revalidateProductPaths,
} from '@/lib/revalidatePaths'

export const createPcKoubouCrawlSettingExcludeProduct = async (
  input: CreatePcKoubouCrawlSettingExcludeProductInput,
) => {
  const result = getClient().mutate<CreatePcKoubouCrawlSettingExcludeProductMutation>({
    mutation: CreatePcKoubouCrawlSettingExcludeProductDocument,
    variables: { input },
  })
  revalidateAdminProductPaths()
  revalidateProductPaths()
  revalidateRecommendPaths()

  return result
}

export const updatePcKoubouCrawlSettingExcludeProduct = async (
  input: UpdatePcKoubouCrawlSettingExcludeProductInput,
) => {
  const result = getClient().mutate<UpdatePcKoubouCrawlSettingExcludeProductMutation>({
    mutation: UpdatePcKoubouCrawlSettingExcludeProductDocument,
    variables: { input },
  })
  revalidateAdminProductPaths()
  revalidateProductPaths()
  revalidateRecommendPaths()

  return result
}

export const deletePcKoubouCrawlSettingExcludeProduct = async (
  input: DeletePcKoubouCrawlSettingExcludeProductInput,
) => {
  const result = getClient().mutate<DeletePcKoubouCrawlSettingExcludeProductMutation>({
    mutation: DeletePcKoubouCrawlSettingExcludeProductDocument,
    variables: { input },
  })
  revalidateAdminProductPaths()
  revalidateProductPaths()
  revalidateRecommendPaths()

  return result
}
