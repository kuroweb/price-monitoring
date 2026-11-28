'use client'

import {
  Area,
  Bar,
  BarChart,
  CartesianGrid,
  ComposedChart,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis,
} from 'recharts'

import type { DailyMarketPrice } from '@/features/product-monitoring/api/types'
import { formatDate, formatYen } from '@/lib/format'

// 価格と件数は単位が違うので別のグラフに分け、取引がない日は実データを超える山を作らない monotone でつなぐ
const SERIES_COLOR = 'var(--color-primary)'
const GRID_COLOR = 'color-mix(in oklab, var(--color-base-content) 12%, transparent)'
const AXIS_TICK = {
  fill: 'color-mix(in oklab, var(--color-base-content) 60%, transparent)',
  fontSize: 12,
}

const compactYen = (value: number) =>
  value >= 10000 ? `${(value / 10000).toFixed(value % 10000 === 0 ? 0 : 1)}万` : `${value}`

type TooltipProps = {
  active?: boolean
  payload?: { payload: DailyMarketPrice }[]
}

const ChartTooltip = ({ active, payload }: TooltipProps) => {
  const item = payload?.[0]?.payload
  if (!active || !item) return null

  return (
    <div className='rounded-box border border-base-300 bg-base-100 px-3 py-2 text-xs shadow-lg'>
      <p className='font-semibold'>{formatDate(item.date)}</p>
      <p>
        平均取引価格{' '}
        {item.averageTransactionPrice == null ? '-' : formatYen(item.averageTransactionPrice)}
      </p>
      <p>取引件数 {item.transactionCount}件</p>
    </div>
  )
}

export default function DailyMarketPriceChart({
  syncId,
  results,
}: {
  syncId: string
  results: DailyMarketPrice[]
}) {
  return (
    <div className='space-y-2'>
      <p className='text-sm font-semibold'>平均取引価格</p>
      <ResponsiveContainer width='100%' height={220}>
        <ComposedChart
          data={results}
          syncId={syncId}
          margin={{ top: 8, right: 16, left: 0, bottom: 0 }}
        >
          <CartesianGrid stroke={GRID_COLOR} vertical={false} />
          <XAxis
            dataKey='date'
            tickFormatter={formatDate}
            scale='band'
            tick={AXIS_TICK}
            tickLine={false}
            axisLine={{ stroke: GRID_COLOR }}
            minTickGap={24}
          />
          <YAxis
            tickFormatter={compactYen}
            tick={AXIS_TICK}
            tickLine={false}
            axisLine={false}
            width={48}
            domain={['auto', 'auto']}
          />
          <Tooltip content={<ChartTooltip />} cursor={{ stroke: GRID_COLOR }} />
          <Area
            type='monotone'
            dataKey='averageTransactionPrice'
            stroke={SERIES_COLOR}
            strokeWidth={2}
            fill={SERIES_COLOR}
            fillOpacity={0.1}
            connectNulls
            dot={false}
            activeDot={{ r: 5, strokeWidth: 2, stroke: 'var(--color-base-100)' }}
            isAnimationActive={false}
          />
        </ComposedChart>
      </ResponsiveContainer>
      <p className='text-sm font-semibold'>取引件数</p>
      <ResponsiveContainer width='100%' height={120}>
        <BarChart data={results} syncId={syncId} margin={{ top: 8, right: 16, left: 0, bottom: 0 }}>
          <CartesianGrid stroke={GRID_COLOR} vertical={false} />
          <XAxis
            dataKey='date'
            tickFormatter={formatDate}
            scale='band'
            tick={AXIS_TICK}
            tickLine={false}
            axisLine={{ stroke: GRID_COLOR }}
            minTickGap={24}
          />
          <YAxis
            allowDecimals={false}
            tick={AXIS_TICK}
            tickLine={false}
            axisLine={false}
            width={48}
          />
          <Tooltip
            content={() => null}
            cursor={{ fill: 'color-mix(in oklab, var(--color-base-content) 6%, transparent)' }}
          />
          <Bar
            dataKey='transactionCount'
            fill={SERIES_COLOR}
            fillOpacity={0.7}
            maxBarSize={24}
            radius={[4, 4, 0, 0]}
            isAnimationActive={false}
          />
        </BarChart>
      </ResponsiveContainer>
    </div>
  )
}
