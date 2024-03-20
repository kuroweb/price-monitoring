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

const AnalysisChart = ({
  yahooAuctionData,
  // mercariData
}: {
  yahooAuctionData: GetProductDetailPageDataQuery['product']['yahooAuctionDailyPurchaseSummaries']
  // mercariData: GetProductDetailPageDataQuery['product']['calculateDailyMercariProducts']
}) => {
  return (
    <>
      <ResponsiveContainer width='100%' height={300}>
        <LineChart
          data={yahooAuctionData}
          margin={{
            top: 5,
            right: 30,
            left: 20,
            bottom: 5,
          }}
        >
          <CartesianGrid strokeDasharray='3 3' />
          <XAxis dataKey='date' />
          <YAxis />
          <Tooltip />
          <Legend />
          <Line
            type='monotone'
            dataKey='averagePurchasePrice'
            name='ヤフオク'
            stroke='orange'
            activeDot={{ r: 8 }}
            animationDuration={100}
          />
          {/* <Line
            type='monotone'
            dataKey='id'
            name='メルカリ'
            stroke='red'
            activeDot={{ r: 8 }}
            animationDuration={100}
          /> */}
        </LineChart>
      </ResponsiveContainer>
    </>
  )
}

export default AnalysisChart
