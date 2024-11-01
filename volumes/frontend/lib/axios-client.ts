import axios, { isAxiosError } from 'axios'
import camelcaseKeys from 'camelcase-keys'
import snakecaseKeys from 'snakecase-keys'

import type { AxiosRequestConfig, AxiosError, AxiosResponse } from 'axios'

const API_URL =
  typeof window === 'undefined'
    ? process.env.NEXT_PRIVATE_API_URL!
    : process.env.NEXT_PUBLIC_API_URL!

const DEFAULT_ERROR_DATA: ErrorData = { code: 500, message: 'Request failed.', details: [] }

export interface ApiResponse<T> {
  data: T | null
  error: ErrorData | null
  status: number
}

export interface ErrorData {
  code: number
  message: string
  details: object[] // 暫定的な型
}

export const http = async <T>(
  path: string,
  config: AxiosRequestConfig = {},
): Promise<ApiResponse<T>> => {
  try {
    const response = await axios({
      baseURL: API_URL,
      url: path,
      ...buildConfig(config),
    })

    return processResponse<T>(response)
  } catch (error) {
    return isAxiosError(error) ? handleAxiosError<T>(error) : handleUnexpectedError<T>()
  }
}

const buildConfig = (config: AxiosRequestConfig) => {
  return {
    ...config,
    headers: {
      'Content-Type': 'application/json',
      ...config.headers,
    },
    params: config.params ? snakecaseKeys(config.params) : config.params,
    data: config.data ? snakecaseKeys(config.data) : config.data,
  }
}

const processResponse = <T>(response: AxiosResponse): ApiResponse<T> => {
  const { status, data } = response

  if (status === 204) return { data: null, error: null, status }
  if (status >= 200 && status < 300) {
    return { data: camelcaseKeys(data, { deep: true }) as T, error: null, status }
  }

  return handleServerError<T>()
}

const handleAxiosError = <T>(error: unknown): ApiResponse<T> => {
  const axiosError = error as AxiosError<ErrorData>
  notifyError(axiosError?.response?.data.message || 'Axios request failed.')

  return {
    data: null,
    error: axiosError.response?.data || DEFAULT_ERROR_DATA,
    status: axiosError.response?.status || 500,
  }
}

const handleServerError = <T>(): ApiResponse<T> => {
  const message = 'Internal Server Error.'
  notifyError(message)

  return {
    data: null,
    error: { ...DEFAULT_ERROR_DATA, message },
    status: 500,
  }
}

const handleUnexpectedError = <T>(): ApiResponse<T> => {
  const message = 'Unexpected error occurred.'
  notifyError(message)

  return {
    data: null,
    error: { ...DEFAULT_ERROR_DATA, message },
    status: 500,
  }
}

// TODO: BugSnag通知にする
const notifyError = (message: string) => console.error(`Error: ${message}`)
