import { revalidatePath } from 'next/cache'

type RevalidatePathArgs = Parameters<typeof revalidatePath>

export const revalidatePaths = (pathnames: RevalidatePathArgs[]) => {
  pathnames.forEach((path) => {
    revalidatePath(...path)
  })
}
