import { parseAsBoolean, useQueryState } from 'nuqs'

export const useCreateCategoryModalQuery = 'create_category_modal'

export const useCreateCategoryModalState = () => {
  return useQueryState(
    useCreateCategoryModalQuery,
    parseAsBoolean.withDefault(false).withOptions({ shallow: false }),
  )
}
