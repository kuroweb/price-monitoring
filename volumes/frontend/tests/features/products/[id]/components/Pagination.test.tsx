import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { NuqsTestingAdapter } from 'nuqs/adapters/testing'
import { describe, expect, it, vi } from 'vitest'

import Pagination from '@/features/products/[id]/components/Pagination'

describe('Pagination', () => {
  it('最初のページでは前のページへ移動できない', () => {
    render(
      <NuqsTestingAdapter>
        <Pagination />
      </NuqsTestingAdapter>,
    )

    expect(screen.getByRole('button', { name: '«' })).toBeDisabled()
    expect(screen.getByRole('button', { name: 'Page 1' })).toBeInTheDocument()
  })

  it.each([
    ['»', '3'],
    ['«', null],
  ])('%s を押すとページのクエリを %s に更新する（初期値は省略）', async (button, expectedPage) => {
    const user = userEvent.setup()
    const onUrlUpdate = vi.fn()
    render(
      <NuqsTestingAdapter searchParams='?page=2' onUrlUpdate={onUrlUpdate}>
        <Pagination />
      </NuqsTestingAdapter>,
    )

    expect(screen.getByRole('button', { name: 'Page 2' })).toBeInTheDocument()
    await user.click(screen.getByRole('button', { name: button }))

    expect(onUrlUpdate).toHaveBeenCalledOnce()
    expect(onUrlUpdate.mock.calls[0][0].searchParams.get('page')).toBe(expectedPage)
    expect(onUrlUpdate.mock.calls[0][0].options.shallow).toBe(false)
  })
})
