export const makePlatformMask = (platform: string, status: string) => {
  const defaultMask = ''

  const platformMaskMap: { [key: string]: { [key: string]: string } } = {
    all: {
      published: defaultMask,
      unpublished: '',
    },
  }

  return platformMaskMap[platform]?.[status] || defaultMask
}
