'use client'

import { useEffect, useState } from 'react'

import { getCurrentUser } from '@/features/auth/api/actions'
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

  if (currentUser) return <span className='px-3 text-sm'>{currentUser.name}</span>

  return (
    <a href='/auth/auth_provider' className='btn btn-ghost btn-sm'>
      ログイン・新規登録
    </a>
  )
}

export default AccountStatus
