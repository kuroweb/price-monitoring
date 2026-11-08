import MoreIcon from './MoreIcon'

interface Props {
  name: string
  deleting: boolean
  onEdit: () => void
  // 渡した一覧だけ「複製」を出す
  onDuplicate?: () => void
  onDestroy: () => void
}

// 設定の操作をボタンの右端に揃えた縦メニューで表示する
export default function SettingRowMenu({ name, deleting, onEdit, onDuplicate, onDestroy }: Props) {
  return (
    <div className='dropdown dropdown-end'>
      <button type='button' aria-label={`${name}の操作`} className='btn btn-square btn-md'>
        <MoreIcon />
      </button>
      <ul className='menu dropdown-content invisible pointer-events-none [.dropdown:focus-within_&]:visible [.dropdown:focus-within_&]:pointer-events-auto z-1 w-32 rounded-box border border-base-300 bg-base-100 p-2 shadow-lg max-sm:w-20'>
        <li>
          <button type='button' onClick={onEdit}>
            編集
          </button>
        </li>
        {onDuplicate && (
          <li>
            <button type='button' onClick={onDuplicate}>
              複製
            </button>
          </li>
        )}
        <li>
          <button type='button' className='text-error' disabled={deleting} onClick={onDestroy}>
            削除
          </button>
        </li>
      </ul>
    </div>
  )
}
