import { parseAsBoolean, useQueryState } from 'nuqs'

export const useBulkCreateExcludeKeywordModalQuery = 'bulk_create_exclude_keyword_modal'

export const useBulkCreateExcludeKeywordModalState = () => {
  return useQueryState(
    useBulkCreateExcludeKeywordModalQuery,
    parseAsBoolean.withDefault(false).withOptions({ shallow: false }),
  )
}
