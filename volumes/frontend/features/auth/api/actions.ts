'use server'

import { cookies } from 'next/headers'
import { redirect } from 'next/navigation'

import { http } from '@/lib/http-client'

import * as Api from './currentUser'

export async function getCurrentUser() {
  // ログイン状態は BFF のセッション Cookie にあるので、サーバーから呼ぶときも引き継ぐ
  return await Api.getCurrentUser((await cookies()).toString())
}

export async function logout() {
  const cookie = (await cookies()).toString()
  const token = await http<{ csrfToken: string }>('/auth/csrf_token', { headers: { Cookie: cookie } })
  if (!token.data?.csrfToken) throw new Error('ログアウトできませんでした')

  const response = await http('/logout', {
    method: 'DELETE',
    headers: { Cookie: cookie, 'X-CSRF-Token': token.data.csrfToken },
  })
  if (response.status !== 303) throw new Error('ログアウトできませんでした')
  redirect('/')
}
