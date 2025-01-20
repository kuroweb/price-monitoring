import { parseAsBoolean, useQueryState } from 'nuqs'

export const useBulkEditExcludeKeywordModalQuery = 'bulk_edit_exclude_keyword_modal'

export const useBulkEditExcludeKeywordModalState = () => {
  return useQueryState(
    useBulkEditExcludeKeywordModalQuery,
    parseAsBoolean.withDefault(false).withOptions({ shallow: false }),
  )
}
