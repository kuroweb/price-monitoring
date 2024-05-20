'use client'

import NextImage from 'next/image'
import { useRouter } from 'next/navigation'
import { toast } from 'react-toastify'

import { useStatusState } from '../hooks/useStatusState'
import {
  createYahooAuctionCrawlSettingExcludeProduct,
  createMercariCrawlSettingExcludeProduct,
  createJanparaCrawlSettingExcludeProduct,
  createIosysCrawlSettingExcludeProduct,
  createPcKoubouCrawlSettingExcludeProduct,
} from '../server-actions/productQuery'

import { GetProductDetailPageDataQuery } from '@/graphql/dist/client'

const RelatedProductCard = ({
  relatedProduct,
}: {
  relatedProduct: GetProductDetailPageDataQuery['product']['relatedProducts'][0]
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

  const serviceColorMap: { [key: string]: string } = {
    mercari: 'bg-red-500',
    yahoo_auction: 'bg-yellow-600',
    yahoo_fleamarket: 'bg-green-600',
    janpara: 'bg-blue-500',
    iosys: 'bg-blue-600',
    pc_koubou: 'bg-blue-400',
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
    const allowedStatus = '409'

    switch (platform) {
      case 'yahoo_auction':
      case 'yahoo_fleamarket':
        const yahooAuctionResult = await createYahooAuctionCrawlSettingExcludeProduct(input)
        if (
          yahooAuctionResult?.data?.createYahooAuctionCrawlSettingExcludeProduct.__typename ===
            'CreateYahooAuctionCrawlSettingExcludeProductResultError' &&
          yahooAuctionResult?.data?.createYahooAuctionCrawlSettingExcludeProduct.error.code !==
            allowedStatus
        ) {
          return toast.error('error')
        }
        break
      case 'mercari':
        const mercariResult = await createMercariCrawlSettingExcludeProduct(input)
        if (
          mercariResult?.data?.createMercariCrawlSettingExcludeProduct.__typename ===
            'CreateMercariCrawlSettingExcludeProductResultError' &&
          mercariResult?.data?.createMercariCrawlSettingExcludeProduct.error.code !== allowedStatus
        ) {
          return toast.error('error')
        }
        break
      case 'janpara':
        const janparaResult = await createJanparaCrawlSettingExcludeProduct(input)
        if (
          janparaResult?.data?.createJanparaCrawlSettingExcludeProduct.__typename ===
            'CreateJanparaCrawlSettingExcludeProductResultError' &&
          janparaResult?.data?.createJanparaCrawlSettingExcludeProduct.error.code !== allowedStatus
        ) {
          return toast.error('error')
        }
        break
      case 'iosys':
        const iosys = await createIosysCrawlSettingExcludeProduct(input)
        if (
          iosys?.data?.createIosysCrawlSettingExcludeProduct.__typename ===
            'CreateIosysCrawlSettingExcludeProductResultError' &&
          iosys?.data?.createIosysCrawlSettingExcludeProduct.error.code !== allowedStatus
        ) {
          return toast.error('error')
        }
        break
      case 'pc_koubou':
        const pcKoubouResult = await createPcKoubouCrawlSettingExcludeProduct(input)
        if (
          pcKoubouResult?.data?.createPcKoubouCrawlSettingExcludeProduct.__typename ===
            'CreatePcKoubouCrawlSettingExcludeProductResultError' &&
          pcKoubouResult?.data?.createPcKoubouCrawlSettingExcludeProduct.error.code !==
            allowedStatus
        ) {
          return toast.error('error')
        }
        break
    }

    toast.success('success')
    router.refresh()
  }

  return (
    <>
      <div className='card bg-base-100 shadow-xl'>
        <figure>
          <div className='h-32 w-full relative'>
            <NextImage
              src={relatedProduct.thumbnailUrl}
              alt=''
              fill
              sizes='100vh 100vw'
              style={{ objectFit: 'contain' }}
              className='cursor-pointer'
              onClick={() => openProductPage(relatedProduct.platform, relatedProduct.externalId)}
            />
          </div>
          <div
            className={`badge ${serviceColorMap[relatedProduct.platform]} text-black absolute top-2 start-2`}
          >
            {serviceNameMap[relatedProduct.platform]}
          </div>
          <div className='badge badge-neutral absolute top-24 end-2'>
            <span className='text-xs pr-1'>終了日:</span>
            <span>{`${
              status == 'published'
                ? relatedProduct.endDate
                  ? parseDate(relatedProduct.endDate)
                  : '-'
                : parseDate(relatedProduct.boughtDate)
            }`}</span>
          </div>
          <div className='dropdown dropdown-left absolute top-2 end-2'>
            <div tabIndex={0} role='button' className='btn btn-square btn-sm'>
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
        </figure>
        <div
          className='card-body p-4 cursor-pointer'
          onClick={() => openProductPage(relatedProduct.platform, relatedProduct.externalId)}
        >
          <p className='text-sm'>{relatedProduct.name}</p>
          <div className='flex-wrap space-y-2'>
            {status == 'published' && relatedProduct.platform == 'yahoo_auction' ? (
              <>
                <div className='flex justify-end'>
                  <div className='badge badge-outline'>
                    <span className='text-xs pr-1'>現在:</span>
                    <span className='pr-1'>{relatedProduct.price}</span>
                    <span className='text-xs'>円</span>
                  </div>
                </div>
                {relatedProduct.buyoutPrice && (
                  <div className='flex justify-end'>
                    <div className='badge badge-outline'>
                      <span className='text-xs pr-1'>即決:</span>
                      <span className='pr-1'>{relatedProduct.buyoutPrice}</span>
                      <span className='text-xs'>円</span>
                    </div>
                  </div>
                )}
              </>
            ) : (
              <div className='flex justify-end'>
                <div className='badge badge-outline'>
                  <span className='text-xs pr-1'>現在:</span>
                  <span className='pr-1'>{relatedProduct.price}</span>
                  <span className='text-xs'>円</span>
                </div>
              </div>
            )}
          </div>
        </div>
      </div>
    </>
  )
}

export default RelatedProductCard
