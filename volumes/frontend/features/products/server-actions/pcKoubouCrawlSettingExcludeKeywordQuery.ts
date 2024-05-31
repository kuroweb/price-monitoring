'use server'

import { revalidatePath } from 'next/cache'

import type {
  CreatePcKoubouCrawlSettingExcludeKeywordInput,
  CreatePcKoubouCrawlSettingExcludeKeywordMutation,
  UpdatePcKoubouCrawlSettingExcludeKeywordInput,
  UpdatePcKoubouCrawlSettingExcludeKeywordMutation,
  DeletePcKoubouCrawlSettingExcludeKeywordMutation,
} from '@/graphql/dist/client'

import {
  CreatePcKoubouCrawlSettingExcludeKeywordDocument,
  UpdatePcKoubouCrawlSettingExcludeKeywordDocument,
  DeletePcKoubouCrawlSettingExcludeKeywordDocument,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'

export const createPcKoubouCrawlSettingExcludeKeyword = async (
  input: CreatePcKoubouCrawlSettingExcludeKeywordInput,
  pathname: string,
) => {
  const result = getClient().mutate<CreatePcKoubouCrawlSettingExcludeKeywordMutation>({
    mutation: CreatePcKoubouCrawlSettingExcludeKeywordDocument,
    variables: { input },
  })
  revalidatePath(pathname)

  return result
}

export const updatePcKoubouCrawlSettingExcludeKeyword = async (
  input: UpdatePcKoubouCrawlSettingExcludeKeywordInput,
  pathname: string,
) => {
  const result = getClient().mutate<UpdatePcKoubouCrawlSettingExcludeKeywordMutation>({
    mutation: UpdatePcKoubouCrawlSettingExcludeKeywordDocument,
    variables: { input },
  })
  revalidatePath(pathname)

  return result
}

export const deletePcKoubouCrawlSettingExcludeKeyword = async (
  id: string,
  productId: string,
  pathname: string,
) => {
  const result = getClient().mutate<DeletePcKoubouCrawlSettingExcludeKeywordMutation>({
    mutation: DeletePcKoubouCrawlSettingExcludeKeywordDocument,
    variables: { id, productId },
  })
  revalidatePath(pathname)

  return result
}
