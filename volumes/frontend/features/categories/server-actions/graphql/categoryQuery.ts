'use server'

import type { CreateCategoryInput, CreateCategoryMutation } from '@/graphql/dist/client'

import { CreateCategoryDocument } from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'
import { revalidateCategoryPaths, revalidateProductPaths } from '@/lib/revalidatePaths'

export const createCategory = async (input: CreateCategoryInput) => {
  const result = getClient().mutate<CreateCategoryMutation>({
    mutation: CreateCategoryDocument,
    variables: { input },
  })
  revalidateProductPaths()
  revalidateCategoryPaths()

  return result
}
