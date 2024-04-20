import { parseAsBoolean, useQueryState } from 'nuqs'
import { createSearchParamsCache, parseAsBoolean as parseAsBooleanServer } from 'nuqs/server'

export const useYahooAuctionBuyableStateQuery = 'yahoo_auction_buyable'
const defaultValue = true

export const useYahooAuctionBuyableState = () => {
  return useQueryState(
    useYahooAuctionBuyableStateQuery,
    parseAsBoolean.withDefault(defaultValue).withOptions({ shallow: false }),
  )
}

export const yahooAuctionBuyableStateCache = createSearchParamsCache({
  [useYahooAuctionBuyableStateQuery]: parseAsBooleanServer.withDefault(defaultValue),
})
