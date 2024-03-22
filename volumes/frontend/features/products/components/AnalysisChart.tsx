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
          <Tooltip />
          <Legend />
          <Line
            yAxisId={1}
            type='monotone'
            dataKey='averagePurchasePrice'
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
