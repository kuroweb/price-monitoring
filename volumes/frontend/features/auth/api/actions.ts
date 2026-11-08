'use server'

import { cookies } from 'next/headers'

import * as Api from './currentUser'

export async function getCurrentUser() {
  // ログイン状態は BFF のセッション Cookie にあるので、サーバーから呼ぶときも引き継ぐ
  return await Api.getCurrentUser((await cookies()).toString())
}
