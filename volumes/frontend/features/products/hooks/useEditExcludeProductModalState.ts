import { parseAsBoolean, useQueryState } from 'nuqs'

export const useEditExcludeProductModalQuery = 'edit_exclude_product_modal'

export const useEditExcludeProductModalState = () => {
  return useQueryState(
    useEditExcludeProductModalQuery,
    parseAsBoolean.withDefault(false).withOptions({ shallow: false }),
  )
}
