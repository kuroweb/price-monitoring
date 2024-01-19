/** @type {import('next').NextConfig} */
const nextConfig = {
  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: '*.yimg.jp',
      },
    ],
  },
  experimental: {
    // TODO: 許可するオリジンを制限する
    //       allowedOrigins: ['my-proxy.com', '*.my-proxy.com'],
    serverActions: true,
  },
}

module.exports = nextConfig
