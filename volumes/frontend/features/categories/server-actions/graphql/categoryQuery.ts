'use server'

import type {
  CreateCategoryInput,
  CreateCategoryMutation,
  DeleteCategoryInput,
  DeleteCategoryMutation,
} from '@/graphql/dist/client'

import { CreateCategoryDocument, DeleteCategoryDocument } from '@/graphql/dist/client'
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

export const deleteCategory = async (input: DeleteCategoryInput) => {
  const result = getClient().mutate<DeleteCategoryMutation>({
    mutation: DeleteCategoryDocument,
    variables: { input },
  })
  revalidateProductPaths()
  revalidateCategoryPaths()

  return result
}
