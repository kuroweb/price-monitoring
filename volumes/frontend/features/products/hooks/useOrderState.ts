import { parseAsString, useQueryState } from 'nuqs'
import { createSearchParamsCache, parseAsString as parseAsStringServer } from 'nuqs/server'

export const useOrderStateQuery = 'order'
const defaultValue = 'asc'

export const useOrderState = () => {
  return useQueryState(
    useOrderStateQuery,
    parseAsString.withDefault(defaultValue).withOptions({ shallow: false }),
  )
}

export const orderStateCache = createSearchParamsCache({
  [useOrderStateQuery]: parseAsStringServer.withDefault(defaultValue),
})
