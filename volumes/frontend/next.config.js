/** @type {import('next').NextConfig} */
const nextConfig = {
  async redirects() {
    return [
      { source: '/backmarket_recents', destination: '/backmarket', permanent: true },
      { source: '/admin/backmarket_watch', destination: '/admin/backmarket', permanent: true },
      { source: '/admin/products/:id', destination: '/products/:id', permanent: true },
    ]
  },
  allowedDevOrigins: ['dev.price-monitoring.com'],
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
}

module.exports = nextConfig
