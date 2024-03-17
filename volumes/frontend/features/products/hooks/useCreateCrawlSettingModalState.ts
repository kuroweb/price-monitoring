import { parseAsBoolean, useQueryState } from 'nuqs'

export const useCreateCrawlSettingModalQuery = 'create_crawl_setting_modal'

export const useCreateCrawlSettingModalState = () => {
  return useQueryState(
    useCreateCrawlSettingModalQuery,
    parseAsBoolean.withDefault(false).withOptions({ shallow: false }),
  )
}
