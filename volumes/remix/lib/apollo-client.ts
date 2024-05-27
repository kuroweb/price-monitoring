import { ApolloClient, InMemoryCache } from '@apollo/client'

const client = new ApolloClient({
  uri: process.env.BFF_URL,
  cache: new InMemoryCache(),
  defaultOptions: {
    watchQuery: {
      // 暫定対応でキャッシュ無効化
      fetchPolicy: 'no-cache'
    }
  }
})

export default client
