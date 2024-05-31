'use server'

import { revalidatePath } from 'next/cache'

import type {
  CreateIosysCrawlSettingExcludeProductInput,
  CreateIosysCrawlSettingExcludeProductMutation,
  UpdateIosysCrawlSettingExcludeProductInput,
  UpdateIosysCrawlSettingExcludeProductMutation,
  DeleteIosysCrawlSettingExcludeProductMutation,
} from '@/graphql/dist/client'

import {
  CreateIosysCrawlSettingExcludeProductDocument,
  UpdateIosysCrawlSettingExcludeProductDocument,
  DeleteIosysCrawlSettingExcludeProductDocument,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'

export const createIosysCrawlSettingExcludeProduct = async (
  input: CreateIosysCrawlSettingExcludeProductInput,
  pathname: string,
) => {
  const result = getClient().mutate<CreateIosysCrawlSettingExcludeProductMutation>({
    mutation: CreateIosysCrawlSettingExcludeProductDocument,
    variables: { input },
  })
  revalidatePath(pathname)

  return result
}

export const updateIosysCrawlSettingExcludeProduct = async (
  input: UpdateIosysCrawlSettingExcludeProductInput,
  pathname: string,
) => {
  const result = getClient().mutate<UpdateIosysCrawlSettingExcludeProductMutation>({
    mutation: UpdateIosysCrawlSettingExcludeProductDocument,
    variables: { input },
  })
  revalidatePath(pathname)

  return result
}

export const deleteIosysCrawlSettingExcludeProduct = async (
  id: string,
  productId: string,
  pathname: string,
) => {
  const result = getClient().mutate<DeleteIosysCrawlSettingExcludeProductMutation>({
    mutation: DeleteIosysCrawlSettingExcludeProductDocument,
    variables: { id, productId },
  })
  revalidatePath(pathname)

  return result
}
