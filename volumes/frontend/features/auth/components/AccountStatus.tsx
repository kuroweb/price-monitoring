'use client'

import { useEffect, useState } from 'react'

import { getCurrentUser, logout } from '@/features/auth/api/actions'
import type { CurrentUser } from '@/features/auth/api/types'

const AccountStatus = () => {
  const [currentUser, setCurrentUser] = useState<CurrentUser | null>()

  useEffect(() => {
    getCurrentUser()
      .then(({ data }) => setCurrentUser(data?.currentUser ?? null))
      .catch(() => setCurrentUser(null))
  }, [])

  // 取得前にログインの入口を出すと、ログイン中でも一瞬表示されてしまう
  if (currentUser === undefined) return null

  if (currentUser) return (
    <details className='dropdown dropdown-end'>
      <summary className='btn btn-ghost btn-sm'>{currentUser.name}</summary>
      <ul className='menu dropdown-content z-10 w-40 rounded-box border border-base-300 bg-base-100 p-2 shadow-lg'>
        <li><a href='/mypage'>マイページ</a></li>
        <li><form action={logout}><button type='submit'>ログアウト</button></form></li>
      </ul>
    </details>
  )

  return (
    <a href='/auth/auth_provider' className='btn btn-ghost btn-sm'>
      ログイン・新規登録
    </a>
  )
}

export default AccountStatus
