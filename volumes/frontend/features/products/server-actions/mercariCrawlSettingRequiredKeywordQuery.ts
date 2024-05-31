'use server'

import { revalidatePath } from 'next/cache'

import type {
  CreateMercariCrawlSettingRequiredKeywordInput,
  CreateMercariCrawlSettingRequiredKeywordMutation,
  UpdateMercariCrawlSettingRequiredKeywordInput,
  UpdateMercariCrawlSettingRequiredKeywordMutation,
  DeleteMercariCrawlSettingRequiredKeywordMutation,
} from '@/graphql/dist/client'

import {
  CreateMercariCrawlSettingRequiredKeywordDocument,
  UpdateMercariCrawlSettingRequiredKeywordDocument,
  DeleteMercariCrawlSettingRequiredKeywordDocument,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'

export const createMercariCrawlSettingRequiredKeyword = async (
  input: CreateMercariCrawlSettingRequiredKeywordInput,
  pathname: string,
) => {
  const result = getClient().mutate<CreateMercariCrawlSettingRequiredKeywordMutation>({
    mutation: CreateMercariCrawlSettingRequiredKeywordDocument,
    variables: { input },
  })
  revalidatePath(pathname)

  return result
}

export const updateMercariCrawlSettingRequiredKeyword = async (
  input: UpdateMercariCrawlSettingRequiredKeywordInput,
  pathname: string,
) => {
  const result = getClient().mutate<UpdateMercariCrawlSettingRequiredKeywordMutation>({
    mutation: UpdateMercariCrawlSettingRequiredKeywordDocument,
    variables: { input },
  })
  revalidatePath(pathname)

  return result
}

export const deleteMercariCrawlSettingRequiredKeyword = async (
  id: string,
  productId: string,
  pathname: string,
) => {
  const result = getClient().mutate<DeleteMercariCrawlSettingRequiredKeywordMutation>({
    mutation: DeleteMercariCrawlSettingRequiredKeywordDocument,
    variables: { id, productId },
  })
  revalidatePath(pathname)

  return result
}
