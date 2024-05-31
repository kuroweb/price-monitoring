'use server'

import { revalidatePath } from 'next/cache'

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

export const createProduct = async (input: CreateProductInput, pathname: string) => {
  const result = getClient().mutate<CreateProductMutation>({
    mutation: CreateProductDocument,
    variables: { input },
  })
  revalidatePath(pathname)

  return result
}

export const updateProduct = async (id: string, input: UpdateProductInput, pathname: string) => {
  const result = getClient().mutate<UpdateProductMutation>({
    mutation: UpdateProductDocument,
    variables: { id, input },
  })
  revalidatePath(pathname)

  return result
}

export const deleteProduct = async (id: string, pathname: string) => {
  const result = getClient().mutate<DeleteProductMutation>({
    mutation: DeleteProductDocument,
    variables: { id },
  })
  revalidatePath(pathname)

  return result
}
