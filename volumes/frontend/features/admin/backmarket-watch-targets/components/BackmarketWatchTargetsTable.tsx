'use client'

import { useRef, useState } from 'react'

import { useRouter } from 'next/navigation'
import { toast } from 'react-toastify'

import { destroyBackmarketWatchTarget } from '@/lib/actions'
import type { BackmarketWatchTarget, BackmarketWatchTargetList } from '@/lib/api'

import BackmarketWatchTargetFormModal from './BackmarketWatchTargetFormModal'

interface Props {
  backmarketWatchTargets: BackmarketWatchTargetList['backmarketWatchTargets']
}

const BackmarketWatchTargetsTable = ({ backmarketWatchTargets }: Props) => {
  const router = useRouter()
  const [selectedTarget, setSelectedTarget] = useState<BackmarketWatchTarget | undefined>(undefined)
  const [createModalOpen, setCreateModalOpen] = useState(false)
  const [editModalOpen, setEditModalOpen] = useState(false)
  const [deletingTargetId, setDeletingTargetId] = useState<number | undefined>()
  const deletingRef = useRef(false)

  const submitDestroyBackmarketWatchTarget = async (target: BackmarketWatchTarget) => {
    if (deletingRef.current) return
    if (!window.confirm(`計測対象「${target.name}」を削除しますか？`)) return
    deletingRef.current = true
    setDeletingTargetId(target.id)
    let succeeded = false
    try {
      const res = await destroyBackmarketWatchTarget(target.id)

      if (res.status === 200) {
        toast.success('計測対象を削除しました')
      } else {
        toast.error('計測対象の削除に失敗しました')
      }
      succeeded = res.status === 200
    } catch {
      toast.error('計測対象の削除に失敗しました')
    } finally {
      deletingRef.current = false
      setDeletingTargetId(undefined)
    }
    if (!succeeded) return
    router.refresh()
  }

  return (
    <>
      <div className='flex justify-end pb-2'>
        <button className='btn' onClick={() => setCreateModalOpen(true)}>
          計測対象を追加
        </button>
      </div>
      <div className='overflow-x-auto'>
        <table className='table min-w-[720px]'>
          <thead>
            <tr>
              <th>名前</th>
              <th>URL</th>
              <th>有効</th>
              <th colSpan={2}>操作</th>
            </tr>
          </thead>
          <tbody>
            {backmarketWatchTargets.map((target, index) => {
              const isLastRow = index === backmarketWatchTargets.length - 1

              return (
                <tr key={target.id}>
                  <td className='whitespace-normal wrap-break-word'>{target.name}</td>
                  <td className='whitespace-nowrap'>{target.url}</td>
                  <td>{target.enabled ? '有効' : '無効'}</td>
                  <td>
                    <button
                      type='button'
                      className='btn btn-primary btn-sm'
                      onClick={() => {
                        setSelectedTarget(target)
                        setEditModalOpen(true)
                      }}
                    >
                      計測設定
                    </button>
                  </td>
                  <td className='w-1/12'>
                    <div className={`dropdown dropdown-left ${isLastRow ? 'dropdown-top' : ''}`}>
                      <button
                        type='button'
                        aria-label={`${target.name}の操作`}
                        className='btn btn-square btn-md'
                      >
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
                      <ul className='menu dropdown-content z-1 w-20 space-y-2 rounded-box border border-base-300 bg-base-100 shadow-lg'>
                        <li>
                          <button
                            className='btn btn-success'
                            onClick={() => {
                              setSelectedTarget(target)
                              setCreateModalOpen(true)
                            }}
                          >
                            複製
                          </button>
                        </li>
                        <li>
                          <button
                            className='btn btn-error'
                            disabled={deletingTargetId !== undefined}
                            onClick={() => submitDestroyBackmarketWatchTarget(target)}
                          >
                            削除
                          </button>
                        </li>
                      </ul>
                    </div>
                  </td>
                </tr>
              )
            })}
            {backmarketWatchTargets.length === 0 && (
              <tr>
                <td colSpan={5} className='py-8 text-center'>
                  計測対象はまだありません。「計測対象を追加」から登録してください。
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
      <BackmarketWatchTargetFormModal
        isOpen={createModalOpen}
        onClose={() => {
          setCreateModalOpen(false)
          setSelectedTarget(undefined)
        }}
        target={selectedTarget}
        mode='create'
      />
      <BackmarketWatchTargetFormModal
        isOpen={editModalOpen}
        onClose={() => {
          setEditModalOpen(false)
          setSelectedTarget(undefined)
        }}
        target={selectedTarget}
        mode='edit'
      />
    </>
  )
}

export default BackmarketWatchTargetsTable
