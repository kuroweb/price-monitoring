import { parseAsString, useQueryState } from 'nuqs'
import { createSearchParamsCache, parseAsString as parseAsStringServer } from 'nuqs/server'

export const usePlatformStateQuery = 'platform'
const defaultValue = 'all'

export const usePlatformState = () => {
  return useQueryState(
    usePlatformStateQuery,
    parseAsString.withDefault(defaultValue).withOptions({ shallow: false }),
  )
}

export const platformStateCache = createSearchParamsCache({
  [usePlatformStateQuery]: parseAsStringServer.withDefault(defaultValue),
})
