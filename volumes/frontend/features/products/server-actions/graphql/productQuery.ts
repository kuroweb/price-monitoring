'use server'

import type {
  CreateProductInput,
  CreateProductMutation,
  DeleteProductMutation,
  UpdateProductMutation,
  UpdateProductInput,
  DeleteProductInput,
} from '@/graphql/dist/client'

import {
  CreateProductDocument,
  DeleteProductDocument,
  UpdateProductDocument,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'
import { revalidateProductPaths } from '@/lib/revalidatePaths'

/*
  Product
*/

export const createProduct = async (input: CreateProductInput) => {
  const result = getClient().mutate<CreateProductMutation>({
    mutation: CreateProductDocument,
    variables: { input },
  })
  revalidateProductPaths()

  return result
}

export const updateProduct = async (input: UpdateProductInput) => {
  const result = getClient().mutate<UpdateProductMutation>({
    mutation: UpdateProductDocument,
    variables: { input },
  })
  revalidateProductPaths()

  return result
}

export const deleteProduct = async (input: DeleteProductInput) => {
  const result = getClient().mutate<DeleteProductMutation>({
    mutation: DeleteProductDocument,
    variables: { input },
  })
  revalidateProductPaths()

  return result
}
