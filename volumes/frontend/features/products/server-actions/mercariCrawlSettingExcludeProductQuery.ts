'use server'

import { revalidatePath } from 'next/cache'

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
  pathname: string,
) => {
  const result = getClient().mutate<CreateMercariCrawlSettingExcludeProductMutation>({
    mutation: CreateMercariCrawlSettingExcludeProductDocument,
    variables: { input },
  })
  revalidatePath(pathname)

  return result
}

export const updateMercariCrawlSettingExcludeProduct = async (
  input: UpdateMercariCrawlSettingExcludeProductInput,
  pathname: string,
) => {
  const result = getClient().mutate<UpdateMercariCrawlSettingExcludeProductMutation>({
    mutation: UpdateMercariCrawlSettingExcludeProductDocument,
    variables: { input },
  })
  revalidatePath(pathname)

  return result
}

export const deleteMercariCrawlSettingExcludeProduct = async (
  id: string,
  productId: string,
  pathname: string,
) => {
  const result = getClient().mutate<DeleteMercariCrawlSettingExcludeProductMutation>({
    mutation: DeleteMercariCrawlSettingExcludeProductDocument,
    variables: { id, productId },
  })
  revalidatePath(pathname)

  return result
}
