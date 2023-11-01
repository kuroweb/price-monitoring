"use client"

import Layout from '@/components/layouts/Layout'

import { useQuery } from "@apollo/client";
import { GetTodoDocument } from '@/graphql/dist/client'
import { GetTodoQuery } from "../graphql/dist/client"

const Page = () => {
  const { data, loading, error } = useQuery<GetTodoQuery>(GetTodoDocument)

  if (loading) return <div>LOADING...</div>;
  if (error) return <div>{error.message}</div>;

  return (
    <Layout>
      <p>Dashboard</p>
      {data?.todos.map(todo => (
        <p key={todo.id}>{todo.id}: {todo.text}</p>
      ))}
    </Layout>
  )
}

export default Page
