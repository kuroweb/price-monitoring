'use server'

import { revalidatePath } from 'next/cache'

import type {
  CreateJanparaCrawlSettingRequiredKeywordInput,
  CreateJanparaCrawlSettingRequiredKeywordMutation,
  UpdateJanparaCrawlSettingRequiredKeywordInput,
  UpdateJanparaCrawlSettingRequiredKeywordMutation,
  DeleteJanparaCrawlSettingRequiredKeywordMutation,
} from '@/graphql/dist/client'

import {
  CreateJanparaCrawlSettingRequiredKeywordDocument,
  UpdateJanparaCrawlSettingRequiredKeywordDocument,
  DeleteJanparaCrawlSettingRequiredKeywordDocument,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'

export const createJanparaCrawlSettingRequiredKeyword = async (
  input: CreateJanparaCrawlSettingRequiredKeywordInput,
  pathname: string,
) => {
  const result = getClient().mutate<CreateJanparaCrawlSettingRequiredKeywordMutation>({
    mutation: CreateJanparaCrawlSettingRequiredKeywordDocument,
    variables: { input },
  })
  revalidatePath(pathname)

  return result
}

export const updateJanparaCrawlSettingRequiredKeyword = async (
  input: UpdateJanparaCrawlSettingRequiredKeywordInput,
  pathname: string,
) => {
  const result = getClient().mutate<UpdateJanparaCrawlSettingRequiredKeywordMutation>({
    mutation: UpdateJanparaCrawlSettingRequiredKeywordDocument,
    variables: { input },
  })
  revalidatePath(pathname)

  return result
}

export const deleteJanparaCrawlSettingRequiredKeyword = async (
  id: string,
  productId: string,
  pathname: string,
) => {
  const result = getClient().mutate<DeleteJanparaCrawlSettingRequiredKeywordMutation>({
    mutation: DeleteJanparaCrawlSettingRequiredKeywordDocument,
    variables: { id, productId },
  })
  revalidatePath(pathname)

  return result
}
