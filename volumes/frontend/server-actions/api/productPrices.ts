'use server'

import * as Api from '@/api'

export async function getProductPrices(params: Api.GetProductPricesParams) {
  return await Api.getProductPrices(params)
}

export async function getProductPrice(productId: number, params: Api.GetProductPriceParams) {
  return await Api.getProductPrice(productId, params)
}
