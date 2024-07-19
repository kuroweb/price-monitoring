import { revalidatePath } from 'next/cache'

type RevalidatePathArgs = Parameters<typeof revalidatePath>

// Utils

export const revalidatePaths = (pathnames: RevalidatePathArgs[]) => {
  pathnames.forEach((path) => {
    revalidatePath(...path)
  })
}

/*
  /admin
*/

export const revalidateAdminPaths = () => {
  revalidateAdminProductsPaths()
  revalidateAdminCategoriesPaths()
}

// /admin/products
export const revalidateAdminProductsPaths = () => {
  revalidatePaths([
    ['/admin/products', 'page'],
    ['/admin/products/[id]', 'page'],
  ])
}

// /admin/categories
export const revalidateAdminCategoriesPaths = () => {
  revalidatePaths([['/admin/categories', 'page']])
}

/*
  /products
*/

export const revalidateProductsPaths = () => {
  revalidatePaths([
    ['/products', 'page'],
    ['/products/[id]', 'page'],
    ['/products/categories/[...category]', 'page'],
  ])
}
