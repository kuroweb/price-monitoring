import { parseAsBoolean, useQueryState } from 'nuqs'

export const useBulkDeleteExcludeKeywordModalQuery = 'bulk_delete_exclude_keyword_modal'

export const useBulkDeleteExcludeKeywordModalState = () => {
  return useQueryState(
    useBulkDeleteExcludeKeywordModalQuery,
    parseAsBoolean.withDefault(false).withOptions({ shallow: false }),
  )
}
