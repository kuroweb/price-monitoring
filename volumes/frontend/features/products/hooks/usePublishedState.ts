import { parseAsBoolean, useQueryState } from 'nuqs'
import { createSearchParamsCache, parseAsBoolean as parseAsBooleanServer } from 'nuqs/server'

export const usePublishedStateQuery = 'published'
const defaultValue = true

export const usePublishedState = () => {
  return useQueryState(
    usePublishedStateQuery,
    parseAsBoolean.withDefault(defaultValue).withOptions({ shallow: false }),
  )
}

export const publishedStateCache = createSearchParamsCache({
  [usePublishedStateQuery]: parseAsBooleanServer.withDefault(defaultValue),
})
