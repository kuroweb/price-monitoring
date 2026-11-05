'use client'

import { useRef, useState } from 'react'

import { useRouter } from 'next/navigation'
import { toast } from 'react-toastify'

import SettingRowMenu from '@/features/admin/product-crawl-settings/components/SettingRowMenu'
import { destroyProductAggregationSetting } from '@/lib/actions'
import type { ProductAggregationSetting } from '@/lib/api'

import ProductAggregationSettingFormModal from './ProductAggregationSettingFormModal'

type ModalState = { setting?: ProductAggregationSetting } | null

export default function ProductAggregationSettings({
  productAggregationSettings,
}: {
  productAggregationSettings: ProductAggregationSetting[]
}) {
  const router = useRouter()
  const [modal, setModal] = useState<ModalState>(null)
  const [deletingId, setDeletingId] = useState<number | undefined>()
  const deletingRef = useRef(false)

  const destroy = async (setting: ProductAggregationSetting) => {
    if (deletingRef.current) return
    if (!window.confirm(`商品相場設定「${setting.name}」を削除しますか？`)) return
    deletingRef.current = true
    setDeletingId(setting.id)
    try {
      const result = await destroyProductAggregationSetting(setting.id)
      if (result.status !== 200) {
        toast.error('商品相場設定の削除に失敗しました')
        return
      }
      toast.success('商品相場設定を削除しました')
      router.refresh()
    } catch {
      toast.error('商品相場設定の削除に失敗しました')
    } finally {
      deletingRef.current = false
      setDeletingId(undefined)
    }
  }

  return (
    <>
      <div className='flex justify-end pb-2'>
        <button type='button' className='btn' onClick={() => setModal({})}>
          商品相場設定を追加
        </button>
      </div>
      <div className='overflow-x-auto'>
        <table className='table min-w-[640px]'>
          <thead>
            <tr>
              <th>名前</th>
              <th>必須語</th>
              <th>除外語</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            {productAggregationSettings.map((setting) => (
              <tr key={setting.id}>
                <td className='whitespace-normal wrap-break-word'>{setting.name}</td>
                <td>{setting.requiredKeywords.join('、') || '-'}</td>
                <td>{setting.excludeKeywords.join('、') || '-'}</td>
                <td className='w-1/12'>
                  <SettingRowMenu
                    name={setting.name}
                    deleting={deletingId !== undefined}
                    onEdit={() => setModal({ setting })}
                    onDestroy={() => destroy(setting)}
                  />
                </td>
              </tr>
            ))}
            {productAggregationSettings.length === 0 && (
              <tr>
                <td colSpan={4} className='py-8 text-center'>
                  商品相場設定はまだありません。「商品相場設定を追加」から登録してください。
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
      {modal && (
        <ProductAggregationSettingFormModal
          setting={modal.setting}
          onClose={() => setModal(null)}
        />
      )}
    </>
  )
}
