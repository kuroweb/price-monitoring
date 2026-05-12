import httpModule from 'http'
import https from 'https'
import { URL, URLSearchParams } from 'url'

import camelcaseKeys from 'camelcase-keys'
import snakecaseKeys from 'snakecase-keys'

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

export interface HttpRequestConfig {
  method?: string
  headers?: Record<string, string>
  params?: unknown
  data?: unknown
}

export async function http<T>(
  path: string,
  config: HttpRequestConfig = {},
): Promise<ApiResponse<T>> {
  try {
    const response = typeof window === 'undefined'
      ? await requestOnServer(path, config)
      : await requestOnClient(path, config)

    return processResponse<T>(response)
  } catch (error) {
    return isHttpError(error) ? handleHttpError<T>(error) : handleUnexpectedError<T>()
  }
}

interface HttpResponse {
  status: number
  data: unknown
}

function buildRequest(config: HttpRequestConfig) {
  return {
    method: config.method ?? 'GET',
    headers: {
      'Content-Type': 'application/json',
      ...config.headers,
    },
    params: normalizeRequestData(config.params),
    data: normalizeRequestData(config.data),
  }
}

function buildUrl(path: string, params?: unknown): string {
  const url = new URL(path, getApiBaseUrl())

  if (!params || typeof params !== 'object') return url.toString()

  const searchParams = new URLSearchParams()
  for (const [key, value] of Object.entries(params as Record<string, unknown>)) {
    if (value === undefined || value === null) continue
    searchParams.set(key, String(value))
  }

  url.search = searchParams.toString()
  return url.toString()
}

async function requestOnClient(path: string, config: HttpRequestConfig): Promise<HttpResponse> {
  const request = buildRequest(config)
  const response = await fetch(buildUrl(path, request.params), {
    method: request.method,
    headers: request.headers,
    body: request.data ? JSON.stringify(request.data) : undefined,
  })

  return {
    status: response.status,
    data: await parseResponseBody(response),
  }
}

async function requestOnServer(path: string, config: HttpRequestConfig): Promise<HttpResponse> {
  const request = buildRequest(config)
  const url = new URL(buildUrl(path, request.params))
  const transport = url.protocol === 'https:' ? https : httpModule

  return new Promise((resolve, reject) => {
    const req = transport.request(
      url,
      {
        method: request.method,
        headers: request.headers,
        rejectUnauthorized: false,
      },
      (res) => {
        let body = ''

        res.setEncoding('utf8')
        res.on('data', (chunk) => {
          body += chunk
        })
        res.on('end', () => {
          resolve({
            status: res.statusCode ?? 500,
            data: parseRawBody(body),
          })
        })
      },
    )

    req.on('error', (error) => reject(error))

    if (request.data) {
      req.write(JSON.stringify(request.data))
    }

    req.end()
  })
}

async function parseResponseBody(response: Response) {
  const text = await response.text()
  return parseRawBody(text)
}

function parseRawBody(body: string) {
  if (body.length === 0) return null

  try {
    return JSON.parse(body)
  } catch {
    return body
  }
}

function processResponse<T>(response: HttpResponse): ApiResponse<T> {
  const { status, data } = response

  if (status === 204) return { data: null, error: null, status }
  if (status >= 200 && status < 300) {
    return { data: normalizeResponseData(data) as T, error: null, status }
  }

  return handleErrorResponse<T>(status, data)
}

interface HttpError extends Error {
  status?: number
  responseData?: Partial<ErrorData>
}

function isHttpError(error: unknown): error is HttpError {
  return error instanceof Error
}

function handleHttpError<T>(error: HttpError): ApiResponse<T> {
  return {
    data: null,
    error: {
      code: error.responseData?.code || error.status || 500,
      message: error.responseData?.message || error.message || 'Request failed.',
      details: error.responseData?.details || [],
    },
    status: error.status || 500,
  }
}

function handleErrorResponse<T>(status: number, data: unknown): ApiResponse<T> {
  const errorData = isErrorData(data)
    ? (normalizeResponseData(data) as ErrorData)
    : null

  return {
    data: null,
    error: {
      code: errorData?.code || status,
      message: errorData?.message || 'Request failed.',
      details: errorData?.details || [],
    },
    status,
  }
}

function isErrorData(data: unknown): data is ErrorData {
  return typeof data === 'object' && data !== null
}

function normalizeResponseData(data: unknown) {
  if (isCamelCaseConvertible(data)) {
    return camelcaseKeys(data, { deep: true })
  }

  return data
}

function normalizeRequestData(data: unknown) {
  if (isCamelCaseConvertible(data)) {
    return snakecaseKeys(data, { deep: true })
  }

  return data
}

function isCamelCaseConvertible(
  data: unknown,
): data is Record<string, unknown> | readonly Record<string, unknown>[] {
  if (Array.isArray(data)) {
    return data.every((item) => typeof item === 'object' && item !== null && !Array.isArray(item))
  }

  return typeof data === 'object' && data !== null
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
