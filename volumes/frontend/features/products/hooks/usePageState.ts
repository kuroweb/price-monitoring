import { parseAsInteger, useQueryState } from 'nuqs'
import { createSearchParamsCache, parseAsInteger as parseAsIntegerServer } from 'nuqs/server'

export const usePageStateQuery = 'page'
const defaultValue = 1

export const usePageState = () => {
  return useQueryState(
    usePageStateQuery,
    parseAsInteger.withDefault(defaultValue).withOptions({ shallow: false }),
  )
}

export const pageStateCache = createSearchParamsCache({
  [usePageStateQuery]: parseAsIntegerServer.withDefault(defaultValue),
})
