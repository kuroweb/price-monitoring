import { parseAsBoolean, useQueryState } from 'nuqs'

export const useBulkEditRequiredKeywordModalQuery = 'bulk_edit_required_keyword_modal'

export const useBulkEditRequiredKeywordModalState = () => {
  return useQueryState(
    useBulkEditRequiredKeywordModalQuery,
    parseAsBoolean.withDefault(false).withOptions({ shallow: false }),
  )
}
