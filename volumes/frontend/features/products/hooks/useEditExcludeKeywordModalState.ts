import { parseAsBoolean, useQueryState } from 'nuqs'

export const useEditExcludeKeywordModalQuery = 'edit_exclude_keyword_modal'

export const useEditExcludeKeywordModalState = () => {
  return useQueryState(
    useEditExcludeKeywordModalQuery,
    parseAsBoolean.withDefault(false).withOptions({ shallow: false }),
  )
}
