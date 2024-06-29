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
      {
        protocol: 'https',
        hostname: '*.cloudfront.net',
      },
      {
        protocol: 'https',
        hostname: 'iosys.co.jp',
      },
      {
        protocol: 'https',
        hostname: 'www.pc-koubou.jp',
      },
      {
        protocol: 'https',
        hostname: 'image.sofmap.com',
      },
    ],
  },
  experimental: {
    // TODO: 許可するオリジンを制限する
    //       allowedOrigins: ['my-proxy.com', '*.my-proxy.com'],
  },
  transpilePackages: ['react-daisyui'],
}

module.exports = nextConfig
