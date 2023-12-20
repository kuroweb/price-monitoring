'use client'

import React from 'react'

import { ApolloProvider } from '@apollo/client'

import { client } from '@/lib/client'

export const ApolloWrapper = ({ children }: React.PropsWithChildren) => {
  return <ApolloProvider client={client}>{children}</ApolloProvider>
}
