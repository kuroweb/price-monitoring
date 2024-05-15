import { parseAsBoolean, useQueryState } from 'nuqs'

export const useBulkCreateRequiredKeywordModalQuery = 'bulk_create_required_keyword_modal'

export const useBulkCreateRequiredKeywordModalState = () => {
  return useQueryState(
    useBulkCreateRequiredKeywordModalQuery,
    parseAsBoolean.withDefault(false).withOptions({ shallow: false }),
  )
}
