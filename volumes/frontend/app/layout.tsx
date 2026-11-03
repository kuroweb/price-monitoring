import { type Metadata } from 'next'
import { NuqsAdapter } from 'nuqs/adapters/next/app'

import './globals.css'
import ToastProvider from '@/lib/toast-provider'

const composeProjectName = process.env.NEXT_PUBLIC_COMPOSE_PROJECT_NAME

export const metadata: Metadata = {
  title: composeProjectName ? `[${composeProjectName}] Price Monitoring` : 'Price Monitoring',
  description: 'Price Monitoring',
}

// SSG disabled
export const dynamic = 'force-dynamic'

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang='ja'>
      <body>
        <NuqsAdapter>
          <ToastProvider>{children}</ToastProvider>
        </NuqsAdapter>
      </body>
    </html>
  )
}
