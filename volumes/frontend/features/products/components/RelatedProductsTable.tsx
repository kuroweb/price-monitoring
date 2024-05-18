'use client'

import NextImage from 'next/image'
import { useRouter } from 'next/navigation'
import { toast } from 'react-toastify'

import { useStatusState } from '../hooks/useStatusState'
import {
  createIosysCrawlSettingExcludeProduct,
  createJanparaCrawlSettingExcludeProduct,
  createMercariCrawlSettingExcludeProduct,
  createPcKoubouCrawlSettingExcludeProduct,
  createYahooAuctionCrawlSettingExcludeProduct,
} from '../server-actions/productQuery'

import { GetProductDetailPageDataQuery } from '@/graphql/dist/client'

const RelatedProductsTable = ({
  relatedProducts,
}: {
  relatedProducts: GetProductDetailPageDataQuery['product']['relatedProducts']
}) => {
  const router = useRouter()
  const [status, _] = useStatusState()

  const serviceDomainMap: { [key: string]: string } = {
    mercari: 'jp.mercari.com/item/',
    yahoo_auction: 'page.auctions.yahoo.co.jp/jp/auction/',
    yahoo_fleamarket: 'paypayfleamarket.yahoo.co.jp/item/',
    janpara: 'www.janpara.co.jp/sale/search/detail/?',
    iosys: 'iosys.co.jp/items/',
    pc_koubou: 'www.pc-koubou.jp/products/detail.php?product_id=',
  }

  const serviceNameMap: { [key: string]: string } = {
    mercari: 'メルカリ',
    yahoo_auction: 'ヤフオク',
    yahoo_fleamarket: 'ペイペイ',
    janpara: 'じゃんぱら',
    iosys: 'イオシス',
    pc_koubou: 'パソコン工房',
  }

  const openProductPage = async (platform: string, externalId: string) => {
    window.open(`https://${serviceDomainMap[platform]}${externalId}`, '_blank')
  }

  const parseDate = (date: string | null | undefined) => {
    // 暫定実装
    return date ? date.substring(0, 10) : ''
  }

  const createExcludeProduct = async (
    platform: string,
    input: { externalId: string; productId: string },
  ) => {
    switch (platform) {
      case 'yahoo_auction':
      case 'yahoo_fleamarket':
        let yahooAuctionResult = await createYahooAuctionCrawlSettingExcludeProduct(input)
        if (
          yahooAuctionResult?.data?.createYahooAuctionCrawlSettingExcludeProduct.__typename ===
            'CreateYahooAuctionCrawlSettingExcludeProductResultError' &&
          yahooAuctionResult?.data?.createYahooAuctionCrawlSettingExcludeProduct.error.code !==
            '409'
        ) {
          return toast.error('error')
        }

        toast.success('success')
        router.refresh()
        break
      case 'mercari':
        let mercariResult = await createMercariCrawlSettingExcludeProduct(input)
        if (
          mercariResult?.data?.createMercariCrawlSettingExcludeProduct.__typename ===
            'CreateMercariCrawlSettingExcludeProductResultError' &&
          mercariResult?.data?.createMercariCrawlSettingExcludeProduct.error.code !== '409'
        ) {
          return toast.error('error')
        }

        toast.success('success')
        router.refresh()
        break
      case 'janpara':
        let janparaResult = await createJanparaCrawlSettingExcludeProduct(input)
        if (
          janparaResult?.data?.createJanparaCrawlSettingExcludeProduct.__typename ===
            'CreateJanparaCrawlSettingExcludeProductResultError' &&
          janparaResult?.data?.createJanparaCrawlSettingExcludeProduct.error.code !== '409'
        ) {
          return toast.error('error')
        }

        toast.success('success')
        router.refresh()
        break
      case 'iosys':
        let iosys = await createIosysCrawlSettingExcludeProduct(input)
        if (
          iosys?.data?.createIosysCrawlSettingExcludeProduct.__typename ===
            'CreateIosysCrawlSettingExcludeProductResultError' &&
          iosys?.data?.createIosysCrawlSettingExcludeProduct.error.code !== '409'
        ) {
          return toast.error('error')
        }

        toast.success('success')
        router.refresh()
        break
      case 'pc_koubou':
        let pcKoubouResult = await createPcKoubouCrawlSettingExcludeProduct(input)
        if (
          pcKoubouResult?.data?.createPcKoubouCrawlSettingExcludeProduct.__typename ===
            'CreatePcKoubouCrawlSettingExcludeProductResultError' &&
          pcKoubouResult?.data?.createPcKoubouCrawlSettingExcludeProduct.error.code !== '409'
        ) {
          return toast.error('error')
        }

        toast.success('success')
        router.refresh()
        break
    }
  }

  return (
    <>
      <table className='table'>
        <thead>
          <tr>
            <th />
            <th />
            <th />
            <th />
            <th />
          </tr>
        </thead>
        <tbody>
          {relatedProducts.map((relatedProduct) => (
            <tr key={relatedProduct.externalId} className='border-b border-base-200 cursor-pointer'>
              <td
                className='w-2/12'
                onClick={() => openProductPage(relatedProduct.platform, relatedProduct.externalId)}
              >
                {serviceNameMap[relatedProduct.platform]}
              </td>
              <td
                className='w-5/12'
                onClick={() => openProductPage(relatedProduct.platform, relatedProduct.externalId)}
              >
                {relatedProduct.name}
              </td>
              <td
                className='w-2/12'
                onClick={() => openProductPage(relatedProduct.platform, relatedProduct.externalId)}
              >
                <div className='space-y-2'>
                  <div>
                    <p className='text-xs text-gray-500'>現在</p>
                    <p>{relatedProduct.price}</p>
                  </div>
                  <div>
                    <p className='text-xs text-gray-500'>即決</p>
                    <p>{relatedProduct.buyoutPrice ? relatedProduct.buyoutPrice : '-'}</p>
                  </div>
                  <div>
                    <p className='text-xs text-gray-500'>終了日</p>
                    {status == 'published'
                      ? relatedProduct.endDate
                        ? parseDate(relatedProduct.endDate)
                        : '-'
                      : parseDate(relatedProduct.boughtDate)}
                  </div>
                </div>
              </td>
              <td
                className='w-2/12'
                onClick={() => openProductPage(relatedProduct.platform, relatedProduct.externalId)}
              >
                <div className='relative aspect-square'>
                  <NextImage
                    className='object-cover rounded-lg'
                    src={relatedProduct.thumbnailUrl}
                    alt=''
                    fill
                    sizes='100vw, 100vw'
                  />
                </div>
              </td>
              <td className='w-1/12'>
                <div className='dropdown dropdown-left'>
                  <div tabIndex={0} role='button' className='btn btn-square btn-md'>
                    <svg
                      xmlns='http://www.w3.org/2000/svg'
                      fill='none'
                      viewBox='0 0 24 24'
                      className='inline-block w-5 h-5 stroke-current'
                    >
                      <path
                        strokeLinecap='round'
                        strokeLinejoin='round'
                        strokeWidth='2'
                        d='M5 12h.01M12 12h.01M19 12h.01M6 12a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0z'
                      ></path>
                    </svg>
                  </div>
                  <ul
                    tabIndex={0}
                    className='dropdown-content z-[1] menu space-y-2 shadow bg-base-200 rounded-box w-20'
                  >
                    <li>
                      <button
                        className='btn btn-error'
                        onClick={async () =>
                          createExcludeProduct(relatedProduct.platform, {
                            externalId: relatedProduct.externalId,
                            productId: String(relatedProduct.productId),
                          })
                        }
                      >
                        除外
                      </button>
                    </li>
                  </ul>
                </div>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </>
  )
}

export default RelatedProductsTable
