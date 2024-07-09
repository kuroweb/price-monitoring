import { parseAsInteger, useQueryState } from 'nuqs'
import { createSearchParamsCache, parseAsInteger as parseAsIntegerServer } from 'nuqs/server'

export const usePerStateQuery = 'per'
const defaultValue = 100

export const usePerState = () => {
  return useQueryState(
    usePerStateQuery,
    parseAsInteger.withDefault(defaultValue).withOptions({ shallow: false }),
  )
}

export const perStateCache = createSearchParamsCache({
  [usePerStateQuery]: parseAsIntegerServer.withDefault(defaultValue),
})
