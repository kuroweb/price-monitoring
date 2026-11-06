'use client'

import { useRef, useState } from 'react'

import { useRouter } from 'next/navigation'
import { toast } from 'react-toastify'

import SettingRowMenu from '@/components/ui/SettingRowMenu'
import { destroyProductCrawlSetting } from '@/features/product-monitoring/api/actions'
import type { ProductCrawlSetting } from '@/features/product-monitoring/api/types'

import ProductCrawlSettingFormModal from './ProductCrawlSettingFormModal'

type ModalState = { setting?: ProductCrawlSetting } | null

export default function ProductCrawlSettings({
  productCrawlSettings,
}: {
  productCrawlSettings: ProductCrawlSetting[]
}) {
  const router = useRouter()
  const [modal, setModal] = useState<ModalState>(null)
  const [deletingId, setDeletingId] = useState<number | undefined>()
  const deletingRef = useRef(false)

  const destroy = async (setting: ProductCrawlSetting) => {
    if (deletingRef.current) return
    if (!window.confirm(`商品計測設定「${setting.name}」を削除しますか？`)) return
    deletingRef.current = true
    setDeletingId(setting.id)
    try {
      const result = await destroyProductCrawlSetting(setting.id)
      if (result.status !== 200) {
        toast.error('商品計測設定の削除に失敗しました')
        return
      }
      toast.success('商品計測設定を削除しました')
      router.refresh()
    } catch {
      toast.error('商品計測設定の削除に失敗しました')
    } finally {
      deletingRef.current = false
      setDeletingId(undefined)
    }
  }

  return (
    <>
      <div className='flex justify-end pb-2'>
        <button type='button' className='btn' onClick={() => setModal({})}>
          商品計測設定を追加
        </button>
      </div>
      <div className='overflow-x-auto'>
        <table className='table min-w-[640px]'>
          <thead>
            <tr>
              <th>名前</th>
              <th>有効</th>
              <th>URL数</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            {productCrawlSettings.map((setting) => (
              <tr key={setting.id}>
                <td className='whitespace-normal wrap-break-word'>{setting.name}</td>
                <td>{setting.enabled ? '有効' : '無効'}</td>
                <td>{setting.searchUrls.length}</td>
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
            {productCrawlSettings.length === 0 && (
              <tr>
                <td colSpan={4} className='py-8 text-center'>
                  商品計測設定はまだありません。「商品計測設定を追加」から登録してください。
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
      {modal && (
        <ProductCrawlSettingFormModal setting={modal.setting} onClose={() => setModal(null)} />
      )}
    </>
  )
}
