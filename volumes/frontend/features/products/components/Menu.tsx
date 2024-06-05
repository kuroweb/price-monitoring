'use client'

import Link from 'next/link'
import { usePathname, useParams } from 'next/navigation'

const Menu = () => {
  const params = useParams()
  const pathname = usePathname()

  const product_detail_path = `/products/${params.id}`
  const product_settings_path = `/products/${params.id}/settings`

  return (
    <>
      <div className='tabs tabs-bordered pb-2'>
        <Link
          className={`tab ${pathname === product_detail_path && 'tab-active'}`}
          href={{
            pathname: product_detail_path,
          }}
        >
          計測結果
        </Link>
        <Link
          className={`tab ${pathname === product_settings_path && 'tab-active'}`}
          href={{
            pathname: product_settings_path,
          }}
        >
          設定
        </Link>
      </div>
    </>
  )
}

export default Menu
