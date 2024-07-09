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

import type { GetProductDetailPageDataQuery } from '@/graphql/dist/client'

const AnalysisChart = ({
  yahooAuctionData,
  yahooFleamarketData,
  mercariData,
}: {
  yahooAuctionData: GetProductDetailPageDataQuery['product']['yahooAuctionDailyPurchaseSummaries']
  yahooFleamarketData: GetProductDetailPageDataQuery['product']['yahooFleamarketDailyPurchaseSummaries']
  mercariData: GetProductDetailPageDataQuery['product']['mercariDailyPurchaseSummaries']
}) => {
  const yahooAuctionDataMap = yahooAuctionData.reduce<{
    [date: string]: { yahooAuctionAveragePurchasePrice: number }
  }>((acc, data) => {
    acc[data.date] = { yahooAuctionAveragePurchasePrice: data.averagePurchasePrice! }
    return acc
  }, {})

  const yahooFleamarketDataMap = yahooFleamarketData.reduce<{
    [date: string]: { yahooFleamarketAveragePurchasePrice: number }
  }>((acc, data) => {
    acc[data.date] = { yahooFleamarketAveragePurchasePrice: data.averagePurchasePrice! }
    return acc
  }, {})

  const mercariDataMap = mercariData.reduce<{
    [date: string]: { mercariAveragePurchasePrice: number }
  }>((acc, data) => {
    acc[data.date] = { mercariAveragePurchasePrice: data.averagePurchasePrice! }
    return acc
  }, {})

  const mergedData = Object.keys({ ...yahooAuctionDataMap, ...mercariDataMap }).map((date) => ({
    date,
    ...yahooAuctionDataMap[date],
    ...yahooFleamarketDataMap[date],
    ...mercariDataMap[date],
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
          <Line
            yAxisId={1}
            type='monotone'
            dataKey='yahooFleamarketAveragePurchasePrice'
            name='ペイペイ'
            stroke='yellowgreen'
            fill='yellowgreen'
            activeDot={{ r: 8 }}
            animationDuration={100}
          />
          <Line
            yAxisId={1}
            type='monotone'
            dataKey='mercariAveragePurchasePrice'
            name='メルカリ'
            stroke='red'
            fill='red'
            activeDot={{ r: 8 }}
            animationDuration={100}
          />
        </ComposedChart>
      </ResponsiveContainer>
    </>
  )
}

export default AnalysisChart
