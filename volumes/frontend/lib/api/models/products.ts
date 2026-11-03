export type Product = {
  id: number
  name: string
  enabled?: boolean
  searchUrls?: { url: string; enabled: boolean }[]
  createdAt: string
  updatedAt: string
}
