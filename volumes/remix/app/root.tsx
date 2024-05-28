import { useState } from 'react'

import { LinksFunction } from '@remix-run/node'
import { Links, Meta, Outlet, Scripts, ScrollRestoration } from '@remix-run/react'

import ToastProvider from '../lib/toast-provider'

import stylesheet from './tailwind.css?url'

import Header from '@/components/Header'
import Sidebar from '@/components/Sidebar'

export const links: LinksFunction = () => [{ rel: 'stylesheet', href: stylesheet }]

export function Layout({ children }: { children: React.ReactNode }) {
  const [open, setOpen] = useState<boolean>(false)

  return (
    <html lang='ja'>
      <head>
        <meta charSet='utf-8' />
        <meta name='viewport' content='width=device-width, initial-scale=1' />
        <Meta />
        <Links />
      </head>
      <body>
        <div className='h-svh' data-theme='dark'>
          <div className='flex h-full overflow-hidden'>
            <Header open={open} setOpen={setOpen} />
            <Sidebar open={open} setOpen={setOpen} />
            <div className='h-full w-full overflow-y-auto md:pl-64'>
              <main>
                <div className='pt-20 p-4'>
                  <main>
                    <ToastProvider>{children}</ToastProvider>
                  </main>
                </div>
              </main>
            </div>
          </div>
        </div>
        <ScrollRestoration />
        <Scripts />
      </body>
    </html>
  )
}

export default function App() {
  return <Outlet />
}
