/** @type {import('next').NextConfig} */
const nextConfig = {
  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: 'auc-pctr.c.yimg.jp',
      },
    ],
  },
}

module.exports = nextConfig
