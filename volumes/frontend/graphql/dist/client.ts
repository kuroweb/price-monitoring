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

export type CreateProductInput = {
  name: Scalars['String']['input'];
  yahoo_auction_crawl_setting: CreateYahooAuctionCrawlSettingInput;
};

export type CreateProductResult = CreateProductResultError | CreateProductResultSuccess;

export type CreateProductResultError = ResultBase & {
  __typename?: 'CreateProductResultError';
  error: CreateProductResultErrors;
  ok: Scalars['Boolean']['output'];
};

export type CreateProductResultErrors = CreateProductResultValidationFailed;

export type CreateProductResultSuccess = ResultBase & {
  __typename?: 'CreateProductResultSuccess';
  ok: Scalars['Boolean']['output'];
  product: Product;
};

export type CreateProductResultValidationFailed = UserError & {
  __typename?: 'CreateProductResultValidationFailed';
  code: Scalars['String']['output'];
  details: Array<ErrorDetail>;
  message: Scalars['String']['output'];
};

export type CreateYahooAuctionCrawlSettingInput = {
  category_id?: InputMaybe<Scalars['Int']['input']>;
  enabled: Scalars['Boolean']['input'];
  keyword: Scalars['String']['input'];
  max_price: Scalars['Int']['input'];
  min_price: Scalars['Int']['input'];
};

export type DeleteProductResult = DeleteProductResultError | DeleteProductResultSuccess;

export type DeleteProductResultError = ResultBase & {
  __typename?: 'DeleteProductResultError';
  error: DeleteProductResultErrors;
  ok: Scalars['Boolean']['output'];
};

export type DeleteProductResultErrors = DeleteProductResultValidationFailed;

export type DeleteProductResultSuccess = ResultBase & {
  __typename?: 'DeleteProductResultSuccess';
  ok: Scalars['Boolean']['output'];
};

export type DeleteProductResultValidationFailed = UserError & {
  __typename?: 'DeleteProductResultValidationFailed';
  code: Scalars['String']['output'];
  details: Array<ErrorDetail>;
  message: Scalars['String']['output'];
};

export type ErrorDetail = {
  __typename?: 'ErrorDetail';
  field: Scalars['String']['output'];
  message: Scalars['String']['output'];
};

export type Mutation = {
  __typename?: 'Mutation';
  createProduct: CreateProductResult;
  deleteProduct: DeleteProductResult;
};


export type MutationCreateProductArgs = {
  input: CreateProductInput;
};


export type MutationDeleteProductArgs = {
  id: Scalars['ID']['input'];
};

export type Node = {
  id: Scalars['ID']['output'];
};

export type Product = Node & {
  __typename?: 'Product';
  id: Scalars['ID']['output'];
  name: Scalars['String']['output'];
  yahooAuctionCrawlSetting: YahooAuctionCrawlSetting;
  yahooAuctionProducts: Array<YahooAuctionProduct>;
};


export type ProductYahooAuctionProductsArgs = {
  published?: InputMaybe<Scalars['Boolean']['input']>;
};

export type Query = {
  __typename?: 'Query';
  node?: Maybe<Node>;
  product: Product;
  products: Array<Product>;
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

export type ResultBase = {
  ok: Scalars['Boolean']['output'];
};

export type UserError = {
  code: Scalars['String']['output'];
  message: Scalars['String']['output'];
};

export type YahooAuctionCrawlSetting = Node & {
  __typename?: 'YahooAuctionCrawlSetting';
  categoryId: Scalars['Int']['output'];
  createdAt: Scalars['String']['output'];
  enabled: Scalars['Boolean']['output'];
  id: Scalars['ID']['output'];
  keyword: Scalars['String']['output'];
  maxPrice: Scalars['Int']['output'];
  minPrice: Scalars['Int']['output'];
  productId: Scalars['Int']['output'];
  updatedAt: Scalars['String']['output'];
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

export type GetProductsQueryVariables = Exact<{
  id?: InputMaybe<Scalars['ID']['input']>;
  name?: InputMaybe<Scalars['String']['input']>;
}>;


export type GetProductsQuery = { __typename?: 'Query', products: Array<{ __typename?: 'Product', id: string, name: string }> };

export type GetProductWithYahooAuctionProductsQueryVariables = Exact<{
  id: Scalars['ID']['input'];
  published?: InputMaybe<Scalars['Boolean']['input']>;
}>;


export type GetProductWithYahooAuctionProductsQuery = { __typename?: 'Query', product: { __typename?: 'Product', id: string, name: string, yahooAuctionProducts: Array<{ __typename?: 'YahooAuctionProduct', id: string, productId: number, yahooAuctionId: string, name: string, thumbnailUrl: string, price: number, published: boolean }> } };

export type CreateProductMutationVariables = Exact<{
  input: CreateProductInput;
}>;


export type CreateProductMutation = { __typename?: 'Mutation', createProduct: { __typename?: 'CreateProductResultError', ok: boolean, error: { __typename?: 'CreateProductResultValidationFailed', code: string, message: string, details: Array<{ __typename?: 'ErrorDetail', field: string, message: string }> } } | { __typename?: 'CreateProductResultSuccess', ok: boolean, product: { __typename?: 'Product', id: string, name: string } } };


export const GetProductsDocument = gql`
    query getProducts($id: ID, $name: String) {
  products(id: $id, name: $name) {
    id
    name
  }
}
    `;
export const GetProductWithYahooAuctionProductsDocument = gql`
    query getProductWithYahooAuctionProducts($id: ID!, $published: Boolean) {
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
export const CreateProductDocument = gql`
    mutation createProduct($input: CreateProductInput!) {
  createProduct(input: $input) {
    ... on CreateProductResultSuccess {
      ok
      product {
        id
        name
      }
    }
    ... on CreateProductResultError {
      ok
      error {
        ... on CreateProductResultValidationFailed {
          code
          message
          details {
            field
            message
          }
        }
      }
    }
  }
}
    `;

export type SdkFunctionWrapper = <T>(action: (requestHeaders?:Record<string, string>) => Promise<T>, operationName: string, operationType?: string, variables?: any) => Promise<T>;


const defaultWrapper: SdkFunctionWrapper = (action, _operationName, _operationType, variables) => action();

export function getSdk(client: GraphQLClient, withWrapper: SdkFunctionWrapper = defaultWrapper) {
  return {
    getProducts(variables?: GetProductsQueryVariables, requestHeaders?: GraphQLClientRequestHeaders): Promise<GetProductsQuery> {
      return withWrapper((wrappedRequestHeaders) => client.request<GetProductsQuery>(GetProductsDocument, variables, {...requestHeaders, ...wrappedRequestHeaders}), 'getProducts', 'query', variables);
    },
    getProductWithYahooAuctionProducts(variables: GetProductWithYahooAuctionProductsQueryVariables, requestHeaders?: GraphQLClientRequestHeaders): Promise<GetProductWithYahooAuctionProductsQuery> {
      return withWrapper((wrappedRequestHeaders) => client.request<GetProductWithYahooAuctionProductsQuery>(GetProductWithYahooAuctionProductsDocument, variables, {...requestHeaders, ...wrappedRequestHeaders}), 'getProductWithYahooAuctionProducts', 'query', variables);
    },
    createProduct(variables: CreateProductMutationVariables, requestHeaders?: GraphQLClientRequestHeaders): Promise<CreateProductMutation> {
      return withWrapper((wrappedRequestHeaders) => client.request<CreateProductMutation>(CreateProductDocument, variables, {...requestHeaders, ...wrappedRequestHeaders}), 'createProduct', 'mutation', variables);
    }
  };
}
export type Sdk = ReturnType<typeof getSdk>;