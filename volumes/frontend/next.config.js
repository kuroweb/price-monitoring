/** @type {import('next').NextConfig} */
const nextConfig = {
  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: '*.yimg.jp',
      },
      {
        protocol: 'https',
        hostname: 'static.mercdn.net',
      },
      {
        protocol: 'https',
        hostname: 'www.janpara.co.jp',
      },
    ],
  },
  experimental: {
    // TODO: 許可するオリジンを制限する
    //       allowedOrigins: ['my-proxy.com', '*.my-proxy.com'],
    serverActions: true,
  },
  transpilePackages: ['react-daisyui'],
}

module.exports = nextConfig
