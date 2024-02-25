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

export type CreateYahooAuctionCrawlSettingExcludeKeywordInput = {
  keyword?: InputMaybe<Scalars['String']['input']>;
  productId: Scalars['ID']['input'];
};

export type CreateYahooAuctionCrawlSettingExcludeKeywordResult = CreateYahooAuctionCrawlSettingExcludeKeywordResultError | CreateYahooAuctionCrawlSettingExcludeKeywordResultSuccess;

export type CreateYahooAuctionCrawlSettingExcludeKeywordResultError = ResultBase & {
  __typename?: 'CreateYahooAuctionCrawlSettingExcludeKeywordResultError';
  error: CreateYahooAuctionCrawlSettingExcludeKeywordResultErrors;
  ok: Scalars['Boolean']['output'];
};

export type CreateYahooAuctionCrawlSettingExcludeKeywordResultErrors = CreateYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed;

export type CreateYahooAuctionCrawlSettingExcludeKeywordResultSuccess = ResultBase & {
  __typename?: 'CreateYahooAuctionCrawlSettingExcludeKeywordResultSuccess';
  ok: Scalars['Boolean']['output'];
  yahooAuctionCrawlSettingExcludeKeyword: YahooAuctionCrawlSettingExcludeKeyword;
};

export type CreateYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed = UserError & {
  __typename?: 'CreateYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed';
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

export type DeleteYahooAuctionCrawlSettingExcludeKeywordResult = DeleteYahooAuctionCrawlSettingExcludeKeywordResultError | DeleteYahooAuctionCrawlSettingExcludeKeywordResultSuccess;

export type DeleteYahooAuctionCrawlSettingExcludeKeywordResultError = ResultBase & {
  __typename?: 'DeleteYahooAuctionCrawlSettingExcludeKeywordResultError';
  error: DeleteYahooAuctionCrawlSettingExcludeKeywordResultErrors;
  ok: Scalars['Boolean']['output'];
};

export type DeleteYahooAuctionCrawlSettingExcludeKeywordResultErrors = DeleteYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed;

export type DeleteYahooAuctionCrawlSettingExcludeKeywordResultSuccess = ResultBase & {
  __typename?: 'DeleteYahooAuctionCrawlSettingExcludeKeywordResultSuccess';
  ok: Scalars['Boolean']['output'];
};

export type DeleteYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed = UserError & {
  __typename?: 'DeleteYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed';
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
  createYahooAuctionCrawlSettingExcludeKeyword: CreateYahooAuctionCrawlSettingExcludeKeywordResult;
  deleteProduct: DeleteProductResult;
  deleteYahooAuctionCrawlSettingExcludeKeyword: DeleteYahooAuctionCrawlSettingExcludeKeywordResult;
  updateProduct: UpdateProductResult;
  updateYahooAuctionCrawlSettingExcludeKeyword: UpdateYahooAuctionCrawlSettingExcludeKeywordResult;
};


export type MutationCreateProductArgs = {
  input: CreateProductInput;
};


export type MutationCreateYahooAuctionCrawlSettingExcludeKeywordArgs = {
  input: CreateYahooAuctionCrawlSettingExcludeKeywordInput;
};


export type MutationDeleteProductArgs = {
  id: Scalars['ID']['input'];
};


export type MutationDeleteYahooAuctionCrawlSettingExcludeKeywordArgs = {
  id: Scalars['ID']['input'];
  productId: Scalars['ID']['input'];
};


export type MutationUpdateProductArgs = {
  id: Scalars['ID']['input'];
  input: UpdateProductInput;
};


export type MutationUpdateYahooAuctionCrawlSettingExcludeKeywordArgs = {
  input: UpdateYahooAuctionCrawlSettingExcludeKeywordInput;
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

export type UpdateYahooAuctionCrawlSettingExcludeKeywordInput = {
  id: Scalars['ID']['input'];
  keyword?: InputMaybe<Scalars['String']['input']>;
  productId: Scalars['ID']['input'];
};

export type UpdateYahooAuctionCrawlSettingExcludeKeywordResult = UpdateYahooAuctionCrawlSettingExcludeKeywordResultError | UpdateYahooAuctionCrawlSettingExcludeKeywordResultSuccess;

export type UpdateYahooAuctionCrawlSettingExcludeKeywordResultError = ResultBase & {
  __typename?: 'UpdateYahooAuctionCrawlSettingExcludeKeywordResultError';
  error: UpdateYahooAuctionCrawlSettingExcludeKeywordResultErrors;
  ok: Scalars['Boolean']['output'];
};

export type UpdateYahooAuctionCrawlSettingExcludeKeywordResultErrors = UpdateYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed;

export type UpdateYahooAuctionCrawlSettingExcludeKeywordResultSuccess = ResultBase & {
  __typename?: 'UpdateYahooAuctionCrawlSettingExcludeKeywordResultSuccess';
  ok: Scalars['Boolean']['output'];
  yahooAuctionCrawlSettingExcludeKeyword: YahooAuctionCrawlSettingExcludeKeyword;
};

export type UpdateYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed = UserError & {
  __typename?: 'UpdateYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed';
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
  yahooAuctionCrawlSettingExcludeKeywords: Array<YahooAuctionCrawlSettingExcludeKeyword>;
};

export type YahooAuctionCrawlSettingExcludeKeyword = Node & {
  __typename?: 'YahooAuctionCrawlSettingExcludeKeyword';
  createdAt: Scalars['String']['output'];
  id: Scalars['ID']['output'];
  keyword?: Maybe<Scalars['String']['output']>;
  updatedAt: Scalars['String']['output'];
  yahooAuctionCrawlSettingId: Scalars['Int']['output'];
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


export type GetProductDetailPageDataQuery = { __typename?: 'Query', product: { __typename?: 'Product', id: string, name: string, yahooAuctionProducts: Array<{ __typename?: 'YahooAuctionProduct', id: string, productId: number, yahooAuctionId: string, name: string, thumbnailUrl: string, price: number, published: boolean }>, yahooAuctionCrawlSetting: { __typename?: 'YahooAuctionCrawlSetting', id: string, keyword: string, categoryId?: number | null, minPrice: number, maxPrice: number, enabled: boolean, yahooAuctionCrawlSettingExcludeKeywords: Array<{ __typename?: 'YahooAuctionCrawlSettingExcludeKeyword', id: string, yahooAuctionCrawlSettingId: number, keyword?: string | null, createdAt: string, updatedAt: string }> }, calculateDailyYahooAuctionProducts: Array<{ __typename?: 'CalculateDailyYahooAuctionProduct', id: string, productId: number, price?: number | null, targetDate: string, createdAt: string, updatedAt: string }> } };

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

export type CreateYahooAuctionCrawlSettingExcludeKeywordMutationVariables = Exact<{
  input: CreateYahooAuctionCrawlSettingExcludeKeywordInput;
}>;


export type CreateYahooAuctionCrawlSettingExcludeKeywordMutation = { __typename?: 'Mutation', createYahooAuctionCrawlSettingExcludeKeyword: { __typename?: 'CreateYahooAuctionCrawlSettingExcludeKeywordResultError', ok: boolean, error: { __typename?: 'CreateYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed', code: string, message: string, details: Array<{ __typename?: 'ErrorDetail', field: string, message: string }> } } | { __typename?: 'CreateYahooAuctionCrawlSettingExcludeKeywordResultSuccess', ok: boolean, yahooAuctionCrawlSettingExcludeKeyword: { __typename?: 'YahooAuctionCrawlSettingExcludeKeyword', id: string, keyword?: string | null, createdAt: string, updatedAt: string } } };

export type UpdateYahooAuctionCrawlSettingExcludeKeywordMutationVariables = Exact<{
  input: UpdateYahooAuctionCrawlSettingExcludeKeywordInput;
}>;


export type UpdateYahooAuctionCrawlSettingExcludeKeywordMutation = { __typename?: 'Mutation', updateYahooAuctionCrawlSettingExcludeKeyword: { __typename?: 'UpdateYahooAuctionCrawlSettingExcludeKeywordResultError', ok: boolean, error: { __typename?: 'UpdateYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed', code: string, message: string, details: Array<{ __typename?: 'ErrorDetail', field: string, message: string }> } } | { __typename?: 'UpdateYahooAuctionCrawlSettingExcludeKeywordResultSuccess', ok: boolean, yahooAuctionCrawlSettingExcludeKeyword: { __typename?: 'YahooAuctionCrawlSettingExcludeKeyword', id: string, keyword?: string | null, createdAt: string, updatedAt: string } } };

export type DeleteYahooAuctionCrawlSettingExcludeKeywordMutationVariables = Exact<{
  id: Scalars['ID']['input'];
  productId: Scalars['ID']['input'];
}>;


export type DeleteYahooAuctionCrawlSettingExcludeKeywordMutation = { __typename?: 'Mutation', deleteYahooAuctionCrawlSettingExcludeKeyword: { __typename?: 'DeleteYahooAuctionCrawlSettingExcludeKeywordResultError', ok: boolean, error: { __typename?: 'DeleteYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed', code: string, message: string, details: Array<{ __typename?: 'ErrorDetail', field: string, message: string }> } } | { __typename?: 'DeleteYahooAuctionCrawlSettingExcludeKeywordResultSuccess', ok: boolean } };


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
      yahooAuctionCrawlSettingExcludeKeywords {
        id
        yahooAuctionCrawlSettingId
        keyword
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
export const CreateYahooAuctionCrawlSettingExcludeKeywordDocument = gql`
    mutation createYahooAuctionCrawlSettingExcludeKeyword($input: CreateYahooAuctionCrawlSettingExcludeKeywordInput!) {
  createYahooAuctionCrawlSettingExcludeKeyword(input: $input) {
    ... on CreateYahooAuctionCrawlSettingExcludeKeywordResultSuccess {
      ok
      yahooAuctionCrawlSettingExcludeKeyword {
        id
        keyword
        createdAt
        updatedAt
      }
    }
    ... on CreateYahooAuctionCrawlSettingExcludeKeywordResultError {
      ok
      error {
        ... on CreateYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed {
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
export const UpdateYahooAuctionCrawlSettingExcludeKeywordDocument = gql`
    mutation updateYahooAuctionCrawlSettingExcludeKeyword($input: UpdateYahooAuctionCrawlSettingExcludeKeywordInput!) {
  updateYahooAuctionCrawlSettingExcludeKeyword(input: $input) {
    ... on UpdateYahooAuctionCrawlSettingExcludeKeywordResultSuccess {
      ok
      yahooAuctionCrawlSettingExcludeKeyword {
        id
        keyword
        createdAt
        updatedAt
      }
    }
    ... on UpdateYahooAuctionCrawlSettingExcludeKeywordResultError {
      ok
      error {
        ... on UpdateYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed {
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
export const DeleteYahooAuctionCrawlSettingExcludeKeywordDocument = gql`
    mutation deleteYahooAuctionCrawlSettingExcludeKeyword($id: ID!, $productId: ID!) {
  deleteYahooAuctionCrawlSettingExcludeKeyword(id: $id, productId: $productId) {
    ... on DeleteYahooAuctionCrawlSettingExcludeKeywordResultSuccess {
      ok
    }
    ... on DeleteYahooAuctionCrawlSettingExcludeKeywordResultError {
      ok
      error {
        ... on DeleteYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed {
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
    createYahooAuctionCrawlSettingExcludeKeyword(variables: CreateYahooAuctionCrawlSettingExcludeKeywordMutationVariables, requestHeaders?: GraphQLClientRequestHeaders): Promise<CreateYahooAuctionCrawlSettingExcludeKeywordMutation> {
      return withWrapper((wrappedRequestHeaders) => client.request<CreateYahooAuctionCrawlSettingExcludeKeywordMutation>(CreateYahooAuctionCrawlSettingExcludeKeywordDocument, variables, {...requestHeaders, ...wrappedRequestHeaders}), 'createYahooAuctionCrawlSettingExcludeKeyword', 'mutation', variables);
    },
    updateYahooAuctionCrawlSettingExcludeKeyword(variables: UpdateYahooAuctionCrawlSettingExcludeKeywordMutationVariables, requestHeaders?: GraphQLClientRequestHeaders): Promise<UpdateYahooAuctionCrawlSettingExcludeKeywordMutation> {
      return withWrapper((wrappedRequestHeaders) => client.request<UpdateYahooAuctionCrawlSettingExcludeKeywordMutation>(UpdateYahooAuctionCrawlSettingExcludeKeywordDocument, variables, {...requestHeaders, ...wrappedRequestHeaders}), 'updateYahooAuctionCrawlSettingExcludeKeyword', 'mutation', variables);
    },
    deleteYahooAuctionCrawlSettingExcludeKeyword(variables: DeleteYahooAuctionCrawlSettingExcludeKeywordMutationVariables, requestHeaders?: GraphQLClientRequestHeaders): Promise<DeleteYahooAuctionCrawlSettingExcludeKeywordMutation> {
      return withWrapper((wrappedRequestHeaders) => client.request<DeleteYahooAuctionCrawlSettingExcludeKeywordMutation>(DeleteYahooAuctionCrawlSettingExcludeKeywordDocument, variables, {...requestHeaders, ...wrappedRequestHeaders}), 'deleteYahooAuctionCrawlSettingExcludeKeyword', 'mutation', variables);
    }
  };
}
export type Sdk = ReturnType<typeof getSdk>;