'use client'

import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer,
} from 'recharts'

import { GetProductDetailPageDataQuery } from '@/graphql/dist/client'

const YahooAuctionProductChart = ({ data }: { data: GetProductDetailPageDataQuery }) => {
  const chartData = data.product.calculateDailyYahooAuctionProducts

  return (
    <>
      <ResponsiveContainer width='100%' height={300}>
        <LineChart
          data={chartData}
          margin={{
            top: 5,
            right: 30,
            left: 20,
            bottom: 5,
          }}
        >
          <CartesianGrid strokeDasharray='3 3' />
          <XAxis dataKey='targetDate' />
          <YAxis />
          <Tooltip />
          <Legend />
          <Line type='monotone' dataKey='price' stroke='#8884d8' activeDot={{ r: 8 }} />
        </LineChart>
      </ResponsiveContainer>
    </>
  )
}

export default YahooAuctionProductChart
