'use server'

import { revalidatePath } from 'next/cache'

import type {
  CreateUsedSofmapCrawlSettingExcludeKeywordInput,
  CreateUsedSofmapCrawlSettingExcludeKeywordMutation,
  UpdateUsedSofmapCrawlSettingExcludeKeywordInput,
  UpdateUsedSofmapCrawlSettingExcludeKeywordMutation,
  DeleteUsedSofmapCrawlSettingExcludeKeywordMutation,
} from '@/graphql/dist/client'

import {
  CreateUsedSofmapCrawlSettingExcludeKeywordDocument,
  UpdateUsedSofmapCrawlSettingExcludeKeywordDocument,
  DeleteUsedSofmapCrawlSettingExcludeKeywordDocument,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'

export const createUsedSofmapCrawlSettingExcludeKeyword = async (
  input: CreateUsedSofmapCrawlSettingExcludeKeywordInput,
  pathname: string,
) => {
  const result = getClient().mutate<CreateUsedSofmapCrawlSettingExcludeKeywordMutation>({
    mutation: CreateUsedSofmapCrawlSettingExcludeKeywordDocument,
    variables: { input },
  })
  revalidatePath(pathname)

  return result
}

export const updateUsedSofmapCrawlSettingExcludeKeyword = async (
  input: UpdateUsedSofmapCrawlSettingExcludeKeywordInput,
  pathname: string,
) => {
  const result = getClient().mutate<UpdateUsedSofmapCrawlSettingExcludeKeywordMutation>({
    mutation: UpdateUsedSofmapCrawlSettingExcludeKeywordDocument,
    variables: { input },
  })
  revalidatePath(pathname)

  return result
}

export const deleteUsedSofmapCrawlSettingExcludeKeyword = async (
  id: string,
  productId: string,
  pathname: string,
) => {
  const result = getClient().mutate<DeleteUsedSofmapCrawlSettingExcludeKeywordMutation>({
    mutation: DeleteUsedSofmapCrawlSettingExcludeKeywordDocument,
    variables: { id, productId },
  })
  revalidatePath(pathname)

  return result
}
