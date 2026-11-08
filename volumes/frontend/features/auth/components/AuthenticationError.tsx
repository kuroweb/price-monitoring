const AuthenticationError = () => (
  <div role='alert' className='alert alert-error mb-4'>
    <span>ログインに失敗しました。もう一度お試しください。</span>
    <a href='/auth/auth_provider' className='btn btn-sm'>再試行</a>
  </div>
)

export default AuthenticationError
