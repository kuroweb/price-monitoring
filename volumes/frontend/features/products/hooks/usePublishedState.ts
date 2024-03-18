import { parseAsBoolean, useQueryState } from 'nuqs'
import { createSearchParamsCache, parseAsBoolean as parseAsBooleanServer } from 'nuqs/server'

export const usePublishedStateQuery = 'published'

export const usePublishedState = () => {
  return useQueryState(
    usePublishedStateQuery,
    parseAsBoolean.withDefault(true).withOptions({ shallow: false }),
  )
}

export const publishedStateCache = createSearchParamsCache({
  [usePublishedStateQuery]: parseAsBooleanServer.withDefault(true),
})
