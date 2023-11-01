'use client'

import { ApolloProvider } from '@apollo/client'
import React from 'react'
import { client } from '@/lib/client'

export const ApolloWrapper = ({ children }: React.PropsWithChildren) => {
  return <ApolloProvider client={client}>{children}</ApolloProvider>
}
