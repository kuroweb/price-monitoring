import MoreIcon from './MoreIcon'

interface Props {
  name: string
  deleting: boolean
  onEdit: () => void
  // 渡した一覧だけ「複製」を出す
  onDuplicate?: () => void
  onDestroy: () => void
}

// 他の管理一覧と同じ「…」の操作メニュー。項目を横に並べてボタンの上下中央に揃え、閉じていても配置される
// メニューが表の外枠からはみ出してスクロールバーを出さないようにする
export default function SettingRowMenu({ name, deleting, onEdit, onDuplicate, onDestroy }: Props) {
  return (
    <div className='dropdown dropdown-left dropdown-center'>
      <button type='button' aria-label={`${name}の操作`} className='btn btn-square btn-md'>
        <MoreIcon />
      </button>
      <ul className='menu menu-horizontal dropdown-content invisible pointer-events-none [.dropdown:focus-within_&]:visible [.dropdown:focus-within_&]:pointer-events-auto z-1 w-max flex-nowrap gap-2 rounded-box border border-base-300 bg-base-100 shadow-lg'>
        <li>
          <button type='button' className='btn btn-primary' onClick={onEdit}>
            編集
          </button>
        </li>
        {onDuplicate && (
          <li>
            <button type='button' className='btn' onClick={onDuplicate}>
              複製
            </button>
          </li>
        )}
        <li>
          <button type='button' className='btn btn-error' disabled={deleting} onClick={onDestroy}>
            削除
          </button>
        </li>
      </ul>
    </div>
  )
}
