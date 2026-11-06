import { parseAsString, useQueryState } from 'nuqs'
import { createSearchParamsCache, parseAsString as parseAsStringServer } from 'nuqs/server'

export const useSortStateQuery = 'sort'
const defaultValue = 'updated_at'

export const useSortState = () => {
  return useQueryState(
    useSortStateQuery,
    parseAsString.withDefault(defaultValue).withOptions({ shallow: false }),
  )
}

export const sortStateCache = createSearchParamsCache({
  [useSortStateQuery]: parseAsStringServer.withDefault(defaultValue),
})
