interface Props {
  name: string
  deleting: boolean
  onEdit: () => void
  onDestroy: () => void
}

// 他の管理一覧と同じ「…」の操作メニュー。項目を横に並べてボタンの上下中央に揃え、閉じていても配置される
// メニューが表の外枠からはみ出してスクロールバーを出さないようにする
export default function SettingRowMenu({ name, deleting, onEdit, onDestroy }: Props) {
  return (
    <div className='dropdown dropdown-left dropdown-center'>
      <button type='button' aria-label={`${name}の操作`} className='btn btn-square btn-md'>
        <svg
          xmlns='http://www.w3.org/2000/svg'
          fill='none'
          viewBox='0 0 24 24'
          className='inline-block size-5 stroke-current'
        >
          <path
            strokeLinecap='round'
            strokeLinejoin='round'
            strokeWidth='2'
            d='M5 12h.01M12 12h.01M19 12h.01M6 12a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0z'
          ></path>
        </svg>
      </button>
      <ul className='menu menu-horizontal dropdown-content invisible pointer-events-none [.dropdown:focus-within_&]:visible [.dropdown:focus-within_&]:pointer-events-auto z-1 w-max flex-nowrap gap-2 rounded-box border border-base-300 bg-base-100 shadow-lg'>
        <li>
          <button type='button' className='btn btn-primary' onClick={onEdit}>
            編集
          </button>
        </li>
        <li>
          <button type='button' className='btn btn-error' disabled={deleting} onClick={onDestroy}>
            削除
          </button>
        </li>
      </ul>
    </div>
  )
}
