'use server'

import { revalidatePath } from 'next/cache'

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
  pathname: string,
) => {
  const result = getClient().mutate<CreateUsedSofmapCrawlSettingExcludeProductMutation>({
    mutation: CreateUsedSofmapCrawlSettingExcludeProductDocument,
    variables: { input },
  })
  revalidatePath(pathname)

  return result
}

export const updateUsedSofmapCrawlSettingExcludeProduct = async (
  input: UpdateUsedSofmapCrawlSettingExcludeProductInput,
  pathname: string,
) => {
  const result = getClient().mutate<UpdateUsedSofmapCrawlSettingExcludeProductMutation>({
    mutation: UpdateUsedSofmapCrawlSettingExcludeProductDocument,
    variables: { input },
  })
  revalidatePath(pathname)

  return result
}

export const deleteUsedSofmapCrawlSettingExcludeProduct = async (
  id: string,
  productId: string,
  pathname: string,
) => {
  const result = getClient().mutate<DeleteUsedSofmapCrawlSettingExcludeProductMutation>({
    mutation: DeleteUsedSofmapCrawlSettingExcludeProductDocument,
    variables: { id, productId },
  })
  revalidatePath(pathname)

  return result
}
