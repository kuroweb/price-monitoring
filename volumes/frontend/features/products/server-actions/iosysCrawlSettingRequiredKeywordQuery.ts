'use server'

import { revalidatePath } from 'next/cache'

import type {
  CreateIosysCrawlSettingRequiredKeywordInput,
  CreateIosysCrawlSettingRequiredKeywordMutation,
  UpdateIosysCrawlSettingRequiredKeywordInput,
  UpdateIosysCrawlSettingRequiredKeywordMutation,
  DeleteIosysCrawlSettingRequiredKeywordMutation,
} from '@/graphql/dist/client'

import {
  CreateIosysCrawlSettingRequiredKeywordDocument,
  UpdateIosysCrawlSettingRequiredKeywordDocument,
  DeleteIosysCrawlSettingRequiredKeywordDocument,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'

export const createIosysCrawlSettingRequiredKeyword = async (
  input: CreateIosysCrawlSettingRequiredKeywordInput,
  pathname: string,
) => {
  const result = getClient().mutate<CreateIosysCrawlSettingRequiredKeywordMutation>({
    mutation: CreateIosysCrawlSettingRequiredKeywordDocument,
    variables: { input },
  })
  revalidatePath(pathname)

  return result
}

export const updateIosysCrawlSettingRequiredKeyword = async (
  input: UpdateIosysCrawlSettingRequiredKeywordInput,
  pathname: string,
) => {
  const result = getClient().mutate<UpdateIosysCrawlSettingRequiredKeywordMutation>({
    mutation: UpdateIosysCrawlSettingRequiredKeywordDocument,
    variables: { input },
  })
  revalidatePath(pathname)

  return result
}

export const deleteIosysCrawlSettingRequiredKeyword = async (
  id: string,
  productId: string,
  pathname: string,
) => {
  const result = getClient().mutate<DeleteIosysCrawlSettingRequiredKeywordMutation>({
    mutation: DeleteIosysCrawlSettingRequiredKeywordDocument,
    variables: { id, productId },
  })
  revalidatePath(pathname)

  return result
}
