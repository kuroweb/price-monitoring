import { LoaderFunction } from '@remix-run/node'
import { useTypedLoaderData } from 'remix-typedjson'

import RelatedProductCard from '@/features/products/components/RelatedProductCard'
import {
  GetProductDetailPageDataQuery,
  GetProductDetailPageDataDocument,
} from '@/graphql/dist/client'
import client from '@/lib/apollo-client'

export const loader: LoaderFunction = async ({ params }) => {
  const { data } = await client.query<GetProductDetailPageDataQuery>({
    query: GetProductDetailPageDataDocument,
    variables: {
      id: params.productId,
      platformMask: 'yahoo_auction.all,mercari_all',
      page: 1,
      per: 10,
      sort: 'price',
      order: 'asc',
    },
  })

  return data
}

export default function Page() {
  const data = useTypedLoaderData<GetProductDetailPageDataQuery>()
  console.log(data)

  return (
    <div>
      <div className='grid grid-cols-1 gap-4'>
        <div className='card w-full bg-neutral'>
          <div className='card-body'>
            <h2 className='card-title pb-4'>設定</h2>
            <div className='grid grid-cols-2 md:grid-cols-4 gap-4'>
              <button className='btn'>計測設定</button>
              <button className='btn'>必須キーワード</button>
              <button className='btn'>除外キーワード</button>
              <button className='btn'>除外商品ID</button>
              {/* TODO: ボタン追加 */}
            </div>
          </div>
        </div>
        <div className='card w-full bg-neutral'>
          <div className='card-body'>
            <h2 className='card-title pb-4'>一括設定</h2>
            <div className='grid grid-cols-2 md:grid-cols-4 gap-4'>
              <button className='btn'>必須キーワード</button>
              <button className='btn'>除外キーワード</button>
            </div>
          </div>
        </div>
        <div className='card w-full bg-neutral'>
          <div className='card-body'>
            <h2 className='card-title pb-4'>相場グラフ</h2>
            {/* TODO: チャート追加 */}
          </div>
        </div>
        <div className='card w-full bg-neutral'>
          <div className='card-body'>
            <h2 className='card-title pb-4'>商品一覧</h2>
            {/* TODO: 絞り込みフォーム追加 */}
            <div className='pt-4 grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4'>
              {data.product.relatedProducts.map((relatedProduct) => (
                <RelatedProductCard
                  key={relatedProduct.externalId}
                  relatedProduct={relatedProduct}
                />
              ))}
            </div>
            {/* TODO: ページネーション追加 */}
          </div>
        </div>
      </div>
      {/* TODO: 各モーダルのコンポーネントを追加 */}
    </div>
  )
}
