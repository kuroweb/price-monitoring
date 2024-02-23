'use client'

import { YahooAuctionCrawlSettingExcludeCondition } from '@/graphql/dist/client'

const EditForm = ({
  condition,
}: {
  condition: YahooAuctionCrawlSettingExcludeCondition | undefined
}) => {
  return (
    <>
      <div>編集フォーム</div>
      {condition?.id}
    </>
  )
}

export default EditForm
