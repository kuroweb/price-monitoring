export const makePlatformMask = (platform: string, status: string) => {
  const defaultMask = 'yahoo_auction.buyable,yahoo_fleamarket.published'

  const platformMaskMap: { [key: string]: { [key: string]: string } } = {
    all: {
      published: defaultMask,
      unpublished: 'yahoo_auction.unpublished,yahoo_fleamarket.unpublished',
    },
    yahoo_auction: { published: 'yahoo_auction.buyable', unpublished: 'yahoo_auction.unpublished' },
    yahoo_fleamarket: {
      published: 'yahoo_fleamarket.published',
      unpublished: 'yahoo_fleamarket.unpublished',
    },
  }

  return platformMaskMap[platform]?.[status] || defaultMask
}
