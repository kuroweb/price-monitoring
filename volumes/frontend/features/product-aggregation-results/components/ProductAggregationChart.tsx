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

import type { ProductAggregationResult } from '@/lib/api'
import { formatDate, formatYen } from '@/lib/format'

// 価格と件数は単位が違うため、縦軸を2本にせず別のグラフに分け、日付の位置とホバーを揃える。
// 購入がない日は曲線でつなぐ（monotone は実データを超える山を作らない）。吹き出しは価格のグラフにだけ出し、件数のグラフは位置の線だけを揃える
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
  payload?: { payload: ProductAggregationResult }[]
}

const ChartTooltip = ({ active, payload }: TooltipProps) => {
  const item = payload?.[0]?.payload
  if (!active || !item) return null

  return (
    <div className='rounded-box border border-base-300 bg-base-100 px-3 py-2 text-xs shadow-lg'>
      <p className='font-semibold'>{formatDate(item.date)}</p>
      <p>
        平均購入価格{' '}
        {item.averagePurchasePrice == null ? '-' : formatYen(item.averagePurchasePrice)}
      </p>
      <p>購入件数 {item.purchaseCount}件</p>
    </div>
  )
}

export default function ProductAggregationChart({
  syncId,
  results,
}: {
  syncId: string
  results: ProductAggregationResult[]
}) {
  return (
    <div className='space-y-2'>
      <p className='text-sm font-semibold'>平均購入価格</p>
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
            dataKey='averagePurchasePrice'
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
      <p className='text-sm font-semibold'>購入件数</p>
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
            dataKey='purchaseCount'
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
