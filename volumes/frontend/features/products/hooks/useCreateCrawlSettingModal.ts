import { parseAsBoolean, useQueryState } from 'nuqs'

export const useCreateCrawlSettingModalQuery = 'create_crawl_setting_modal'

export const useCreateCrawlSettingModal = () => {
  return useQueryState(useCreateCrawlSettingModalQuery, parseAsBoolean.withDefault(false))
}
