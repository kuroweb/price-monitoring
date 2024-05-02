import { parseAsString, useQueryState } from 'nuqs'
import { createSearchParamsCache, parseAsString as parseAsStringServer } from 'nuqs/server'

export const usePlatformMaskStateQuery = 'platform_mask'
const defaultValue = "yahoo_auction,yahoo_fleamarket,mercari,janpara"

export const usePlatformMaskState = () => {
  return useQueryState(
    usePlatformMaskStateQuery,
    parseAsString.withDefault(defaultValue).withOptions({ shallow: false }),
  )
}

export const platformMaskStateCache = createSearchParamsCache({
  [usePlatformMaskStateQuery]: parseAsStringServer.withDefault(defaultValue),
})
