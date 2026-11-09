'use client'

import type { Dispatch, ReactNode, SetStateAction } from 'react'

import Link from 'next/link'
import { usePathname } from 'next/navigation'

type Props = {
  open: boolean
  setOpen: Dispatch<SetStateAction<boolean>>
}

type MenuItem = {
  label: string
  href: string
  icon: ReactNode
}

const iconClassName = 'size-6 shrink-0 text-gray-500'

const trendIcon = (
  <svg className={iconClassName} xmlns='http://www.w3.org/2000/svg' viewBox='0 0 48 48'>
    <defs>
      <mask id='ipSTrend0'>
        <g fill='none' strokeLinejoin='round' strokeWidth='4'>
          <path
            fill='#fff'
            stroke='#fff'
            d='M39 6H9a3 3 0 0 0-3 3v30a3 3 0 0 0 3 3h30a3 3 0 0 0 3-3V9a3 3 0 0 0-3-3Z'
          />
          <path stroke='#000' strokeLinecap='round' d='m13.44 29.835l5.657-5.657l4.388 4.377L34 18' />
          <path stroke='#000' strokeLinecap='round' d='M26 18h8v8' />
        </g>
      </mask>
    </defs>
    <path fill='currentColor' d='M0 0h48v48H0z' mask='url(#ipSTrend0)' />
  </svg>
)

const settingsIcon = (
  <svg
    className={iconClassName}
    fill='currentColor'
    viewBox='0 0 20 20'
    xmlns='http://www.w3.org/2000/svg'
  >
    <path d='M2 10a8 8 0 018-8v8h8a8 8 0 11-16 0z' />
    <path d='M12 2.252A8.014 8.014 0 0117.748 8H12V2.252z' />
  </svg>
)

const listIcon = (
  <svg className={iconClassName} xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'>
    <path
      fill='currentColor'
      d='M3 4a1 1 0 0 1 1-1h16a1 1 0 0 1 1 1v3H3zm0 5h18v11a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1zm4 3v2h10v-2zm0 4v2h7v-2z'
    />
  </svg>
)

const categoryIcon = (
  <svg className={iconClassName} xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'>
    <path
      fill='currentColor'
      d='M6.5 11L12 2l5.5 9zm11 11q-1.875 0-3.187-1.312T13 17.5t1.313-3.187T17.5 13t3.188 1.313T22 17.5t-1.312 3.188T17.5 22M3 21.5v-8h8v8z'
    />
  </svg>
)

const menuGroups: { title: string; items: MenuItem[] }[] = [
  {
    title: '商品計測',
    items: [
      { label: '商品モニタリング', href: '/product-monitoring', icon: settingsIcon },
      { label: '商品計測', href: '/product-crawl-results', icon: listIcon },
    ],
  },
  {
    title: 'Backmarket',
    items: [
      { label: '計測結果', href: '/backmarket', icon: listIcon },
      { label: '計測対象の管理', href: '/admin/backmarket', icon: settingsIcon },
    ],
  },
  {
    title: '商品',
    items: [
      { label: '最安値一覧', href: '/products', icon: trendIcon },
      { label: '計測対象の管理', href: '/admin/products', icon: settingsIcon },
    ],
  },
  {
    title: 'カテゴリ',
    items: [{ label: 'カテゴリ管理', href: '/admin/categories', icon: categoryIcon }],
  },
]

const isActive = (pathname: string, href: string) =>
  pathname === href || pathname.startsWith(`${href}/`)

const Sidebar = ({ open, setOpen }: Props) => {
  const pathname = usePathname()

  return (
    <>
      <aside
        className={`${
          open ? 'flex' : 'hidden'
        } transition-width fixed left-0 top-0 z-20 h-full w-64 shrink-0 flex-col pt-16 duration-75 md:flex`}
      >
        <div className='flex h-full min-h-0 flex-1 flex-col bg-base-300'>
          <nav className='flex flex-1 flex-col overflow-y-auto pb-4 pt-5'>
            {menuGroups.map((group) => (
              <div key={group.title} className='pb-4'>
                <p className='px-4 pb-2 text-sm font-normal text-gray-500'>{group.title}</p>
                <ul className='space-y-1'>
                  {group.items.map((item) => {
                    const active = isActive(pathname, item.href)

                    return (
                      <li key={item.href}>
                        <Link
                          href={item.href}
                          onClick={() => setOpen(false)}
                          aria-current={active ? 'page' : undefined}
                          className={`flex items-center rounded-lg px-4 py-2 text-base font-normal hover:bg-base-200 ${
                            active ? 'bg-base-200 font-semibold' : ''
                          }`}
                        >
                          {item.icon}
                          <span className='ml-3'>{item.label}</span>
                        </Link>
                      </li>
                    )
                  })}
                </ul>
              </div>
            ))}
          </nav>
        </div>
      </aside>
      <button
        type='button'
        aria-label='サイドバーを閉じる'
        onClick={() => setOpen(!open)}
        className={`${open ? '' : 'hidden'} fixed inset-0 z-10 bg-gray-900 opacity-50`}
      />
    </>
  )
}

export default Sidebar
