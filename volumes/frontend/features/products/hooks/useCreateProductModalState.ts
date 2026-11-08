import { parseAsBoolean, useQueryState } from 'nuqs'

export const useCreateProductModalQuery = 'create_product_modal'

export const useCreateProductModalState = () => {
  return useQueryState(
    useCreateProductModalQuery,
    parseAsBoolean.withDefault(false).withOptions({ shallow: false }),
  )
}
