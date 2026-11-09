import { redirect } from 'next/navigation'
import { describe, expect, it, vi } from 'vitest'

import Page from '@/app/page'

vi.mock('next/navigation', () => ({ redirect: vi.fn() }))

describe('トップページ', () => {
  it('商品モニタリングへ移動すること', async () => {
    await Page()

    expect(redirect).toHaveBeenCalledWith('/product-monitoring')
  })
})
