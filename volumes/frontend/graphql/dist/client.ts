import { GraphQLClient } from 'graphql-request';
import { GraphQLClientRequestHeaders } from 'graphql-request/build/cjs/types';
import gql from 'graphql-tag';
export type Maybe<T> = T | null;
export type InputMaybe<T> = Maybe<T>;
export type Exact<T extends { [key: string]: unknown }> = { [K in keyof T]: T[K] };
export type MakeOptional<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]?: Maybe<T[SubKey]> };
export type MakeMaybe<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]: Maybe<T[SubKey]> };
export type MakeEmpty<T extends { [key: string]: unknown }, K extends keyof T> = { [_ in K]?: never };
export type Incremental<T> = T | { [P in keyof T]?: P extends ' $fragmentName' | '__typename' ? T[P] : never };
/** All built-in and custom scalars, mapped to their actual values */
export type Scalars = {
  ID: { input: string; output: string; }
  String: { input: string; output: string; }
  Boolean: { input: boolean; output: boolean; }
  Int: { input: number; output: number; }
  Float: { input: number; output: number; }
};

export type Node = {
  id: Scalars['ID']['output'];
};

export type Product = Node & {
  __typename?: 'Product';
  id: Scalars['ID']['output'];
  name: Scalars['String']['output'];
  yahooAuctionProducts: Array<YahooAuctionProduct>;
};


export type ProductYahooAuctionProductsArgs = {
  id?: InputMaybe<Scalars['ID']['input']>;
  name?: InputMaybe<Scalars['String']['input']>;
  price?: InputMaybe<Scalars['Int']['input']>;
  published?: InputMaybe<Scalars['Boolean']['input']>;
  yahooAuctionID?: InputMaybe<Scalars['String']['input']>;
};

export type Query = {
  __typename?: 'Query';
  node?: Maybe<Node>;
  product: Product;
  products: Array<Product>;
  yahooAuctionProduct: YahooAuctionProduct;
};


export type QueryNodeArgs = {
  id: Scalars['ID']['input'];
};


export type QueryProductArgs = {
  id: Scalars['ID']['input'];
};


export type QueryProductsArgs = {
  id?: InputMaybe<Scalars['ID']['input']>;
  name?: InputMaybe<Scalars['String']['input']>;
};


export type QueryYahooAuctionProductArgs = {
  id: Scalars['ID']['input'];
};

export type YahooAuctionProduct = Node & {
  __typename?: 'YahooAuctionProduct';
  id: Scalars['ID']['output'];
  name: Scalars['String']['output'];
  price: Scalars['Int']['output'];
  productId: Scalars['Int']['output'];
  published: Scalars['Boolean']['output'];
  thumbnailUrl: Scalars['String']['output'];
  yahooAuctionId: Scalars['String']['output'];
};

export type ProductsQueryVariables = Exact<{
  id?: InputMaybe<Scalars['ID']['input']>;
  name?: InputMaybe<Scalars['String']['input']>;
  published?: InputMaybe<Scalars['Boolean']['input']>;
}>;


export type ProductsQuery = { __typename?: 'Query', products: Array<{ __typename?: 'Product', id: string, name: string, yahooAuctionProducts: Array<{ __typename?: 'YahooAuctionProduct', id: string, productId: number, yahooAuctionId: string, name: string, price: number, published: boolean }> }> };

export type ProductQueryVariables = Exact<{
  id: Scalars['ID']['input'];
  published?: InputMaybe<Scalars['Boolean']['input']>;
}>;


export type ProductQuery = { __typename?: 'Query', product: { __typename?: 'Product', id: string, name: string, yahooAuctionProducts: Array<{ __typename?: 'YahooAuctionProduct', id: string, productId: number, yahooAuctionId: string, name: string, thumbnailUrl: string, price: number, published: boolean }> } };


export const ProductsDocument = gql`
    query products($id: ID, $name: String, $published: Boolean) {
  products(id: $id, name: $name) {
    id
    name
    yahooAuctionProducts(published: $published) {
      id
      productId
      yahooAuctionId
      name
      price
      published
    }
  }
}
    `;
export const ProductDocument = gql`
    query product($id: ID!, $published: Boolean) {
  product(id: $id) {
    id
    name
    yahooAuctionProducts(published: $published) {
      id
      productId
      yahooAuctionId
      name
      thumbnailUrl
      price
      published
    }
  }
}
    `;

export type SdkFunctionWrapper = <T>(action: (requestHeaders?:Record<string, string>) => Promise<T>, operationName: string, operationType?: string, variables?: any) => Promise<T>;


const defaultWrapper: SdkFunctionWrapper = (action, _operationName, _operationType, variables) => action();

export function getSdk(client: GraphQLClient, withWrapper: SdkFunctionWrapper = defaultWrapper) {
  return {
    products(variables?: ProductsQueryVariables, requestHeaders?: GraphQLClientRequestHeaders): Promise<ProductsQuery> {
      return withWrapper((wrappedRequestHeaders) => client.request<ProductsQuery>(ProductsDocument, variables, {...requestHeaders, ...wrappedRequestHeaders}), 'products', 'query', variables);
    },
    product(variables: ProductQueryVariables, requestHeaders?: GraphQLClientRequestHeaders): Promise<ProductQuery> {
      return withWrapper((wrappedRequestHeaders) => client.request<ProductQuery>(ProductDocument, variables, {...requestHeaders, ...wrappedRequestHeaders}), 'product', 'query', variables);
    }
  };
}
export type Sdk = ReturnType<typeof getSdk>;