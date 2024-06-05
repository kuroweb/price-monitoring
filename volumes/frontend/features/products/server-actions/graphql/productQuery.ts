'use server'

import { revalidateProductPaths } from '../../lib/revalidatePaths'

import type {
  CreateProductInput,
  CreateProductMutation,
  DeleteProductMutation,
  UpdateProductMutation,
  UpdateProductInput,
} from '@/graphql/dist/client'

import {
  CreateProductDocument,
  DeleteProductDocument,
  UpdateProductDocument,
} from '@/graphql/dist/client'
import { getClient } from '@/lib/apollo-client-rsc'

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

export const updateProduct = async (id: string, input: UpdateProductInput) => {
  const result = getClient().mutate<UpdateProductMutation>({
    mutation: UpdateProductDocument,
    variables: { id, input },
  })
  revalidateProductPaths()

  return result
}

export const deleteProduct = async (id: string) => {
  const result = getClient().mutate<DeleteProductMutation>({
    mutation: DeleteProductDocument,
    variables: { id },
  })
  revalidateProductPaths()

  return result
}
