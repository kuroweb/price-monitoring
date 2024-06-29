'use server'

import type {
  CreatePcKoubouCrawlSettingRequiredKeywordInput,
  CreatePcKoubouCrawlSettingRequiredKeywordMutation,
  UpdatePcKoubouCrawlSettingRequiredKeywordInput,
  UpdatePcKoubouCrawlSettingRequiredKeywordMutation,
  DeletePcKoubouCrawlSettingRequiredKeywordMutation,
  DeletePcKoubouCrawlSettingRequiredKeywordInput,
} from '@/graphql/dist/client'

import {
  CreatePcKoubouCrawlSettingRequiredKeywordDocument,
  UpdatePcKoubouCrawlSettingRequiredKeywordDocument,
  DeletePcKoubouCrawlSettingRequiredKeywordDocument,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'
import { revalidateProductPaths } from '@/lib/revalidatePaths'

export const createPcKoubouCrawlSettingRequiredKeyword = async (
  input: CreatePcKoubouCrawlSettingRequiredKeywordInput,
) => {
  const result = getClient().mutate<CreatePcKoubouCrawlSettingRequiredKeywordMutation>({
    mutation: CreatePcKoubouCrawlSettingRequiredKeywordDocument,
    variables: { input },
  })
  revalidateProductPaths()

  return result
}

export const updatePcKoubouCrawlSettingRequiredKeyword = async (
  input: UpdatePcKoubouCrawlSettingRequiredKeywordInput,
) => {
  const result = getClient().mutate<UpdatePcKoubouCrawlSettingRequiredKeywordMutation>({
    mutation: UpdatePcKoubouCrawlSettingRequiredKeywordDocument,
    variables: { input },
  })
  revalidateProductPaths()

  return result
}

export const deletePcKoubouCrawlSettingRequiredKeyword = async (
  input: DeletePcKoubouCrawlSettingRequiredKeywordInput,
) => {
  const result = getClient().mutate<DeletePcKoubouCrawlSettingRequiredKeywordMutation>({
    mutation: DeletePcKoubouCrawlSettingRequiredKeywordDocument,
    variables: { input },
  })
  revalidateProductPaths()

  return result
}
