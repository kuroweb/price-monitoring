import { parseAsString, useQueryState } from 'nuqs'
import { createSearchParamsCache, parseAsString as parseAsStringServer } from 'nuqs/server'

export const useStatusStateQuery = 'status'
const defaultValue = 'published'

export const useStatusState = () => {
  return useQueryState(
    useStatusStateQuery,
    parseAsString.withDefault(defaultValue).withOptions({ shallow: false }),
  )
}

export const statusStateCache = createSearchParamsCache({
  [useStatusStateQuery]: parseAsStringServer.withDefault(defaultValue),
})
