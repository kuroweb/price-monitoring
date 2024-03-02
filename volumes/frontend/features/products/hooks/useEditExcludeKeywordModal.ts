import { parseAsBoolean, useQueryState } from 'nuqs'

export const useEditExcludeKeywordModalQuery = 'create_crawl_setting_modal'

export const useEditExcludeKeywordModal = () => {
  return useQueryState(useEditExcludeKeywordModalQuery, parseAsBoolean.withDefault(false))
}
