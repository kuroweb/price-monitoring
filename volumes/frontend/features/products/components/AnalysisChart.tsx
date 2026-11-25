'use client'

import {
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer,
  ComposedChart,
} from 'recharts'

const AnalysisChart = () => {
  return (
    <>
      <ResponsiveContainer width='100%' height={300}>
        <ComposedChart
          data={[]}
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
        </ComposedChart>
      </ResponsiveContainer>
    </>
  )
}

export default AnalysisChart
