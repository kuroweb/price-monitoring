"use client"

import Layout from '@/components/layouts/Layout'
import { useState } from 'react'

const Page = () => {
  const [data, setData] = useState<any>()

  const fetchData = async () => {
    const response = await fetch('http://localhost:3000')
    console.log(response)
    setData(response.status)
  }

  fetchData()

  return (
    <Layout>
      <p>Dashboard</p>
      <p>{data}</p>
    </Layout>
  )
}

export default Page
