import { http } from '@/lib/http-client'

import type { CurrentUserResponse } from './types'

export async function getCurrentUser(cookie: string) {
  return http<CurrentUserResponse>('/api/v1/current_user', {
    method: 'GET',
    headers: { Cookie: cookie },
  })
}
