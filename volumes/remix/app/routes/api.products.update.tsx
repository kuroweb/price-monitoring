import { ActionFunctionArgs } from '@remix-run/node'

import {
  UpdateProductInput,
  UpdateProductMutation,
  UpdateProductDocument,
} from '@/graphql/dist/client'
import client from '@/lib/apollo-client'

export const action = async ({ request }: ActionFunctionArgs) => {
  const body: { productId: string; input: UpdateProductInput } = await request.json()

  return await client.mutate<UpdateProductMutation>({
    mutation: UpdateProductDocument,
    variables: { id: body.productId, input: body.input },
  })
}
