'use server'

import { revalidatePath } from 'next/cache'

import type {
  CreateJanparaCrawlSettingExcludeKeywordInput,
  CreateJanparaCrawlSettingExcludeKeywordMutation,
  UpdateJanparaCrawlSettingExcludeKeywordInput,
  UpdateJanparaCrawlSettingExcludeKeywordMutation,
  DeleteJanparaCrawlSettingExcludeKeywordMutation,
} from '@/graphql/dist/client'

import {
  CreateJanparaCrawlSettingExcludeKeywordDocument,
  UpdateJanparaCrawlSettingExcludeKeywordDocument,
  DeleteJanparaCrawlSettingExcludeKeywordDocument,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'

export const createJanparaCrawlSettingExcludeKeyword = async (
  input: CreateJanparaCrawlSettingExcludeKeywordInput,
  pathname: string,
) => {
  const result = getClient().mutate<CreateJanparaCrawlSettingExcludeKeywordMutation>({
    mutation: CreateJanparaCrawlSettingExcludeKeywordDocument,
    variables: { input },
  })
  revalidatePath(pathname)

  return result
}

export const updateJanparaCrawlSettingExcludeKeyword = async (
  input: UpdateJanparaCrawlSettingExcludeKeywordInput,
  pathname: string,
) => {
  const result = getClient().mutate<UpdateJanparaCrawlSettingExcludeKeywordMutation>({
    mutation: UpdateJanparaCrawlSettingExcludeKeywordDocument,
    variables: { input },
  })
  revalidatePath(pathname)

  return result
}

export const deleteJanparaCrawlSettingExcludeKeyword = async (
  id: string,
  productId: string,
  pathname: string,
) => {
  const result = getClient().mutate<DeleteJanparaCrawlSettingExcludeKeywordMutation>({
    mutation: DeleteJanparaCrawlSettingExcludeKeywordDocument,
    variables: { id, productId },
  })
  revalidatePath(pathname)

  return result
}
