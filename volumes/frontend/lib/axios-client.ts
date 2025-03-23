import axios, { isAxiosError } from 'axios'
import camelcaseKeys from 'camelcase-keys'
import snakecaseKeys from 'snakecase-keys'

import type { AxiosRequestConfig, AxiosError, AxiosResponse } from 'axios'

function getApiBaseUrl(): string {
  return typeof window === 'undefined'
    ? process.env.NEXT_PRIVATE_API_URL!
    : process.env.NEXT_PUBLIC_API_URL!
}

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

export async function http<T>(
  path: string,
  config: AxiosRequestConfig = {},
): Promise<ApiResponse<T>> {
  try {
    const response = await axios({
      baseURL: getApiBaseUrl(),
      url: path,
      ...buildConfig(config),
    })

    return processResponse<T>(response)
  } catch (error) {
    return isAxiosError(error) ? handleAxiosError<T>(error) : handleUnexpectedError<T>()
  }
}

function buildConfig(config: AxiosRequestConfig) {
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

function processResponse<T>(response: AxiosResponse): ApiResponse<T> {
  const { status, data } = response

  if (status === 204) return { data: null, error: null, status }
  if (status >= 200 && status < 300) {
    return { data: camelcaseKeys(data, { deep: true }) as T, error: null, status }
  }

  return handleUnexpectedError<T>()
}

function handleAxiosError<T>(error: unknown): ApiResponse<T> {
  const axiosError = error as AxiosError<ErrorData>

  return {
    data: null,
    error: {
      code: axiosError.response?.data.code || 500,
      message: axiosError.response?.data.message || 'Request failed.',
      details: axiosError.response?.data.details || [],
    },
    status: axiosError.response?.status || 500,
  }
}

function handleUnexpectedError<T>(): ApiResponse<T> {
  const message = 'Unexpected error occurred.'
  notifyError(message)
  throw new Error(message)
}

// TODO: BugSnag通知にする
function notifyError(message: string) {
  console.error(`Error: ${message}`)
}
