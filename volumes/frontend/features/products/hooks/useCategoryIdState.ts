import { parseAsInteger, useQueryState } from 'nuqs'
import { createSearchParamsCache, parseAsInteger as parseAsIntegerServer } from 'nuqs/server'

export const useCategoryIdStateQuery = 'category_id'
const defaultValue = -1

export const useCategoryIdState = () => {
  return useQueryState(
    useCategoryIdStateQuery,
    parseAsInteger.withDefault(defaultValue).withOptions({ shallow: false }),
  )
}

export const categoryIdStateCache = createSearchParamsCache({
  [useCategoryIdStateQuery]: parseAsIntegerServer.withDefault(defaultValue),
})
