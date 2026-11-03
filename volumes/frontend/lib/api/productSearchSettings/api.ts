import { http } from '@/lib/http-client'

import type {
  ProductSearchDraft,
  ProductSearchPreview,
  ProductSearchSetting,
  ProductSearchSettingsList,
} from './types'

export const getProductSearchSettings = () =>
  http<ProductSearchSettingsList>('/api/v1/products/search_settings')
export const createProductSearchSetting = (draft: ProductSearchDraft) =>
  http<ProductSearchSetting>('/api/v1/products/search_settings', { method: 'POST', data: draft })
export const updateProductSearchSetting = (id: number, draft: ProductSearchDraft) =>
  http<ProductSearchSetting>(`/api/v1/products/${id}/search_settings`, {
    method: 'PUT',
    data: draft,
  })
export const deleteProductSearchSetting = (id: number) =>
  http(`/api/v1/products/${id}`, { method: 'DELETE' })
export const previewProductSearchSetting = (draft: ProductSearchDraft) =>
  http<ProductSearchPreview>('/api/v1/products/preview', { method: 'POST', data: draft })
