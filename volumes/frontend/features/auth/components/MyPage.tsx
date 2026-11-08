import { getCurrentUser } from '@/features/auth/api/actions'

const MyPage = async () => {
  const { data, error } = await getCurrentUser()
  if (error) throw new Error('ユーザー情報を取得できませんでした')

  return (
    <div className='card bg-base-300'>
      <div className='card-body'>
        <h1 className='card-title'>マイページ</h1>
        {data?.currentUser ? (
          <dl>
            <dt>名前</dt><dd>{data.currentUser.name}</dd>
            <dt>メールアドレス</dt><dd>{data.currentUser.email}</dd>
          </dl>
        ) : <a href='/auth/auth_provider' className='link'>ログイン・新規登録</a>}
      </div>
    </div>
  )
}

export default MyPage
