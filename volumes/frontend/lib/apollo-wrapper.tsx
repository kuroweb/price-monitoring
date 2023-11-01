"use client"

import { ApolloProvider } from "@apollo/client"
import { client } from "@/lib/client"
import React from "react"

export const ApolloWrapper = ({ children }: React.PropsWithChildren) => {
  return <ApolloProvider client={client}>{children}</ApolloProvider>
}
