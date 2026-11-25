'use client'

import {
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer,
  ComposedChart,
} from 'recharts'

import type { YahooAuctionDailyPurchaseSummary } from '@/features/products/api/types'

const AnalysisChart = ({
  yahooAuctionData,
}: {
  yahooAuctionData: YahooAuctionDailyPurchaseSummary[]
}) => {
  const mergedData = yahooAuctionData.map((data) => ({
    date: data.date,
    yahooAuctionAveragePurchasePrice: data.averagePurchasePrice!,
  }))

  return (
    <>
      <ResponsiveContainer width='100%' height={300}>
        <ComposedChart
          data={mergedData}
          margin={{
            top: 5,
            right: 30,
            left: 20,
            bottom: 5,
          }}
        >
          <CartesianGrid strokeDasharray='3 3' />
          <XAxis dataKey='date' />
          <YAxis yAxisId={1} orientation='left' />
          <Tooltip />
          <Legend />
          <Line
            yAxisId={1}
            type='monotone'
            dataKey='yahooAuctionAveragePurchasePrice'
            name='ヤフオク'
            stroke='orange'
            fill='orange'
            activeDot={{ r: 8 }}
            animationDuration={100}
          />
        </ComposedChart>
      </ResponsiveContainer>
    </>
  )
}

export default AnalysisChart
