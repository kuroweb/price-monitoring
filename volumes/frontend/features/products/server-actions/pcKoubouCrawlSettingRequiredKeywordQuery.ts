'use server'

import { revalidatePath } from 'next/cache'

import type {
  CreatePcKoubouCrawlSettingRequiredKeywordInput,
  CreatePcKoubouCrawlSettingRequiredKeywordMutation,
  UpdatePcKoubouCrawlSettingRequiredKeywordInput,
  UpdatePcKoubouCrawlSettingRequiredKeywordMutation,
  DeletePcKoubouCrawlSettingRequiredKeywordMutation,
} from '@/graphql/dist/client'

import {
  CreatePcKoubouCrawlSettingRequiredKeywordDocument,
  UpdatePcKoubouCrawlSettingRequiredKeywordDocument,
  DeletePcKoubouCrawlSettingRequiredKeywordDocument,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'

export const createPcKoubouCrawlSettingRequiredKeyword = async (
  input: CreatePcKoubouCrawlSettingRequiredKeywordInput,
  pathname: string,
) => {
  const result = getClient().mutate<CreatePcKoubouCrawlSettingRequiredKeywordMutation>({
    mutation: CreatePcKoubouCrawlSettingRequiredKeywordDocument,
    variables: { input },
  })
  revalidatePath(pathname)

  return result
}

export const updatePcKoubouCrawlSettingRequiredKeyword = async (
  input: UpdatePcKoubouCrawlSettingRequiredKeywordInput,
  pathname: string,
) => {
  const result = getClient().mutate<UpdatePcKoubouCrawlSettingRequiredKeywordMutation>({
    mutation: UpdatePcKoubouCrawlSettingRequiredKeywordDocument,
    variables: { input },
  })
  revalidatePath(pathname)

  return result
}

export const deletePcKoubouCrawlSettingRequiredKeyword = async (
  id: string,
  productId: string,
  pathname: string,
) => {
  const result = getClient().mutate<DeletePcKoubouCrawlSettingRequiredKeywordMutation>({
    mutation: DeletePcKoubouCrawlSettingRequiredKeywordDocument,
    variables: { id, productId },
  })
  revalidatePath(pathname)

  return result
}
