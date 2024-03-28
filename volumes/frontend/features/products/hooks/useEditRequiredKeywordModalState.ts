import { parseAsBoolean, useQueryState } from 'nuqs'

export const useEditRequiredKeywordModalQuery = 'edit_required_keyword_modal'

export const useEditRequiredKeywordModalState = () => {
  return useQueryState(
    useEditRequiredKeywordModalQuery,
    parseAsBoolean.withDefault(false).withOptions({ shallow: false }),
  )
}
