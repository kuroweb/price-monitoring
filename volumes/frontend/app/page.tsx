"use client"

import Layout from '@/components/layouts/Layout'

import { useSuspenseQuery } from "@apollo/experimental-nextjs-app-support/ssr";
import { GetTodoDocument } from '@/graphql/dist/client'
import { GetTodoQuery } from "../graphql/dist/client";

const Page = () => {
  const { error, data } = useSuspenseQuery<GetTodoQuery>(GetTodoDocument)

  if (error) return <p>{error.message}</p>;

  return (
    <Layout>
      <p>Dashboard</p>
      {data.todos.map(todo => (
        <p key={todo.id}>{todo.id}: {todo.text}</p>
      ))}
    </Layout>
  )
}

export default Page
