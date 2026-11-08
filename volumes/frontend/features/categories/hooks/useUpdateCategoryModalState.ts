import { parseAsBoolean, useQueryState } from 'nuqs'

export const useUpdateCategoryModalQuery = 'update_category_modal'

export const useUpdateCategoryModalState = () => {
  return useQueryState(
    useUpdateCategoryModalQuery,
    parseAsBoolean.withDefault(false).withOptions({ shallow: false }),
  )
}
