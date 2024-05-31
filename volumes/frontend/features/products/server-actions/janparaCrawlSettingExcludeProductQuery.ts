'use server'

import { revalidatePath } from 'next/cache'

import type {
  CreateJanparaCrawlSettingExcludeProductInput,
  CreateJanparaCrawlSettingExcludeProductMutation,
  UpdateJanparaCrawlSettingExcludeProductInput,
  UpdateJanparaCrawlSettingExcludeProductMutation,
  DeleteJanparaCrawlSettingExcludeProductMutation,
} from '@/graphql/dist/client'

import {
  CreateJanparaCrawlSettingExcludeProductDocument,
  UpdateJanparaCrawlSettingExcludeProductDocument,
  DeleteJanparaCrawlSettingExcludeProductDocument,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'

export const createJanparaCrawlSettingExcludeProduct = async (
  input: CreateJanparaCrawlSettingExcludeProductInput,
  pathname: string,
) => {
  const result = getClient().mutate<CreateJanparaCrawlSettingExcludeProductMutation>({
    mutation: CreateJanparaCrawlSettingExcludeProductDocument,
    variables: { input },
  })
  revalidatePath(pathname)

  return result
}

export const updateJanparaCrawlSettingExcludeProduct = async (
  input: UpdateJanparaCrawlSettingExcludeProductInput,
  pathname: string,
) => {
  const result = getClient().mutate<UpdateJanparaCrawlSettingExcludeProductMutation>({
    mutation: UpdateJanparaCrawlSettingExcludeProductDocument,
    variables: { input },
  })
  revalidatePath(pathname)

  return result
}

export const deleteJanparaCrawlSettingExcludeProduct = async (
  id: string,
  productId: string,
  pathname: string,
) => {
  const result = getClient().mutate<DeleteJanparaCrawlSettingExcludeProductMutation>({
    mutation: DeleteJanparaCrawlSettingExcludeProductDocument,
    variables: { id, productId },
  })
  revalidatePath(pathname)

  return result
}
