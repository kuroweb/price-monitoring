export const makePlatformMask = (platform: string, status: string) => {
  const defaultMask =
    'yahoo_auction.buyable,yahoo_fleamarket.published,mercari.published,pc_koubou.all'

  const platformMaskMap: { [key: string]: { [key: string]: string } } = {
    all: {
      published: defaultMask,
      unpublished: 'yahoo_auction.unpublished,yahoo_fleamarket.unpublished,mercari.unpublished',
    },
    yahoo_auction: { published: 'yahoo_auction.buyable', unpublished: 'yahoo_auction.unpublished' },
    yahoo_fleamarket: {
      published: 'yahoo_fleamarket.published',
      unpublished: 'yahoo_fleamarket.unpublished',
    },
    mercari: { published: 'mercari.published', unpublished: 'mercari.unpublished' },
    pc_koubou: { published: 'pc_koubou.all', unpublished: 'pc_koubou.all' },
  }

  return platformMaskMap[platform]?.[status] || defaultMask
}
