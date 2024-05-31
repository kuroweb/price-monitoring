'use server'

import { revalidatePath } from 'next/cache'

import type {
  CreatePcKoubouCrawlSettingExcludeProductInput,
  CreatePcKoubouCrawlSettingExcludeProductMutation,
  UpdatePcKoubouCrawlSettingExcludeProductInput,
  UpdatePcKoubouCrawlSettingExcludeProductMutation,
  DeletePcKoubouCrawlSettingExcludeProductMutation,
} from '@/graphql/dist/client'

import {
  CreatePcKoubouCrawlSettingExcludeProductDocument,
  UpdatePcKoubouCrawlSettingExcludeProductDocument,
  DeletePcKoubouCrawlSettingExcludeProductDocument,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'

export const createPcKoubouCrawlSettingExcludeProduct = async (
  input: CreatePcKoubouCrawlSettingExcludeProductInput,
  pathname: string,
) => {
  const result = getClient().mutate<CreatePcKoubouCrawlSettingExcludeProductMutation>({
    mutation: CreatePcKoubouCrawlSettingExcludeProductDocument,
    variables: { input },
  })
  revalidatePath(pathname)

  return result
}

export const updatePcKoubouCrawlSettingExcludeProduct = async (
  input: UpdatePcKoubouCrawlSettingExcludeProductInput,
  pathname: string,
) => {
  const result = getClient().mutate<UpdatePcKoubouCrawlSettingExcludeProductMutation>({
    mutation: UpdatePcKoubouCrawlSettingExcludeProductDocument,
    variables: { input },
  })
  revalidatePath(pathname)

  return result
}

export const deletePcKoubouCrawlSettingExcludeProduct = async (
  id: string,
  productId: string,
  pathname: string,
) => {
  const result = getClient().mutate<DeletePcKoubouCrawlSettingExcludeProductMutation>({
    mutation: DeletePcKoubouCrawlSettingExcludeProductDocument,
    variables: { id, productId },
  })
  revalidatePath(pathname)

  return result
}
