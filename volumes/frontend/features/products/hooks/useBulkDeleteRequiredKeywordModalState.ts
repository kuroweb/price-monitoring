import { parseAsBoolean, useQueryState } from 'nuqs'

export const useBulkDeleteRequiredKeywordModalQuery = 'bulk_delete_required_keyword_modal'

export const useBulkDeleteRequiredKeywordModalState = () => {
  return useQueryState(
    useBulkDeleteRequiredKeywordModalQuery,
    parseAsBoolean.withDefault(false).withOptions({ shallow: false }),
  )
}
