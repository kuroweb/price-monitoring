import { revalidatePath } from 'next/cache'

type RevalidatePathArgs = Parameters<typeof revalidatePath>

// Utils

export const revalidatePaths = (pathnames: RevalidatePathArgs[]) => {
  pathnames.forEach((path) => {
    revalidatePath(...path)
  })
}

// /admin

export const revalidateAdminPaths = () => {
  revalidateAdminProductPaths()
  revalidateAdminCategoryPaths()
}

export const revalidateAdminProductPaths = () => {
  revalidatePaths([
    ['/admin/products', 'page'],
    ['/admin/products/[id]', 'page'],
  ])
}

export const revalidateAdminCategoryPaths = () => {
  revalidatePaths([['/admin/categories', 'page']])
}

// /products

export const revalidateProductPaths = () => {
  revalidatePaths([
    ['/products', 'page'],
    ['/products/[id]', 'page'],
    ['/products/categories/[...category]', 'page'],
  ])
}
