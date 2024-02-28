import { parseAsString, useQueryState } from 'nuqs'

export const useCreateCrawlSettingModal = () => {
  return useQueryState('create_crawl_setting_modal', parseAsString.withDefault('close'))
}
