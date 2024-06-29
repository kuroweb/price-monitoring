import { revalidatePath } from 'next/cache'

type RevalidatePathArgs = Parameters<typeof revalidatePath>

export const revalidatePaths = (pathnames: RevalidatePathArgs[]) => {
  pathnames.forEach((path) => {
    revalidatePath(...path)
  })
}

export const revalidateProductPaths = () => {
  revalidatePaths([
    [`/`, 'page'],
    [`/products/[id]`, 'page'],
    ['/products/[id]/settings', 'page'],
    ['/recommends', 'page'],
  ])
}

export const revalidateCategoryPaths = () => {
  revalidatePaths([['/categories', 'page']])
}
