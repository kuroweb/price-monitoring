import { parseAsBoolean, useQueryState } from 'nuqs'

export const useUpdateProductModalQuery = 'update_product_modal'

export const useUpdateProductModalState = () => {
  return useQueryState(
    useUpdateProductModalQuery,
    parseAsBoolean.withDefault(false).withOptions({ shallow: false }),
  )
}
