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
import { revalidateAdminPaths, revalidateProductsPaths } from '@/lib/revalidate-paths'

/*
  Product
*/

export const createProduct = async (input: CreateProductInput) => {
  const result = getClient().mutate<CreateProductMutation>({
    mutation: CreateProductDocument,
    variables: { input },
  })
  revalidateAdminPaths()
  revalidateProductsPaths()

  return result
}

export const updateProduct = async (input: UpdateProductInput) => {
  const result = getClient().mutate<UpdateProductMutation>({
    mutation: UpdateProductDocument,
    variables: { input },
  })
  revalidateAdminPaths()
  revalidateProductsPaths()

  return result
}

export const deleteProduct = async (input: DeleteProductInput) => {
  const result = getClient().mutate<DeleteProductMutation>({
    mutation: DeleteProductDocument,
    variables: { input },
  })
  revalidateAdminPaths()
  revalidateProductsPaths()

  return result
}
