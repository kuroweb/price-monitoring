'use client'

import { useState } from 'react'

import { useRouter } from 'next/navigation'
import { toast } from 'react-toastify'

import BackmarketWatchTargetFormModal from './BackmarketWatchTargetFormModal'

import type { BackmarketWatchTarget, BackmarketWatchTargetList } from '@/lib/api'

import { destroyBackmarketWatchTarget } from '@/lib/actions'

interface Props {
  backmarketWatchTargets: BackmarketWatchTargetList['backmarketWatchTargets']
}

const BackmarketWatchTargetsTable = ({ backmarketWatchTargets }: Props) => {
  const router = useRouter()
  const [selectedTarget, setSelectedTarget] = useState<BackmarketWatchTarget | undefined>(undefined)
  const [createModalOpen, setCreateModalOpen] = useState(false)
  const [editModalOpen, setEditModalOpen] = useState(false)

  const submitDestroyBackmarketWatchTarget = async (backmarketWatchTargetId: number) => {
    const res = await destroyBackmarketWatchTarget(backmarketWatchTargetId)

    if (res.status === 200) {
      toast.success('success')
    } else {
      toast.error('error')
    }
    router.refresh()
  }

  return (
    <>
      <div className='flex justify-end pb-2'>
        <button className='btn' onClick={() => setCreateModalOpen(true)}>
          監視対象を追加
        </button>
      </div>
      <div className='overflow-x-auto'>
        <table className='table min-w-[720px]'>
          <thead>
            <tr>
              <th>名前</th>
              <th>URL</th>
              <th>有効</th>
              <th></th>
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
                  <td className='w-1/12'>
                    <div className={`dropdown dropdown-left ${isLastRow ? 'dropdown-top' : ''}`}>
                      <div tabIndex={0} role='button' className='btn btn-square btn-md'>
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
                      </div>
                      <ul
                        tabIndex={0}
                        className='menu dropdown-content z-1 w-20 space-y-2 rounded-box border border-base-300 bg-base-100 shadow-lg'
                      >
                        <li>
                          <button
                            className='btn btn-primary'
                            onClick={() => {
                              setSelectedTarget(target)
                              setEditModalOpen(true)
                            }}
                          >
                            編集
                          </button>
                        </li>
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
                            onClick={() => submitDestroyBackmarketWatchTarget(target.id)}
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
