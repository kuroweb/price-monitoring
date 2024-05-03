import { useForm } from 'react-hook-form'

import { UpdateProductInput } from '@/graphql/dist/client'

const IosysForm = ({
  register,
}: {
  register: ReturnType<typeof useForm<UpdateProductInput>>['register']
}) => {
  return (
    <>
      <label className='form-control'>
        <div className='label'>
          <span className='label-text'>計測キーワード</span>
        </div>
        <input {...register('iosys_crawl_setting.keyword')} className='input input-bordered' />
      </label>
      <label className='form-control'>
        <div className='label'>
          <span className='label-text'>最低価格</span>
        </div>
        <input {...register('iosys_crawl_setting.min_price')} className='input input-bordered' />
      </label>
      <label className='form-control'>
        <div className='label'>
          <span className='label-text'>最高価格</span>
        </div>
        <input {...register('iosys_crawl_setting.max_price')} className='input input-bordered' />
      </label>
      <label className='label cursor-pointer '>
        <span className='label-text'>自動計測</span>
        <input
          {...register('iosys_crawl_setting.enabled')}
          type='checkbox'
          className='toggle toggle-primary'
        />
      </label>
    </>
  )
}

export default IosysForm
