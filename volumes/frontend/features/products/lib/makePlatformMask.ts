export const makePlatformMask = (platform: string, status: string) => {
  const defaultMask = 'yahoo_auction.buyable'

  const platformMaskMap: { [key: string]: { [key: string]: string } } = {
    all: {
      published: defaultMask,
      unpublished: 'yahoo_auction.unpublished',
    },
    yahoo_auction: { published: 'yahoo_auction.buyable', unpublished: 'yahoo_auction.unpublished' },
  }

  return platformMaskMap[platform]?.[status] || defaultMask
}
