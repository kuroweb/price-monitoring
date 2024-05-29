import type { ActionFunctionArgs, LoaderFunction } from '@remix-run/node'

import {
  CreateProductDocument,
  CreateProductInput,
  CreateProductMutation,
  DeleteProductDocument,
  DeleteProductMutation,
  GetProductPageDataDocument,
  GetProductPageDataQuery,
  UpdateProductDocument,
  UpdateProductInput,
  UpdateProductMutation,
} from '@/graphql/dist/client'
import client from '@/lib/apollo-client'

export const loader: LoaderFunction = async () => {
  const { data } = await client.query<GetProductPageDataQuery>({
    query: GetProductPageDataDocument,
  })

  return data
}

type ControlType = 'create' | 'update' | 'delete'
type CreateBody = { control: ControlType; input: CreateProductInput }
type UpdateBody = { control: ControlType; productId: string; input: UpdateProductInput }
type DeleteBody = { control: ControlType; productId: string }

export const action = async ({ request }: ActionFunctionArgs) => {
  const body: CreateBody | UpdateBody | DeleteBody = await request.json()
  switch (body.control) {
    case 'create':
      return await handleCreate(body as CreateBody)
    case 'update':
      return await handleUpdate(body as UpdateBody)
    case 'delete':
      return await handleDelete(body as DeleteBody)
    default:
      throw new Error('Unknown Action.')
  }
}

const handleCreate = async (body: CreateBody) => {
  return await client.mutate<CreateProductMutation>({
    mutation: CreateProductDocument,
    variables: { input: body.input },
  })
}
const handleUpdate = async (body: UpdateBody) => {
  return await client.mutate<UpdateProductMutation>({
    mutation: UpdateProductDocument,
    variables: { id: body.productId, input: body.input },
  })
}
const handleDelete = async (body: DeleteBody) => {
  return await client.mutate<DeleteProductMutation>({
    mutation: DeleteProductDocument,
    variables: { id: body.productId },
  })
}
