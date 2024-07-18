'use server'

import type {
  CreatePcKoubouCrawlSettingExcludeKeywordInput,
  CreatePcKoubouCrawlSettingExcludeKeywordMutation,
  UpdatePcKoubouCrawlSettingExcludeKeywordInput,
  UpdatePcKoubouCrawlSettingExcludeKeywordMutation,
  DeletePcKoubouCrawlSettingExcludeKeywordMutation,
  DeletePcKoubouCrawlSettingExcludeKeywordInput,
} from '@/graphql/dist/client'

import {
  CreatePcKoubouCrawlSettingExcludeKeywordDocument,
  UpdatePcKoubouCrawlSettingExcludeKeywordDocument,
  DeletePcKoubouCrawlSettingExcludeKeywordDocument,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'
import { revalidateAdminPaths, revalidateProductPaths } from '@/lib/revalidate-paths'

export const createPcKoubouCrawlSettingExcludeKeyword = async (
  input: CreatePcKoubouCrawlSettingExcludeKeywordInput,
) => {
  const result = getClient().mutate<CreatePcKoubouCrawlSettingExcludeKeywordMutation>({
    mutation: CreatePcKoubouCrawlSettingExcludeKeywordDocument,
    variables: { input },
  })
  revalidateAdminPaths()
  revalidateProductPaths()

  return result
}

export const updatePcKoubouCrawlSettingExcludeKeyword = async (
  input: UpdatePcKoubouCrawlSettingExcludeKeywordInput,
) => {
  const result = getClient().mutate<UpdatePcKoubouCrawlSettingExcludeKeywordMutation>({
    mutation: UpdatePcKoubouCrawlSettingExcludeKeywordDocument,
    variables: { input },
  })
  revalidateAdminPaths()
  revalidateProductPaths()

  return result
}

export const deletePcKoubouCrawlSettingExcludeKeyword = async (
  input: DeletePcKoubouCrawlSettingExcludeKeywordInput,
) => {
  const result = getClient().mutate<DeletePcKoubouCrawlSettingExcludeKeywordMutation>({
    mutation: DeletePcKoubouCrawlSettingExcludeKeywordDocument,
    variables: { input },
  })
  revalidateAdminPaths()
  revalidateProductPaths()

  return result
}
