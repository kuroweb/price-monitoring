'use server'

import { revalidatePath } from 'next/cache'

import type {
  CreateIosysCrawlSettingExcludeKeywordInput,
  CreateIosysCrawlSettingExcludeKeywordMutation,
  UpdateIosysCrawlSettingExcludeKeywordInput,
  UpdateIosysCrawlSettingExcludeKeywordMutation,
  DeleteIosysCrawlSettingExcludeKeywordMutation,
} from '@/graphql/dist/client'

import {
  CreateIosysCrawlSettingExcludeKeywordDocument,
  UpdateIosysCrawlSettingExcludeKeywordDocument,
  DeleteIosysCrawlSettingExcludeKeywordDocument,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'

export const createIosysCrawlSettingExcludeKeyword = async (
  input: CreateIosysCrawlSettingExcludeKeywordInput,
  pathname: string,
) => {
  const result = getClient().mutate<CreateIosysCrawlSettingExcludeKeywordMutation>({
    mutation: CreateIosysCrawlSettingExcludeKeywordDocument,
    variables: { input },
  })
  revalidatePath(pathname)

  return result
}

export const updateIosysCrawlSettingExcludeKeyword = async (
  input: UpdateIosysCrawlSettingExcludeKeywordInput,
  pathname: string,
) => {
  const result = getClient().mutate<UpdateIosysCrawlSettingExcludeKeywordMutation>({
    mutation: UpdateIosysCrawlSettingExcludeKeywordDocument,
    variables: { input },
  })
  revalidatePath(pathname)

  return result
}

export const deleteIosysCrawlSettingExcludeKeyword = async (
  id: string,
  productId: string,
  pathname: string,
) => {
  const result = getClient().mutate<DeleteIosysCrawlSettingExcludeKeywordMutation>({
    mutation: DeleteIosysCrawlSettingExcludeKeywordDocument,
    variables: { id, productId },
  })
  revalidatePath(pathname)

  return result
}
