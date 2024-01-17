'use client'

import { useForm, SubmitHandler } from 'react-hook-form'

interface FormData {
  name: string
  keyword: string
  min_price: number
  max_price: number
  enabled: boolean
}

const CreateForm = () => {
  const { register, handleSubmit } = useForm<FormData>()

  const onSubmit: SubmitHandler<FormData> = (data) => {
    console.log(data)
  }

  return (
    <form onSubmit={handleSubmit(onSubmit)} className='mx-auto p-4 bg-white shadow-md rounded-lg'>
      <label className='block text-sm font-medium text-gray-700'>
        name
        <input {...register('name')} className='p-2 border rounded-md w-full' />
      </label>
      <label className='block pt-4 text-sm font-medium text-gray-700'>
        keyword
        <input {...register('keyword')} className='p-2 border rounded-md w-full' />
      </label>
      <label className='block pt-4 text-sm font-medium text-gray-700'>
        min_price
        <input {...register('min_price')} className='p-2 border rounded-md w-full' />
      </label>
      <label className='block pt-4 text-sm font-medium text-gray-700'>
        max_price
        <input {...register('max_price')} className='p-2 border rounded-md w-full' />
      </label>
      {/* <label className="block pt-4 text-sm font-medium text-gray-700">
        enabled
        <input {...register('enabled')} className="p-2 border rounded-md w-full" />
      </label> */}
      <label className='relative inline-flex mt-4 items-center cursor-pointer'>
        <input {...register('enabled')} type='checkbox' value='' className='sr-only peer' checked />
        <div className="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 dark:peer-focus:ring-blue-800 rounded-full peer dark:bg-gray-700 peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-blue-600"></div>
        <span className='ms-3 text-sm font-medium text-gray-900 dark:text-gray-700'>enabled</span>
      </label>
      <button
        type='submit'
        className='block mt-4 py-2 px-4 bg-blue-500 text-white rounded-md hover:bg-blue-700'
      >
        登録
      </button>
    </form>
  )
}

export default CreateForm
