'use server'

import { revalidatePath } from 'next/cache'

import type {
  CreateUsedSofmapCrawlSettingRequiredKeywordInput,
  CreateUsedSofmapCrawlSettingRequiredKeywordMutation,
  UpdateUsedSofmapCrawlSettingRequiredKeywordInput,
  UpdateUsedSofmapCrawlSettingRequiredKeywordMutation,
  DeleteUsedSofmapCrawlSettingRequiredKeywordMutation,
} from '@/graphql/dist/client'

import {
  CreateUsedSofmapCrawlSettingRequiredKeywordDocument,
  UpdateUsedSofmapCrawlSettingRequiredKeywordDocument,
  DeleteUsedSofmapCrawlSettingRequiredKeywordDocument,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'

export const createUsedSofmapCrawlSettingRequiredKeyword = async (
  input: CreateUsedSofmapCrawlSettingRequiredKeywordInput,
  pathname: string,
) => {
  const result = getClient().mutate<CreateUsedSofmapCrawlSettingRequiredKeywordMutation>({
    mutation: CreateUsedSofmapCrawlSettingRequiredKeywordDocument,
    variables: { input },
  })
  revalidatePath(pathname)

  return result
}

export const updateUsedSofmapCrawlSettingRequiredKeyword = async (
  input: UpdateUsedSofmapCrawlSettingRequiredKeywordInput,
  pathname: string,
) => {
  const result = getClient().mutate<UpdateUsedSofmapCrawlSettingRequiredKeywordMutation>({
    mutation: UpdateUsedSofmapCrawlSettingRequiredKeywordDocument,
    variables: { input },
  })
  revalidatePath(pathname)

  return result
}

export const deleteUsedSofmapCrawlSettingRequiredKeyword = async (
  id: string,
  productId: string,
  pathname: string,
) => {
  const result = getClient().mutate<DeleteUsedSofmapCrawlSettingRequiredKeywordMutation>({
    mutation: DeleteUsedSofmapCrawlSettingRequiredKeywordDocument,
    variables: { id, productId },
  })
  revalidatePath(pathname)

  return result
}
