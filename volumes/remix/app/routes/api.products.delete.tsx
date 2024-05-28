import { ActionFunctionArgs } from '@remix-run/node'

import { DeleteProductDocument, DeleteProductMutation } from '@/graphql/dist/client'
import client from '@/lib/apollo-client'

export const action = async ({ request }: ActionFunctionArgs) => {
  const body: { productId: string } = await request.json()

  return await client.mutate<DeleteProductMutation>({
    mutation: DeleteProductDocument,
    variables: { id: body.productId },
  })
}
