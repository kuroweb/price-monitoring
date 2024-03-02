import { parseAsBoolean, useQueryState } from 'nuqs'

export const useEditCrawlSettingModalQuery = 'edit_crawl_setting_modal'

export const useEditCrawlSettingModalState = () => {
  return useQueryState(useEditCrawlSettingModalQuery, parseAsBoolean.withDefault(false))
}
