import { GraphQLClient, RequestOptions } from 'graphql-request';
import gql from 'graphql-tag';
export type Maybe<T> = T | null;
export type InputMaybe<T> = Maybe<T>;
export type Exact<T extends { [key: string]: unknown }> = { [K in keyof T]: T[K] };
export type MakeOptional<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]?: Maybe<T[SubKey]> };
export type MakeMaybe<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]: Maybe<T[SubKey]> };
export type MakeEmpty<T extends { [key: string]: unknown }, K extends keyof T> = { [_ in K]?: never };
export type Incremental<T> = T | { [P in keyof T]?: P extends ' $fragmentName' | '__typename' ? T[P] : never };
type GraphQLClientRequestHeaders = RequestOptions['requestHeaders'];
/** All built-in and custom scalars, mapped to their actual values */
export type Scalars = {
  ID: { input: string; output: string; }
  String: { input: string; output: string; }
  Boolean: { input: boolean; output: boolean; }
  Int: { input: number; output: number; }
  Float: { input: number; output: number; }
};

export type CalculateDailyYahooAuctionProduct = Node & {
  __typename?: 'CalculateDailyYahooAuctionProduct';
  createdAt: Scalars['String']['output'];
  id: Scalars['ID']['output'];
  price?: Maybe<Scalars['Int']['output']>;
  productId: Scalars['Int']['output'];
  targetDate: Scalars['String']['output'];
  updatedAt: Scalars['String']['output'];
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

export type CreateYahooAuctionCrawlSettingExcludeConditionInput = {
  keyword?: InputMaybe<Scalars['String']['input']>;
  productId: Scalars['ID']['input'];
  seller_id?: InputMaybe<Scalars['String']['input']>;
  yahoo_auction_id?: InputMaybe<Scalars['String']['input']>;
};

export type CreateYahooAuctionCrawlSettingExcludeConditionResult = CreateYahooAuctionCrawlSettingExcludeConditionResultError | CreateYahooAuctionCrawlSettingExcludeConditionResultSuccess;

export type CreateYahooAuctionCrawlSettingExcludeConditionResultError = ResultBase & {
  __typename?: 'CreateYahooAuctionCrawlSettingExcludeConditionResultError';
  error: CreateYahooAuctionCrawlSettingExcludeConditionResultErrors;
  ok: Scalars['Boolean']['output'];
};

export type CreateYahooAuctionCrawlSettingExcludeConditionResultErrors = CreateYahooAuctionCrawlSettingExcludeConditionResultValidationFailed;

export type CreateYahooAuctionCrawlSettingExcludeConditionResultSuccess = ResultBase & {
  __typename?: 'CreateYahooAuctionCrawlSettingExcludeConditionResultSuccess';
  ok: Scalars['Boolean']['output'];
  yahooAuctionCrawlSettingExcludeCondition: YahooAuctionCrawlSettingExcludeCondition;
};

export type CreateYahooAuctionCrawlSettingExcludeConditionResultValidationFailed = UserError & {
  __typename?: 'CreateYahooAuctionCrawlSettingExcludeConditionResultValidationFailed';
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

export type DeleteYahooAuctionCrawlSettingExcludeConditionResult = DeleteYahooAuctionCrawlSettingExcludeConditionResultError | DeleteYahooAuctionCrawlSettingExcludeConditionResultSuccess;

export type DeleteYahooAuctionCrawlSettingExcludeConditionResultError = ResultBase & {
  __typename?: 'DeleteYahooAuctionCrawlSettingExcludeConditionResultError';
  error: DeleteYahooAuctionCrawlSettingExcludeConditionResultErrors;
  ok: Scalars['Boolean']['output'];
};

export type DeleteYahooAuctionCrawlSettingExcludeConditionResultErrors = DeleteYahooAuctionCrawlSettingExcludeConditionResultValidationFailed;

export type DeleteYahooAuctionCrawlSettingExcludeConditionResultSuccess = ResultBase & {
  __typename?: 'DeleteYahooAuctionCrawlSettingExcludeConditionResultSuccess';
  ok: Scalars['Boolean']['output'];
};

export type DeleteYahooAuctionCrawlSettingExcludeConditionResultValidationFailed = UserError & {
  __typename?: 'DeleteYahooAuctionCrawlSettingExcludeConditionResultValidationFailed';
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
  createYahooAuctionCrawlSettingExcludeCondition: CreateYahooAuctionCrawlSettingExcludeConditionResult;
  deleteProduct: DeleteProductResult;
  deleteYahooAuctionCrawlSettingExcludeCondition: DeleteYahooAuctionCrawlSettingExcludeConditionResult;
  updateProduct: UpdateProductResult;
};


export type MutationCreateProductArgs = {
  input: CreateProductInput;
};


export type MutationCreateYahooAuctionCrawlSettingExcludeConditionArgs = {
  input: CreateYahooAuctionCrawlSettingExcludeConditionInput;
};


export type MutationDeleteProductArgs = {
  id: Scalars['ID']['input'];
};


export type MutationDeleteYahooAuctionCrawlSettingExcludeConditionArgs = {
  id: Scalars['ID']['input'];
  productId: Scalars['ID']['input'];
};


export type MutationUpdateProductArgs = {
  id: Scalars['ID']['input'];
  input: UpdateProductInput;
};

export type Node = {
  id: Scalars['ID']['output'];
};

export type Product = Node & {
  __typename?: 'Product';
  calculateDailyYahooAuctionProducts: Array<CalculateDailyYahooAuctionProduct>;
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

export type UpdateProductInput = {
  name: Scalars['String']['input'];
  yahoo_auction_crawl_setting: UpdateYahooAuctionCrawlSettingInput;
};

export type UpdateProductResult = UpdateProductResultError | UpdateProductResultSuccess;

export type UpdateProductResultError = ResultBase & {
  __typename?: 'UpdateProductResultError';
  error: UpdateProductResultErrors;
  ok: Scalars['Boolean']['output'];
};

export type UpdateProductResultErrors = UpdateProductResultValidationFailed;

export type UpdateProductResultSuccess = ResultBase & {
  __typename?: 'UpdateProductResultSuccess';
  ok: Scalars['Boolean']['output'];
  product: Product;
};

export type UpdateProductResultValidationFailed = UserError & {
  __typename?: 'UpdateProductResultValidationFailed';
  code: Scalars['String']['output'];
  details: Array<ErrorDetail>;
  message: Scalars['String']['output'];
};

export type UpdateYahooAuctionCrawlSettingInput = {
  category_id?: InputMaybe<Scalars['Int']['input']>;
  enabled: Scalars['Boolean']['input'];
  keyword: Scalars['String']['input'];
  max_price: Scalars['Int']['input'];
  min_price: Scalars['Int']['input'];
};

export type UserError = {
  code: Scalars['String']['output'];
  message: Scalars['String']['output'];
};

export type YahooAuctionCrawlSetting = Node & {
  __typename?: 'YahooAuctionCrawlSetting';
  categoryId?: Maybe<Scalars['Int']['output']>;
  createdAt: Scalars['String']['output'];
  enabled: Scalars['Boolean']['output'];
  id: Scalars['ID']['output'];
  keyword: Scalars['String']['output'];
  maxPrice: Scalars['Int']['output'];
  minPrice: Scalars['Int']['output'];
  productId: Scalars['Int']['output'];
  updatedAt: Scalars['String']['output'];
  yahooAuctionCrawlSettingExcludeConditions: Array<YahooAuctionCrawlSettingExcludeCondition>;
};

export type YahooAuctionCrawlSettingExcludeCondition = Node & {
  __typename?: 'YahooAuctionCrawlSettingExcludeCondition';
  createdAt: Scalars['String']['output'];
  id: Scalars['ID']['output'];
  keyword?: Maybe<Scalars['String']['output']>;
  sellerId?: Maybe<Scalars['String']['output']>;
  updatedAt: Scalars['String']['output'];
  yahooAuctionCrawlSettingId: Scalars['Int']['output'];
  yahooAuctionId?: Maybe<Scalars['String']['output']>;
};

export type YahooAuctionProduct = Node & {
  __typename?: 'YahooAuctionProduct';
  boughtDate?: Maybe<Scalars['String']['output']>;
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

export type GetProductDetailPageDataQueryVariables = Exact<{
  id: Scalars['ID']['input'];
  published?: InputMaybe<Scalars['Boolean']['input']>;
}>;


export type GetProductDetailPageDataQuery = { __typename?: 'Query', product: { __typename?: 'Product', id: string, name: string, yahooAuctionProducts: Array<{ __typename?: 'YahooAuctionProduct', id: string, productId: number, yahooAuctionId: string, name: string, thumbnailUrl: string, price: number, published: boolean }>, yahooAuctionCrawlSetting: { __typename?: 'YahooAuctionCrawlSetting', id: string, keyword: string, categoryId?: number | null, minPrice: number, maxPrice: number, enabled: boolean, yahooAuctionCrawlSettingExcludeConditions: Array<{ __typename?: 'YahooAuctionCrawlSettingExcludeCondition', id: string, yahooAuctionCrawlSettingId: number, yahooAuctionId?: string | null, keyword?: string | null, sellerId?: string | null, createdAt: string, updatedAt: string }> }, calculateDailyYahooAuctionProducts: Array<{ __typename?: 'CalculateDailyYahooAuctionProduct', id: string, productId: number, price?: number | null, targetDate: string, createdAt: string, updatedAt: string }> } };

export type CreateProductMutationVariables = Exact<{
  input: CreateProductInput;
}>;


export type CreateProductMutation = { __typename?: 'Mutation', createProduct: { __typename?: 'CreateProductResultError', ok: boolean, error: { __typename?: 'CreateProductResultValidationFailed', code: string, message: string, details: Array<{ __typename?: 'ErrorDetail', field: string, message: string }> } } | { __typename?: 'CreateProductResultSuccess', ok: boolean, product: { __typename?: 'Product', id: string, name: string } } };

export type UpdateProductMutationVariables = Exact<{
  id: Scalars['ID']['input'];
  input: UpdateProductInput;
}>;


export type UpdateProductMutation = { __typename?: 'Mutation', updateProduct: { __typename?: 'UpdateProductResultError', ok: boolean, error: { __typename?: 'UpdateProductResultValidationFailed', code: string, message: string, details: Array<{ __typename?: 'ErrorDetail', field: string, message: string }> } } | { __typename?: 'UpdateProductResultSuccess', ok: boolean, product: { __typename?: 'Product', id: string, name: string } } };

export type DeleteProductMutationVariables = Exact<{
  id: Scalars['ID']['input'];
}>;


export type DeleteProductMutation = { __typename?: 'Mutation', deleteProduct: { __typename?: 'DeleteProductResultError', ok: boolean, error: { __typename?: 'DeleteProductResultValidationFailed', code: string, message: string, details: Array<{ __typename?: 'ErrorDetail', field: string, message: string }> } } | { __typename?: 'DeleteProductResultSuccess', ok: boolean } };

export type CreateYahooAuctionCrawlSettingExcludeConditionMutationVariables = Exact<{
  input: CreateYahooAuctionCrawlSettingExcludeConditionInput;
}>;


export type CreateYahooAuctionCrawlSettingExcludeConditionMutation = { __typename?: 'Mutation', createYahooAuctionCrawlSettingExcludeCondition: { __typename?: 'CreateYahooAuctionCrawlSettingExcludeConditionResultError', ok: boolean, error: { __typename?: 'CreateYahooAuctionCrawlSettingExcludeConditionResultValidationFailed', code: string, message: string, details: Array<{ __typename?: 'ErrorDetail', field: string, message: string }> } } | { __typename?: 'CreateYahooAuctionCrawlSettingExcludeConditionResultSuccess', ok: boolean, yahooAuctionCrawlSettingExcludeCondition: { __typename?: 'YahooAuctionCrawlSettingExcludeCondition', id: string, keyword?: string | null, yahooAuctionId?: string | null, sellerId?: string | null, createdAt: string, updatedAt: string } } };

export type DeleteYahooAuctionCrawlSettingExcludeConditionMutationVariables = Exact<{
  id: Scalars['ID']['input'];
  productId: Scalars['ID']['input'];
}>;


export type DeleteYahooAuctionCrawlSettingExcludeConditionMutation = { __typename?: 'Mutation', deleteYahooAuctionCrawlSettingExcludeCondition: { __typename?: 'DeleteYahooAuctionCrawlSettingExcludeConditionResultError', ok: boolean, error: { __typename?: 'DeleteYahooAuctionCrawlSettingExcludeConditionResultValidationFailed', code: string, message: string, details: Array<{ __typename?: 'ErrorDetail', field: string, message: string }> } } | { __typename?: 'DeleteYahooAuctionCrawlSettingExcludeConditionResultSuccess', ok: boolean } };


export const GetProductsDocument = gql`
    query getProducts($id: ID, $name: String) {
  products(id: $id, name: $name) {
    id
    name
  }
}
    `;
export const GetProductDetailPageDataDocument = gql`
    query getProductDetailPageData($id: ID!, $published: Boolean) {
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
    yahooAuctionCrawlSetting {
      id
      keyword
      categoryId
      minPrice
      maxPrice
      enabled
      yahooAuctionCrawlSettingExcludeConditions {
        id
        yahooAuctionCrawlSettingId
        yahooAuctionId
        keyword
        sellerId
        createdAt
        updatedAt
      }
    }
    calculateDailyYahooAuctionProducts {
      id
      productId
      price
      targetDate
      createdAt
      updatedAt
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
export const UpdateProductDocument = gql`
    mutation updateProduct($id: ID!, $input: UpdateProductInput!) {
  updateProduct(id: $id, input: $input) {
    ... on UpdateProductResultSuccess {
      ok
      product {
        id
        name
      }
    }
    ... on UpdateProductResultError {
      ok
      error {
        ... on UpdateProductResultValidationFailed {
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
export const DeleteProductDocument = gql`
    mutation deleteProduct($id: ID!) {
  deleteProduct(id: $id) {
    ... on DeleteProductResultSuccess {
      ok
    }
    ... on DeleteProductResultError {
      ok
      error {
        ... on DeleteProductResultValidationFailed {
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
export const CreateYahooAuctionCrawlSettingExcludeConditionDocument = gql`
    mutation createYahooAuctionCrawlSettingExcludeCondition($input: CreateYahooAuctionCrawlSettingExcludeConditionInput!) {
  createYahooAuctionCrawlSettingExcludeCondition(input: $input) {
    ... on CreateYahooAuctionCrawlSettingExcludeConditionResultSuccess {
      ok
      yahooAuctionCrawlSettingExcludeCondition {
        id
        keyword
        yahooAuctionId
        sellerId
        createdAt
        updatedAt
      }
    }
    ... on CreateYahooAuctionCrawlSettingExcludeConditionResultError {
      ok
      error {
        ... on CreateYahooAuctionCrawlSettingExcludeConditionResultValidationFailed {
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
export const DeleteYahooAuctionCrawlSettingExcludeConditionDocument = gql`
    mutation deleteYahooAuctionCrawlSettingExcludeCondition($id: ID!, $productId: ID!) {
  deleteYahooAuctionCrawlSettingExcludeCondition(id: $id, productId: $productId) {
    ... on DeleteYahooAuctionCrawlSettingExcludeConditionResultSuccess {
      ok
    }
    ... on DeleteYahooAuctionCrawlSettingExcludeConditionResultError {
      ok
      error {
        ... on DeleteYahooAuctionCrawlSettingExcludeConditionResultValidationFailed {
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


const defaultWrapper: SdkFunctionWrapper = (action, _operationName, _operationType, _variables) => action();

export function getSdk(client: GraphQLClient, withWrapper: SdkFunctionWrapper = defaultWrapper) {
  return {
    getProducts(variables?: GetProductsQueryVariables, requestHeaders?: GraphQLClientRequestHeaders): Promise<GetProductsQuery> {
      return withWrapper((wrappedRequestHeaders) => client.request<GetProductsQuery>(GetProductsDocument, variables, {...requestHeaders, ...wrappedRequestHeaders}), 'getProducts', 'query', variables);
    },
    getProductDetailPageData(variables: GetProductDetailPageDataQueryVariables, requestHeaders?: GraphQLClientRequestHeaders): Promise<GetProductDetailPageDataQuery> {
      return withWrapper((wrappedRequestHeaders) => client.request<GetProductDetailPageDataQuery>(GetProductDetailPageDataDocument, variables, {...requestHeaders, ...wrappedRequestHeaders}), 'getProductDetailPageData', 'query', variables);
    },
    createProduct(variables: CreateProductMutationVariables, requestHeaders?: GraphQLClientRequestHeaders): Promise<CreateProductMutation> {
      return withWrapper((wrappedRequestHeaders) => client.request<CreateProductMutation>(CreateProductDocument, variables, {...requestHeaders, ...wrappedRequestHeaders}), 'createProduct', 'mutation', variables);
    },
    updateProduct(variables: UpdateProductMutationVariables, requestHeaders?: GraphQLClientRequestHeaders): Promise<UpdateProductMutation> {
      return withWrapper((wrappedRequestHeaders) => client.request<UpdateProductMutation>(UpdateProductDocument, variables, {...requestHeaders, ...wrappedRequestHeaders}), 'updateProduct', 'mutation', variables);
    },
    deleteProduct(variables: DeleteProductMutationVariables, requestHeaders?: GraphQLClientRequestHeaders): Promise<DeleteProductMutation> {
      return withWrapper((wrappedRequestHeaders) => client.request<DeleteProductMutation>(DeleteProductDocument, variables, {...requestHeaders, ...wrappedRequestHeaders}), 'deleteProduct', 'mutation', variables);
    },
    createYahooAuctionCrawlSettingExcludeCondition(variables: CreateYahooAuctionCrawlSettingExcludeConditionMutationVariables, requestHeaders?: GraphQLClientRequestHeaders): Promise<CreateYahooAuctionCrawlSettingExcludeConditionMutation> {
      return withWrapper((wrappedRequestHeaders) => client.request<CreateYahooAuctionCrawlSettingExcludeConditionMutation>(CreateYahooAuctionCrawlSettingExcludeConditionDocument, variables, {...requestHeaders, ...wrappedRequestHeaders}), 'createYahooAuctionCrawlSettingExcludeCondition', 'mutation', variables);
    },
    deleteYahooAuctionCrawlSettingExcludeCondition(variables: DeleteYahooAuctionCrawlSettingExcludeConditionMutationVariables, requestHeaders?: GraphQLClientRequestHeaders): Promise<DeleteYahooAuctionCrawlSettingExcludeConditionMutation> {
      return withWrapper((wrappedRequestHeaders) => client.request<DeleteYahooAuctionCrawlSettingExcludeConditionMutation>(DeleteYahooAuctionCrawlSettingExcludeConditionDocument, variables, {...requestHeaders, ...wrappedRequestHeaders}), 'deleteYahooAuctionCrawlSettingExcludeCondition', 'mutation', variables);
    }
  };
}
export type Sdk = ReturnType<typeof getSdk>;