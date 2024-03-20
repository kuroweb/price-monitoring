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
  Bar,
} from 'recharts'

import { GetProductDetailPageDataQuery } from '@/graphql/dist/client'

const AnalysisChart = ({
  yahooAuctionData,
}: {
  yahooAuctionData: GetProductDetailPageDataQuery['product']['yahooAuctionDailyPurchaseSummaries']
}) => {
  return (
    <>
      <ResponsiveContainer width='100%' height={300}>
        <ComposedChart
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
          <YAxis yAxisId={1} orientation='left' />
          <YAxis yAxisId={2} orientation='right' />
          <Tooltip />
          <Legend />
          <Line
            yAxisId={1}
            type='monotone'
            dataKey='averagePurchasePrice'
            name='ヤフオク(価格)'
            stroke='orange'
            activeDot={{ r: 8 }}
            animationDuration={100}
          />
          <Bar
            yAxisId={2}
            type='monotone'
            dataKey='purchaseCount'
            name='ヤフオク(購入数)'
            fill='orange'
            animationDuration={100}
          />
        </ComposedChart>
      </ResponsiveContainer>
    </>
  )
}

export default AnalysisChart
