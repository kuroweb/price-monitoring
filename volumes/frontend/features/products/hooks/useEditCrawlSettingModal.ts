import { parseAsBoolean, useQueryState } from 'nuqs'

export const useEditCrawlSettingModal = () => {
  return useQueryState('edit_crawl_setting_modal', parseAsBoolean.withDefault(false))
}
