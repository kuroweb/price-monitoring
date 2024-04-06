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

export type CreateMercariCrawlSettingExcludeKeywordInput = {
  keyword?: InputMaybe<Scalars['String']['input']>;
  productId: Scalars['ID']['input'];
};

export type CreateMercariCrawlSettingExcludeKeywordResult = CreateMercariCrawlSettingExcludeKeywordResultError | CreateMercariCrawlSettingExcludeKeywordResultSuccess;

export type CreateMercariCrawlSettingExcludeKeywordResultError = ResultBase & {
  __typename?: 'CreateMercariCrawlSettingExcludeKeywordResultError';
  error: CreateMercariCrawlSettingExcludeKeywordResultErrors;
  ok: Scalars['Boolean']['output'];
};

export type CreateMercariCrawlSettingExcludeKeywordResultErrors = CreateMercariCrawlSettingExcludeKeywordResultValidationFailed;

export type CreateMercariCrawlSettingExcludeKeywordResultSuccess = ResultBase & {
  __typename?: 'CreateMercariCrawlSettingExcludeKeywordResultSuccess';
  mercariCrawlSettingExcludeKeyword: MercariCrawlSettingExcludeKeyword;
  ok: Scalars['Boolean']['output'];
};

export type CreateMercariCrawlSettingExcludeKeywordResultValidationFailed = UserError & {
  __typename?: 'CreateMercariCrawlSettingExcludeKeywordResultValidationFailed';
  code: Scalars['String']['output'];
  details: Array<ErrorDetail>;
  message: Scalars['String']['output'];
};

export type CreateMercariCrawlSettingInput = {
  category_id?: InputMaybe<Scalars['Int']['input']>;
  enabled: Scalars['Boolean']['input'];
  keyword: Scalars['String']['input'];
  max_price: Scalars['Int']['input'];
  min_price: Scalars['Int']['input'];
};

export type CreateMercariCrawlSettingRequiredKeywordInput = {
  keyword?: InputMaybe<Scalars['String']['input']>;
  productId: Scalars['ID']['input'];
};

export type CreateMercariCrawlSettingRequiredKeywordResult = CreateMercariCrawlSettingRequiredKeywordResultError | CreateMercariCrawlSettingRequiredKeywordResultSuccess;

export type CreateMercariCrawlSettingRequiredKeywordResultError = ResultBase & {
  __typename?: 'CreateMercariCrawlSettingRequiredKeywordResultError';
  error: CreateMercariCrawlSettingRequiredKeywordResultErrors;
  ok: Scalars['Boolean']['output'];
};

export type CreateMercariCrawlSettingRequiredKeywordResultErrors = CreateMercariCrawlSettingRequiredKeywordResultValidationFailed;

export type CreateMercariCrawlSettingRequiredKeywordResultSuccess = ResultBase & {
  __typename?: 'CreateMercariCrawlSettingRequiredKeywordResultSuccess';
  mercariCrawlSettingRequiredKeyword: MercariCrawlSettingRequiredKeyword;
  ok: Scalars['Boolean']['output'];
};

export type CreateMercariCrawlSettingRequiredKeywordResultValidationFailed = UserError & {
  __typename?: 'CreateMercariCrawlSettingRequiredKeywordResultValidationFailed';
  code: Scalars['String']['output'];
  details: Array<ErrorDetail>;
  message: Scalars['String']['output'];
};

export type CreateProductInput = {
  mercari_crawl_setting: CreateMercariCrawlSettingInput;
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

export type CreateYahooAuctionCrawlSettingRequiredKeywordInput = {
  keyword?: InputMaybe<Scalars['String']['input']>;
  productId: Scalars['ID']['input'];
};

export type CreateYahooAuctionCrawlSettingRequiredKeywordResult = CreateYahooAuctionCrawlSettingRequiredKeywordResultError | CreateYahooAuctionCrawlSettingRequiredKeywordResultSuccess;

export type CreateYahooAuctionCrawlSettingRequiredKeywordResultError = ResultBase & {
  __typename?: 'CreateYahooAuctionCrawlSettingRequiredKeywordResultError';
  error: CreateYahooAuctionCrawlSettingRequiredKeywordResultErrors;
  ok: Scalars['Boolean']['output'];
};

export type CreateYahooAuctionCrawlSettingRequiredKeywordResultErrors = CreateYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed;

export type CreateYahooAuctionCrawlSettingRequiredKeywordResultSuccess = ResultBase & {
  __typename?: 'CreateYahooAuctionCrawlSettingRequiredKeywordResultSuccess';
  ok: Scalars['Boolean']['output'];
  yahooAuctionCrawlSettingRequiredKeyword: YahooAuctionCrawlSettingRequiredKeyword;
};

export type CreateYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed = UserError & {
  __typename?: 'CreateYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed';
  code: Scalars['String']['output'];
  details: Array<ErrorDetail>;
  message: Scalars['String']['output'];
};

export type DeleteMercariCrawlSettingExcludeKeywordResult = DeleteMercariCrawlSettingExcludeKeywordResultError | DeleteMercariCrawlSettingExcludeKeywordResultSuccess;

export type DeleteMercariCrawlSettingExcludeKeywordResultError = ResultBase & {
  __typename?: 'DeleteMercariCrawlSettingExcludeKeywordResultError';
  error: DeleteMercariCrawlSettingExcludeKeywordResultErrors;
  ok: Scalars['Boolean']['output'];
};

export type DeleteMercariCrawlSettingExcludeKeywordResultErrors = DeleteMercariCrawlSettingExcludeKeywordResultValidationFailed;

export type DeleteMercariCrawlSettingExcludeKeywordResultSuccess = ResultBase & {
  __typename?: 'DeleteMercariCrawlSettingExcludeKeywordResultSuccess';
  ok: Scalars['Boolean']['output'];
};

export type DeleteMercariCrawlSettingExcludeKeywordResultValidationFailed = UserError & {
  __typename?: 'DeleteMercariCrawlSettingExcludeKeywordResultValidationFailed';
  code: Scalars['String']['output'];
  details: Array<ErrorDetail>;
  message: Scalars['String']['output'];
};

export type DeleteMercariCrawlSettingRequiredKeywordResult = DeleteMercariCrawlSettingRequiredKeywordResultError | DeleteMercariCrawlSettingRequiredKeywordResultSuccess;

export type DeleteMercariCrawlSettingRequiredKeywordResultError = ResultBase & {
  __typename?: 'DeleteMercariCrawlSettingRequiredKeywordResultError';
  error: DeleteMercariCrawlSettingRequiredKeywordResultErrors;
  ok: Scalars['Boolean']['output'];
};

export type DeleteMercariCrawlSettingRequiredKeywordResultErrors = DeleteMercariCrawlSettingRequiredKeywordResultValidationFailed;

export type DeleteMercariCrawlSettingRequiredKeywordResultSuccess = ResultBase & {
  __typename?: 'DeleteMercariCrawlSettingRequiredKeywordResultSuccess';
  ok: Scalars['Boolean']['output'];
};

export type DeleteMercariCrawlSettingRequiredKeywordResultValidationFailed = UserError & {
  __typename?: 'DeleteMercariCrawlSettingRequiredKeywordResultValidationFailed';
  code: Scalars['String']['output'];
  details: Array<ErrorDetail>;
  message: Scalars['String']['output'];
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

export type DeleteYahooAuctionCrawlSettingRequiredKeywordResult = DeleteYahooAuctionCrawlSettingRequiredKeywordResultError | DeleteYahooAuctionCrawlSettingRequiredKeywordResultSuccess;

export type DeleteYahooAuctionCrawlSettingRequiredKeywordResultError = ResultBase & {
  __typename?: 'DeleteYahooAuctionCrawlSettingRequiredKeywordResultError';
  error: DeleteYahooAuctionCrawlSettingRequiredKeywordResultErrors;
  ok: Scalars['Boolean']['output'];
};

export type DeleteYahooAuctionCrawlSettingRequiredKeywordResultErrors = DeleteYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed;

export type DeleteYahooAuctionCrawlSettingRequiredKeywordResultSuccess = ResultBase & {
  __typename?: 'DeleteYahooAuctionCrawlSettingRequiredKeywordResultSuccess';
  ok: Scalars['Boolean']['output'];
};

export type DeleteYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed = UserError & {
  __typename?: 'DeleteYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed';
  code: Scalars['String']['output'];
  details: Array<ErrorDetail>;
  message: Scalars['String']['output'];
};

export type ErrorDetail = {
  __typename?: 'ErrorDetail';
  field: Scalars['String']['output'];
  message: Scalars['String']['output'];
};

export type MercariCrawlSetting = Node & {
  __typename?: 'MercariCrawlSetting';
  categoryId?: Maybe<Scalars['Int']['output']>;
  createdAt: Scalars['String']['output'];
  enabled: Scalars['Boolean']['output'];
  id: Scalars['ID']['output'];
  keyword: Scalars['String']['output'];
  maxPrice: Scalars['Int']['output'];
  mercariCrawlSettingExcludeKeywords: Array<MercariCrawlSettingExcludeKeyword>;
  mercariCrawlSettingRequiredKeywords: Array<MercariCrawlSettingRequiredKeyword>;
  minPrice: Scalars['Int']['output'];
  productId: Scalars['Int']['output'];
  updatedAt: Scalars['String']['output'];
};

export type MercariCrawlSettingExcludeKeyword = Node & {
  __typename?: 'MercariCrawlSettingExcludeKeyword';
  createdAt: Scalars['String']['output'];
  id: Scalars['ID']['output'];
  keyword?: Maybe<Scalars['String']['output']>;
  mercariCrawlSettingId: Scalars['Int']['output'];
  updatedAt: Scalars['String']['output'];
};

export type MercariCrawlSettingRequiredKeyword = Node & {
  __typename?: 'MercariCrawlSettingRequiredKeyword';
  createdAt: Scalars['String']['output'];
  id: Scalars['ID']['output'];
  keyword?: Maybe<Scalars['String']['output']>;
  mercariCrawlSettingId: Scalars['Int']['output'];
  updatedAt: Scalars['String']['output'];
};

export type MercariDailyPurchaseSummary = Node & {
  __typename?: 'MercariDailyPurchaseSummary';
  averagePurchasePrice?: Maybe<Scalars['Int']['output']>;
  createdAt: Scalars['String']['output'];
  date: Scalars['String']['output'];
  id: Scalars['ID']['output'];
  productId: Scalars['Int']['output'];
  purchaseCount: Scalars['Int']['output'];
  updatedAt: Scalars['String']['output'];
};

export type MercariProduct = Node & {
  __typename?: 'MercariProduct';
  boughtDate?: Maybe<Scalars['String']['output']>;
  createdAt: Scalars['String']['output'];
  id: Scalars['ID']['output'];
  mercariId: Scalars['String']['output'];
  name: Scalars['String']['output'];
  price: Scalars['Int']['output'];
  productId: Scalars['Int']['output'];
  published: Scalars['Boolean']['output'];
  thumbnailUrl: Scalars['String']['output'];
  updatedAt: Scalars['String']['output'];
};

export type Mutation = {
  __typename?: 'Mutation';
  createMercariCrawlSettingExcludeKeyword: CreateMercariCrawlSettingExcludeKeywordResult;
  createMercariCrawlSettingRequiredKeyword: CreateMercariCrawlSettingRequiredKeywordResult;
  createProduct: CreateProductResult;
  createYahooAuctionCrawlSettingExcludeKeyword: CreateYahooAuctionCrawlSettingExcludeKeywordResult;
  createYahooAuctionCrawlSettingRequiredKeyword: CreateYahooAuctionCrawlSettingRequiredKeywordResult;
  deleteMercariCrawlSettingExcludeKeyword: DeleteMercariCrawlSettingExcludeKeywordResult;
  deleteMercariCrawlSettingRequiredKeyword: DeleteMercariCrawlSettingRequiredKeywordResult;
  deleteProduct: DeleteProductResult;
  deleteYahooAuctionCrawlSettingExcludeKeyword: DeleteYahooAuctionCrawlSettingExcludeKeywordResult;
  deleteYahooAuctionCrawlSettingRequiredKeyword: DeleteYahooAuctionCrawlSettingRequiredKeywordResult;
  updateMercariCrawlSettingExcludeKeyword: UpdateMercariCrawlSettingExcludeKeywordResult;
  updateMercariCrawlSettingRequiredKeyword: UpdateMercariCrawlSettingRequiredKeywordResult;
  updateProduct: UpdateProductResult;
  updateYahooAuctionCrawlSettingExcludeKeyword: UpdateYahooAuctionCrawlSettingExcludeKeywordResult;
  updateYahooAuctionCrawlSettingRequiredKeyword: UpdateYahooAuctionCrawlSettingRequiredKeywordResult;
};


export type MutationCreateMercariCrawlSettingExcludeKeywordArgs = {
  input: CreateMercariCrawlSettingExcludeKeywordInput;
};


export type MutationCreateMercariCrawlSettingRequiredKeywordArgs = {
  input: CreateMercariCrawlSettingRequiredKeywordInput;
};


export type MutationCreateProductArgs = {
  input: CreateProductInput;
};


export type MutationCreateYahooAuctionCrawlSettingExcludeKeywordArgs = {
  input: CreateYahooAuctionCrawlSettingExcludeKeywordInput;
};


export type MutationCreateYahooAuctionCrawlSettingRequiredKeywordArgs = {
  input: CreateYahooAuctionCrawlSettingRequiredKeywordInput;
};


export type MutationDeleteMercariCrawlSettingExcludeKeywordArgs = {
  id: Scalars['ID']['input'];
  productId: Scalars['ID']['input'];
};


export type MutationDeleteMercariCrawlSettingRequiredKeywordArgs = {
  id: Scalars['ID']['input'];
  productId: Scalars['ID']['input'];
};


export type MutationDeleteProductArgs = {
  id: Scalars['ID']['input'];
};


export type MutationDeleteYahooAuctionCrawlSettingExcludeKeywordArgs = {
  id: Scalars['ID']['input'];
  productId: Scalars['ID']['input'];
};


export type MutationDeleteYahooAuctionCrawlSettingRequiredKeywordArgs = {
  id: Scalars['ID']['input'];
  productId: Scalars['ID']['input'];
};


export type MutationUpdateMercariCrawlSettingExcludeKeywordArgs = {
  input: UpdateMercariCrawlSettingExcludeKeywordInput;
};


export type MutationUpdateMercariCrawlSettingRequiredKeywordArgs = {
  input: UpdateMercariCrawlSettingRequiredKeywordInput;
};


export type MutationUpdateProductArgs = {
  id: Scalars['ID']['input'];
  input: UpdateProductInput;
};


export type MutationUpdateYahooAuctionCrawlSettingExcludeKeywordArgs = {
  input: UpdateYahooAuctionCrawlSettingExcludeKeywordInput;
};


export type MutationUpdateYahooAuctionCrawlSettingRequiredKeywordArgs = {
  input: UpdateYahooAuctionCrawlSettingRequiredKeywordInput;
};

export type Node = {
  id: Scalars['ID']['output'];
};

export type Product = Node & {
  __typename?: 'Product';
  id: Scalars['ID']['output'];
  mercariCrawlSetting: MercariCrawlSetting;
  mercariDailyPurchaseSummaries: Array<MercariDailyPurchaseSummary>;
  mercariProducts: Array<MercariProduct>;
  name: Scalars['String']['output'];
  relatedProducts: Array<RelatedProduct>;
  yahooAuctionCrawlSetting: YahooAuctionCrawlSetting;
  yahooAuctionDailyPurchaseSummaries: Array<YahooAuctionDailyPurchaseSummary>;
  yahooAuctionProducts: Array<YahooAuctionProduct>;
};


export type ProductMercariProductsArgs = {
  order?: InputMaybe<Scalars['String']['input']>;
  published?: InputMaybe<Scalars['Boolean']['input']>;
  sort?: InputMaybe<Scalars['String']['input']>;
};


export type ProductRelatedProductsArgs = {
  order?: InputMaybe<Scalars['String']['input']>;
  page?: InputMaybe<Scalars['Int']['input']>;
  per?: InputMaybe<Scalars['Int']['input']>;
  published?: InputMaybe<Scalars['Boolean']['input']>;
  sort?: InputMaybe<Scalars['String']['input']>;
};


export type ProductYahooAuctionProductsArgs = {
  order?: InputMaybe<Scalars['String']['input']>;
  published?: InputMaybe<Scalars['Boolean']['input']>;
  sort?: InputMaybe<Scalars['String']['input']>;
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

export type RelatedProduct = {
  __typename?: 'RelatedProduct';
  boughtDate?: Maybe<Scalars['String']['output']>;
  createdAt: Scalars['String']['output'];
  externalId: Scalars['String']['output'];
  name: Scalars['String']['output'];
  price: Scalars['Int']['output'];
  productId: Scalars['Int']['output'];
  published: Scalars['Boolean']['output'];
  relatedType: Scalars['String']['output'];
  thumbnailUrl: Scalars['String']['output'];
  updatedAt: Scalars['String']['output'];
};

export type ResultBase = {
  ok: Scalars['Boolean']['output'];
};

export type UpdateMercariCrawlSettingExcludeKeywordInput = {
  id: Scalars['ID']['input'];
  keyword?: InputMaybe<Scalars['String']['input']>;
  productId: Scalars['ID']['input'];
};

export type UpdateMercariCrawlSettingExcludeKeywordResult = UpdateMercariCrawlSettingExcludeKeywordResultError | UpdateMercariCrawlSettingExcludeKeywordResultSuccess;

export type UpdateMercariCrawlSettingExcludeKeywordResultError = ResultBase & {
  __typename?: 'UpdateMercariCrawlSettingExcludeKeywordResultError';
  error: UpdateMercariCrawlSettingExcludeKeywordResultErrors;
  ok: Scalars['Boolean']['output'];
};

export type UpdateMercariCrawlSettingExcludeKeywordResultErrors = UpdateMercariCrawlSettingExcludeKeywordResultValidationFailed;

export type UpdateMercariCrawlSettingExcludeKeywordResultSuccess = ResultBase & {
  __typename?: 'UpdateMercariCrawlSettingExcludeKeywordResultSuccess';
  mercariCrawlSettingExcludeKeyword: MercariCrawlSettingExcludeKeyword;
  ok: Scalars['Boolean']['output'];
};

export type UpdateMercariCrawlSettingExcludeKeywordResultValidationFailed = UserError & {
  __typename?: 'UpdateMercariCrawlSettingExcludeKeywordResultValidationFailed';
  code: Scalars['String']['output'];
  details: Array<ErrorDetail>;
  message: Scalars['String']['output'];
};

export type UpdateMercariCrawlSettingInput = {
  category_id?: InputMaybe<Scalars['Int']['input']>;
  enabled: Scalars['Boolean']['input'];
  keyword: Scalars['String']['input'];
  max_price: Scalars['Int']['input'];
  min_price: Scalars['Int']['input'];
};

export type UpdateMercariCrawlSettingRequiredKeywordInput = {
  id: Scalars['ID']['input'];
  keyword?: InputMaybe<Scalars['String']['input']>;
  productId: Scalars['ID']['input'];
};

export type UpdateMercariCrawlSettingRequiredKeywordResult = UpdateMercariCrawlSettingRequiredKeywordResultError | UpdateMercariCrawlSettingRequiredKeywordResultSuccess;

export type UpdateMercariCrawlSettingRequiredKeywordResultError = ResultBase & {
  __typename?: 'UpdateMercariCrawlSettingRequiredKeywordResultError';
  error: UpdateMercariCrawlSettingRequiredKeywordResultErrors;
  ok: Scalars['Boolean']['output'];
};

export type UpdateMercariCrawlSettingRequiredKeywordResultErrors = UpdateMercariCrawlSettingRequiredKeywordResultValidationFailed;

export type UpdateMercariCrawlSettingRequiredKeywordResultSuccess = ResultBase & {
  __typename?: 'UpdateMercariCrawlSettingRequiredKeywordResultSuccess';
  mercariCrawlSettingRequiredKeyword: MercariCrawlSettingRequiredKeyword;
  ok: Scalars['Boolean']['output'];
};

export type UpdateMercariCrawlSettingRequiredKeywordResultValidationFailed = UserError & {
  __typename?: 'UpdateMercariCrawlSettingRequiredKeywordResultValidationFailed';
  code: Scalars['String']['output'];
  details: Array<ErrorDetail>;
  message: Scalars['String']['output'];
};

export type UpdateProductInput = {
  mercari_crawl_setting: UpdateMercariCrawlSettingInput;
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

export type UpdateYahooAuctionCrawlSettingRequiredKeywordInput = {
  id: Scalars['ID']['input'];
  keyword?: InputMaybe<Scalars['String']['input']>;
  productId: Scalars['ID']['input'];
};

export type UpdateYahooAuctionCrawlSettingRequiredKeywordResult = UpdateYahooAuctionCrawlSettingRequiredKeywordResultError | UpdateYahooAuctionCrawlSettingRequiredKeywordResultSuccess;

export type UpdateYahooAuctionCrawlSettingRequiredKeywordResultError = ResultBase & {
  __typename?: 'UpdateYahooAuctionCrawlSettingRequiredKeywordResultError';
  error: UpdateYahooAuctionCrawlSettingRequiredKeywordResultErrors;
  ok: Scalars['Boolean']['output'];
};

export type UpdateYahooAuctionCrawlSettingRequiredKeywordResultErrors = UpdateYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed;

export type UpdateYahooAuctionCrawlSettingRequiredKeywordResultSuccess = ResultBase & {
  __typename?: 'UpdateYahooAuctionCrawlSettingRequiredKeywordResultSuccess';
  ok: Scalars['Boolean']['output'];
  yahooAuctionCrawlSettingRequiredKeyword: YahooAuctionCrawlSettingRequiredKeyword;
};

export type UpdateYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed = UserError & {
  __typename?: 'UpdateYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed';
  code: Scalars['String']['output'];
  details: Array<ErrorDetail>;
  message: Scalars['String']['output'];
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
  yahooAuctionCrawlSettingRequiredKeywords: Array<YahooAuctionCrawlSettingRequiredKeyword>;
};

export type YahooAuctionCrawlSettingExcludeKeyword = Node & {
  __typename?: 'YahooAuctionCrawlSettingExcludeKeyword';
  createdAt: Scalars['String']['output'];
  id: Scalars['ID']['output'];
  keyword?: Maybe<Scalars['String']['output']>;
  updatedAt: Scalars['String']['output'];
  yahooAuctionCrawlSettingId: Scalars['Int']['output'];
};

export type YahooAuctionCrawlSettingRequiredKeyword = Node & {
  __typename?: 'YahooAuctionCrawlSettingRequiredKeyword';
  createdAt: Scalars['String']['output'];
  id: Scalars['ID']['output'];
  keyword?: Maybe<Scalars['String']['output']>;
  updatedAt: Scalars['String']['output'];
  yahooAuctionCrawlSettingId: Scalars['Int']['output'];
};

export type YahooAuctionDailyPurchaseSummary = Node & {
  __typename?: 'YahooAuctionDailyPurchaseSummary';
  averagePurchasePrice?: Maybe<Scalars['Int']['output']>;
  createdAt: Scalars['String']['output'];
  date: Scalars['String']['output'];
  id: Scalars['ID']['output'];
  productId: Scalars['Int']['output'];
  purchaseCount: Scalars['Int']['output'];
  updatedAt: Scalars['String']['output'];
};

export type YahooAuctionProduct = Node & {
  __typename?: 'YahooAuctionProduct';
  boughtDate?: Maybe<Scalars['String']['output']>;
  createdAt: Scalars['String']['output'];
  id: Scalars['ID']['output'];
  name: Scalars['String']['output'];
  price: Scalars['Int']['output'];
  productId: Scalars['Int']['output'];
  published: Scalars['Boolean']['output'];
  thumbnailUrl: Scalars['String']['output'];
  updatedAt: Scalars['String']['output'];
  yahooAuctionId: Scalars['String']['output'];
};

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

export type CreateYahooAuctionCrawlSettingRequiredKeywordMutationVariables = Exact<{
  input: CreateYahooAuctionCrawlSettingRequiredKeywordInput;
}>;


export type CreateYahooAuctionCrawlSettingRequiredKeywordMutation = { __typename?: 'Mutation', createYahooAuctionCrawlSettingRequiredKeyword: { __typename?: 'CreateYahooAuctionCrawlSettingRequiredKeywordResultError', ok: boolean, error: { __typename?: 'CreateYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed', code: string, message: string, details: Array<{ __typename?: 'ErrorDetail', field: string, message: string }> } } | { __typename?: 'CreateYahooAuctionCrawlSettingRequiredKeywordResultSuccess', ok: boolean, yahooAuctionCrawlSettingRequiredKeyword: { __typename?: 'YahooAuctionCrawlSettingRequiredKeyword', id: string, keyword?: string | null, createdAt: string, updatedAt: string } } };

export type UpdateYahooAuctionCrawlSettingRequiredKeywordMutationVariables = Exact<{
  input: UpdateYahooAuctionCrawlSettingRequiredKeywordInput;
}>;


export type UpdateYahooAuctionCrawlSettingRequiredKeywordMutation = { __typename?: 'Mutation', updateYahooAuctionCrawlSettingRequiredKeyword: { __typename?: 'UpdateYahooAuctionCrawlSettingRequiredKeywordResultError', ok: boolean, error: { __typename?: 'UpdateYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed', code: string, message: string, details: Array<{ __typename?: 'ErrorDetail', field: string, message: string }> } } | { __typename?: 'UpdateYahooAuctionCrawlSettingRequiredKeywordResultSuccess', ok: boolean, yahooAuctionCrawlSettingRequiredKeyword: { __typename?: 'YahooAuctionCrawlSettingRequiredKeyword', id: string, keyword?: string | null, createdAt: string, updatedAt: string } } };

export type DeleteYahooAuctionCrawlSettingRequiredKeywordMutationVariables = Exact<{
  id: Scalars['ID']['input'];
  productId: Scalars['ID']['input'];
}>;


export type DeleteYahooAuctionCrawlSettingRequiredKeywordMutation = { __typename?: 'Mutation', deleteYahooAuctionCrawlSettingRequiredKeyword: { __typename?: 'DeleteYahooAuctionCrawlSettingRequiredKeywordResultError', ok: boolean, error: { __typename?: 'DeleteYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed', code: string, message: string, details: Array<{ __typename?: 'ErrorDetail', field: string, message: string }> } } | { __typename?: 'DeleteYahooAuctionCrawlSettingRequiredKeywordResultSuccess', ok: boolean } };

export type CreateMercariCrawlSettingExcludeKeywordMutationVariables = Exact<{
  input: CreateMercariCrawlSettingExcludeKeywordInput;
}>;


export type CreateMercariCrawlSettingExcludeKeywordMutation = { __typename?: 'Mutation', createMercariCrawlSettingExcludeKeyword: { __typename?: 'CreateMercariCrawlSettingExcludeKeywordResultError', ok: boolean, error: { __typename?: 'CreateMercariCrawlSettingExcludeKeywordResultValidationFailed', code: string, message: string, details: Array<{ __typename?: 'ErrorDetail', field: string, message: string }> } } | { __typename?: 'CreateMercariCrawlSettingExcludeKeywordResultSuccess', ok: boolean, mercariCrawlSettingExcludeKeyword: { __typename?: 'MercariCrawlSettingExcludeKeyword', id: string, keyword?: string | null, createdAt: string, updatedAt: string } } };

export type UpdateMercariCrawlSettingExcludeKeywordMutationVariables = Exact<{
  input: UpdateMercariCrawlSettingExcludeKeywordInput;
}>;


export type UpdateMercariCrawlSettingExcludeKeywordMutation = { __typename?: 'Mutation', updateMercariCrawlSettingExcludeKeyword: { __typename?: 'UpdateMercariCrawlSettingExcludeKeywordResultError', ok: boolean, error: { __typename?: 'UpdateMercariCrawlSettingExcludeKeywordResultValidationFailed', code: string, message: string, details: Array<{ __typename?: 'ErrorDetail', field: string, message: string }> } } | { __typename?: 'UpdateMercariCrawlSettingExcludeKeywordResultSuccess', ok: boolean, mercariCrawlSettingExcludeKeyword: { __typename?: 'MercariCrawlSettingExcludeKeyword', id: string, keyword?: string | null, createdAt: string, updatedAt: string } } };

export type DeleteMercariCrawlSettingExcludeKeywordMutationVariables = Exact<{
  id: Scalars['ID']['input'];
  productId: Scalars['ID']['input'];
}>;


export type DeleteMercariCrawlSettingExcludeKeywordMutation = { __typename?: 'Mutation', deleteMercariCrawlSettingExcludeKeyword: { __typename?: 'DeleteMercariCrawlSettingExcludeKeywordResultError', ok: boolean, error: { __typename?: 'DeleteMercariCrawlSettingExcludeKeywordResultValidationFailed', code: string, message: string, details: Array<{ __typename?: 'ErrorDetail', field: string, message: string }> } } | { __typename?: 'DeleteMercariCrawlSettingExcludeKeywordResultSuccess', ok: boolean } };

export type CreateMercariCrawlSettingRequiredKeywordMutationVariables = Exact<{
  input: CreateMercariCrawlSettingRequiredKeywordInput;
}>;


export type CreateMercariCrawlSettingRequiredKeywordMutation = { __typename?: 'Mutation', createMercariCrawlSettingRequiredKeyword: { __typename?: 'CreateMercariCrawlSettingRequiredKeywordResultError', ok: boolean, error: { __typename?: 'CreateMercariCrawlSettingRequiredKeywordResultValidationFailed', code: string, message: string, details: Array<{ __typename?: 'ErrorDetail', field: string, message: string }> } } | { __typename?: 'CreateMercariCrawlSettingRequiredKeywordResultSuccess', ok: boolean, mercariCrawlSettingRequiredKeyword: { __typename?: 'MercariCrawlSettingRequiredKeyword', id: string, keyword?: string | null, createdAt: string, updatedAt: string } } };

export type UpdateMercariCrawlSettingRequiredKeywordMutationVariables = Exact<{
  input: UpdateMercariCrawlSettingRequiredKeywordInput;
}>;


export type UpdateMercariCrawlSettingRequiredKeywordMutation = { __typename?: 'Mutation', updateMercariCrawlSettingRequiredKeyword: { __typename?: 'UpdateMercariCrawlSettingRequiredKeywordResultError', ok: boolean, error: { __typename?: 'UpdateMercariCrawlSettingRequiredKeywordResultValidationFailed', code: string, message: string, details: Array<{ __typename?: 'ErrorDetail', field: string, message: string }> } } | { __typename?: 'UpdateMercariCrawlSettingRequiredKeywordResultSuccess', ok: boolean, mercariCrawlSettingRequiredKeyword: { __typename?: 'MercariCrawlSettingRequiredKeyword', id: string, keyword?: string | null, createdAt: string, updatedAt: string } } };

export type DeleteMercariCrawlSettingRequiredKeywordMutationVariables = Exact<{
  id: Scalars['ID']['input'];
  productId: Scalars['ID']['input'];
}>;


export type DeleteMercariCrawlSettingRequiredKeywordMutation = { __typename?: 'Mutation', deleteMercariCrawlSettingRequiredKeyword: { __typename?: 'DeleteMercariCrawlSettingRequiredKeywordResultError', ok: boolean, error: { __typename?: 'DeleteMercariCrawlSettingRequiredKeywordResultValidationFailed', code: string, message: string, details: Array<{ __typename?: 'ErrorDetail', field: string, message: string }> } } | { __typename?: 'DeleteMercariCrawlSettingRequiredKeywordResultSuccess', ok: boolean } };

export type GetProductPageDataQueryVariables = Exact<{
  id?: InputMaybe<Scalars['ID']['input']>;
  name?: InputMaybe<Scalars['String']['input']>;
}>;


export type GetProductPageDataQuery = { __typename?: 'Query', products: Array<{ __typename?: 'Product', id: string, name: string, yahooAuctionCrawlSetting: { __typename?: 'YahooAuctionCrawlSetting', id: string, productId: number, keyword: string, categoryId?: number | null, minPrice: number, maxPrice: number, enabled: boolean }, mercariCrawlSetting: { __typename?: 'MercariCrawlSetting', id: string, productId: number, keyword: string, categoryId?: number | null, minPrice: number, maxPrice: number, enabled: boolean } }> };

export type GetProductDetailPageDataQueryVariables = Exact<{
  id: Scalars['ID']['input'];
  published?: InputMaybe<Scalars['Boolean']['input']>;
  page?: InputMaybe<Scalars['Int']['input']>;
  per?: InputMaybe<Scalars['Int']['input']>;
  sort?: InputMaybe<Scalars['String']['input']>;
  order?: InputMaybe<Scalars['String']['input']>;
}>;


export type GetProductDetailPageDataQuery = { __typename?: 'Query', product: { __typename?: 'Product', id: string, name: string, yahooAuctionCrawlSetting: { __typename?: 'YahooAuctionCrawlSetting', id: string, keyword: string, categoryId?: number | null, minPrice: number, maxPrice: number, enabled: boolean, yahooAuctionCrawlSettingExcludeKeywords: Array<{ __typename?: 'YahooAuctionCrawlSettingExcludeKeyword', id: string, yahooAuctionCrawlSettingId: number, keyword?: string | null, createdAt: string, updatedAt: string }>, yahooAuctionCrawlSettingRequiredKeywords: Array<{ __typename?: 'YahooAuctionCrawlSettingRequiredKeyword', id: string, yahooAuctionCrawlSettingId: number, keyword?: string | null, createdAt: string, updatedAt: string }> }, yahooAuctionDailyPurchaseSummaries: Array<{ __typename?: 'YahooAuctionDailyPurchaseSummary', id: string, productId: number, averagePurchasePrice?: number | null, purchaseCount: number, date: string, createdAt: string, updatedAt: string }>, mercariCrawlSetting: { __typename?: 'MercariCrawlSetting', id: string, productId: number, keyword: string, categoryId?: number | null, minPrice: number, maxPrice: number, enabled: boolean, mercariCrawlSettingExcludeKeywords: Array<{ __typename?: 'MercariCrawlSettingExcludeKeyword', id: string, mercariCrawlSettingId: number, keyword?: string | null, createdAt: string, updatedAt: string }>, mercariCrawlSettingRequiredKeywords: Array<{ __typename?: 'MercariCrawlSettingRequiredKeyword', id: string, mercariCrawlSettingId: number, keyword?: string | null, createdAt: string, updatedAt: string }> }, mercariDailyPurchaseSummaries: Array<{ __typename?: 'MercariDailyPurchaseSummary', id: string, productId: number, averagePurchasePrice?: number | null, purchaseCount: number, date: string, createdAt: string, updatedAt: string }>, relatedProducts: Array<{ __typename?: 'RelatedProduct', relatedType: string, productId: number, externalId: string, name: string, thumbnailUrl: string, price: number, published: boolean, boughtDate?: string | null, createdAt: string, updatedAt: string }> } };

export type GetRecommendsPageDataQueryVariables = Exact<{
  id?: InputMaybe<Scalars['ID']['input']>;
  name?: InputMaybe<Scalars['String']['input']>;
}>;


export type GetRecommendsPageDataQuery = { __typename?: 'Query', products: Array<{ __typename?: 'Product', id: string, name: string, relatedProducts: Array<{ __typename?: 'RelatedProduct', relatedType: string, productId: number, externalId: string, name: string, thumbnailUrl: string, price: number, published: boolean, boughtDate?: string | null, createdAt: string, updatedAt: string }> }> };


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
export const CreateYahooAuctionCrawlSettingRequiredKeywordDocument = gql`
    mutation createYahooAuctionCrawlSettingRequiredKeyword($input: CreateYahooAuctionCrawlSettingRequiredKeywordInput!) {
  createYahooAuctionCrawlSettingRequiredKeyword(input: $input) {
    ... on CreateYahooAuctionCrawlSettingRequiredKeywordResultSuccess {
      ok
      yahooAuctionCrawlSettingRequiredKeyword {
        id
        keyword
        createdAt
        updatedAt
      }
    }
    ... on CreateYahooAuctionCrawlSettingRequiredKeywordResultError {
      ok
      error {
        ... on CreateYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed {
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
export const UpdateYahooAuctionCrawlSettingRequiredKeywordDocument = gql`
    mutation updateYahooAuctionCrawlSettingRequiredKeyword($input: UpdateYahooAuctionCrawlSettingRequiredKeywordInput!) {
  updateYahooAuctionCrawlSettingRequiredKeyword(input: $input) {
    ... on UpdateYahooAuctionCrawlSettingRequiredKeywordResultSuccess {
      ok
      yahooAuctionCrawlSettingRequiredKeyword {
        id
        keyword
        createdAt
        updatedAt
      }
    }
    ... on UpdateYahooAuctionCrawlSettingRequiredKeywordResultError {
      ok
      error {
        ... on UpdateYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed {
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
export const DeleteYahooAuctionCrawlSettingRequiredKeywordDocument = gql`
    mutation deleteYahooAuctionCrawlSettingRequiredKeyword($id: ID!, $productId: ID!) {
  deleteYahooAuctionCrawlSettingRequiredKeyword(id: $id, productId: $productId) {
    ... on DeleteYahooAuctionCrawlSettingRequiredKeywordResultSuccess {
      ok
    }
    ... on DeleteYahooAuctionCrawlSettingRequiredKeywordResultError {
      ok
      error {
        ... on DeleteYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed {
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
export const CreateMercariCrawlSettingExcludeKeywordDocument = gql`
    mutation createMercariCrawlSettingExcludeKeyword($input: CreateMercariCrawlSettingExcludeKeywordInput!) {
  createMercariCrawlSettingExcludeKeyword(input: $input) {
    ... on CreateMercariCrawlSettingExcludeKeywordResultSuccess {
      ok
      mercariCrawlSettingExcludeKeyword {
        id
        keyword
        createdAt
        updatedAt
      }
    }
    ... on CreateMercariCrawlSettingExcludeKeywordResultError {
      ok
      error {
        ... on CreateMercariCrawlSettingExcludeKeywordResultValidationFailed {
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
export const UpdateMercariCrawlSettingExcludeKeywordDocument = gql`
    mutation updateMercariCrawlSettingExcludeKeyword($input: UpdateMercariCrawlSettingExcludeKeywordInput!) {
  updateMercariCrawlSettingExcludeKeyword(input: $input) {
    ... on UpdateMercariCrawlSettingExcludeKeywordResultSuccess {
      ok
      mercariCrawlSettingExcludeKeyword {
        id
        keyword
        createdAt
        updatedAt
      }
    }
    ... on UpdateMercariCrawlSettingExcludeKeywordResultError {
      ok
      error {
        ... on UpdateMercariCrawlSettingExcludeKeywordResultValidationFailed {
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
export const DeleteMercariCrawlSettingExcludeKeywordDocument = gql`
    mutation deleteMercariCrawlSettingExcludeKeyword($id: ID!, $productId: ID!) {
  deleteMercariCrawlSettingExcludeKeyword(id: $id, productId: $productId) {
    ... on DeleteMercariCrawlSettingExcludeKeywordResultSuccess {
      ok
    }
    ... on DeleteMercariCrawlSettingExcludeKeywordResultError {
      ok
      error {
        ... on DeleteMercariCrawlSettingExcludeKeywordResultValidationFailed {
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
export const CreateMercariCrawlSettingRequiredKeywordDocument = gql`
    mutation createMercariCrawlSettingRequiredKeyword($input: CreateMercariCrawlSettingRequiredKeywordInput!) {
  createMercariCrawlSettingRequiredKeyword(input: $input) {
    ... on CreateMercariCrawlSettingRequiredKeywordResultSuccess {
      ok
      mercariCrawlSettingRequiredKeyword {
        id
        keyword
        createdAt
        updatedAt
      }
    }
    ... on CreateMercariCrawlSettingRequiredKeywordResultError {
      ok
      error {
        ... on CreateMercariCrawlSettingRequiredKeywordResultValidationFailed {
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
export const UpdateMercariCrawlSettingRequiredKeywordDocument = gql`
    mutation updateMercariCrawlSettingRequiredKeyword($input: UpdateMercariCrawlSettingRequiredKeywordInput!) {
  updateMercariCrawlSettingRequiredKeyword(input: $input) {
    ... on UpdateMercariCrawlSettingRequiredKeywordResultSuccess {
      ok
      mercariCrawlSettingRequiredKeyword {
        id
        keyword
        createdAt
        updatedAt
      }
    }
    ... on UpdateMercariCrawlSettingRequiredKeywordResultError {
      ok
      error {
        ... on UpdateMercariCrawlSettingRequiredKeywordResultValidationFailed {
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
export const DeleteMercariCrawlSettingRequiredKeywordDocument = gql`
    mutation deleteMercariCrawlSettingRequiredKeyword($id: ID!, $productId: ID!) {
  deleteMercariCrawlSettingRequiredKeyword(id: $id, productId: $productId) {
    ... on DeleteMercariCrawlSettingRequiredKeywordResultSuccess {
      ok
    }
    ... on DeleteMercariCrawlSettingRequiredKeywordResultError {
      ok
      error {
        ... on DeleteMercariCrawlSettingRequiredKeywordResultValidationFailed {
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
export const GetProductPageDataDocument = gql`
    query getProductPageData($id: ID, $name: String) {
  products(id: $id, name: $name) {
    id
    name
    yahooAuctionCrawlSetting {
      id
      productId
      keyword
      categoryId
      minPrice
      maxPrice
      enabled
    }
    mercariCrawlSetting {
      id
      productId
      keyword
      categoryId
      minPrice
      maxPrice
      enabled
    }
  }
}
    `;
export const GetProductDetailPageDataDocument = gql`
    query getProductDetailPageData($id: ID!, $published: Boolean, $page: Int, $per: Int, $sort: String, $order: String) {
  product(id: $id) {
    id
    name
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
      yahooAuctionCrawlSettingRequiredKeywords {
        id
        yahooAuctionCrawlSettingId
        keyword
        createdAt
        updatedAt
      }
    }
    yahooAuctionDailyPurchaseSummaries {
      id
      productId
      averagePurchasePrice
      purchaseCount
      date
      createdAt
      updatedAt
    }
    mercariCrawlSetting {
      id
      productId
      keyword
      categoryId
      minPrice
      maxPrice
      enabled
      mercariCrawlSettingExcludeKeywords {
        id
        mercariCrawlSettingId
        keyword
        createdAt
        updatedAt
      }
      mercariCrawlSettingRequiredKeywords {
        id
        mercariCrawlSettingId
        keyword
        createdAt
        updatedAt
      }
    }
    mercariDailyPurchaseSummaries {
      id
      productId
      averagePurchasePrice
      purchaseCount
      date
      createdAt
      updatedAt
    }
    relatedProducts(
      published: $published
      page: $page
      per: $per
      sort: $sort
      order: $order
    ) {
      relatedType
      productId
      externalId
      name
      thumbnailUrl
      price
      published
      boughtDate
      createdAt
      updatedAt
    }
  }
}
    `;
export const GetRecommendsPageDataDocument = gql`
    query getRecommendsPageData($id: ID, $name: String) {
  products(id: $id, name: $name) {
    id
    name
    relatedProducts(
      published: true
      page: 1
      per: 10
      sort: "updated_at"
      order: "desc"
    ) {
      relatedType
      productId
      externalId
      name
      thumbnailUrl
      price
      published
      boughtDate
      createdAt
      updatedAt
    }
  }
}
    `;

export type SdkFunctionWrapper = <T>(action: (requestHeaders?:Record<string, string>) => Promise<T>, operationName: string, operationType?: string, variables?: any) => Promise<T>;


const defaultWrapper: SdkFunctionWrapper = (action, _operationName, _operationType, _variables) => action();

export function getSdk(client: GraphQLClient, withWrapper: SdkFunctionWrapper = defaultWrapper) {
  return {
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
    },
    createYahooAuctionCrawlSettingRequiredKeyword(variables: CreateYahooAuctionCrawlSettingRequiredKeywordMutationVariables, requestHeaders?: GraphQLClientRequestHeaders): Promise<CreateYahooAuctionCrawlSettingRequiredKeywordMutation> {
      return withWrapper((wrappedRequestHeaders) => client.request<CreateYahooAuctionCrawlSettingRequiredKeywordMutation>(CreateYahooAuctionCrawlSettingRequiredKeywordDocument, variables, {...requestHeaders, ...wrappedRequestHeaders}), 'createYahooAuctionCrawlSettingRequiredKeyword', 'mutation', variables);
    },
    updateYahooAuctionCrawlSettingRequiredKeyword(variables: UpdateYahooAuctionCrawlSettingRequiredKeywordMutationVariables, requestHeaders?: GraphQLClientRequestHeaders): Promise<UpdateYahooAuctionCrawlSettingRequiredKeywordMutation> {
      return withWrapper((wrappedRequestHeaders) => client.request<UpdateYahooAuctionCrawlSettingRequiredKeywordMutation>(UpdateYahooAuctionCrawlSettingRequiredKeywordDocument, variables, {...requestHeaders, ...wrappedRequestHeaders}), 'updateYahooAuctionCrawlSettingRequiredKeyword', 'mutation', variables);
    },
    deleteYahooAuctionCrawlSettingRequiredKeyword(variables: DeleteYahooAuctionCrawlSettingRequiredKeywordMutationVariables, requestHeaders?: GraphQLClientRequestHeaders): Promise<DeleteYahooAuctionCrawlSettingRequiredKeywordMutation> {
      return withWrapper((wrappedRequestHeaders) => client.request<DeleteYahooAuctionCrawlSettingRequiredKeywordMutation>(DeleteYahooAuctionCrawlSettingRequiredKeywordDocument, variables, {...requestHeaders, ...wrappedRequestHeaders}), 'deleteYahooAuctionCrawlSettingRequiredKeyword', 'mutation', variables);
    },
    createMercariCrawlSettingExcludeKeyword(variables: CreateMercariCrawlSettingExcludeKeywordMutationVariables, requestHeaders?: GraphQLClientRequestHeaders): Promise<CreateMercariCrawlSettingExcludeKeywordMutation> {
      return withWrapper((wrappedRequestHeaders) => client.request<CreateMercariCrawlSettingExcludeKeywordMutation>(CreateMercariCrawlSettingExcludeKeywordDocument, variables, {...requestHeaders, ...wrappedRequestHeaders}), 'createMercariCrawlSettingExcludeKeyword', 'mutation', variables);
    },
    updateMercariCrawlSettingExcludeKeyword(variables: UpdateMercariCrawlSettingExcludeKeywordMutationVariables, requestHeaders?: GraphQLClientRequestHeaders): Promise<UpdateMercariCrawlSettingExcludeKeywordMutation> {
      return withWrapper((wrappedRequestHeaders) => client.request<UpdateMercariCrawlSettingExcludeKeywordMutation>(UpdateMercariCrawlSettingExcludeKeywordDocument, variables, {...requestHeaders, ...wrappedRequestHeaders}), 'updateMercariCrawlSettingExcludeKeyword', 'mutation', variables);
    },
    deleteMercariCrawlSettingExcludeKeyword(variables: DeleteMercariCrawlSettingExcludeKeywordMutationVariables, requestHeaders?: GraphQLClientRequestHeaders): Promise<DeleteMercariCrawlSettingExcludeKeywordMutation> {
      return withWrapper((wrappedRequestHeaders) => client.request<DeleteMercariCrawlSettingExcludeKeywordMutation>(DeleteMercariCrawlSettingExcludeKeywordDocument, variables, {...requestHeaders, ...wrappedRequestHeaders}), 'deleteMercariCrawlSettingExcludeKeyword', 'mutation', variables);
    },
    createMercariCrawlSettingRequiredKeyword(variables: CreateMercariCrawlSettingRequiredKeywordMutationVariables, requestHeaders?: GraphQLClientRequestHeaders): Promise<CreateMercariCrawlSettingRequiredKeywordMutation> {
      return withWrapper((wrappedRequestHeaders) => client.request<CreateMercariCrawlSettingRequiredKeywordMutation>(CreateMercariCrawlSettingRequiredKeywordDocument, variables, {...requestHeaders, ...wrappedRequestHeaders}), 'createMercariCrawlSettingRequiredKeyword', 'mutation', variables);
    },
    updateMercariCrawlSettingRequiredKeyword(variables: UpdateMercariCrawlSettingRequiredKeywordMutationVariables, requestHeaders?: GraphQLClientRequestHeaders): Promise<UpdateMercariCrawlSettingRequiredKeywordMutation> {
      return withWrapper((wrappedRequestHeaders) => client.request<UpdateMercariCrawlSettingRequiredKeywordMutation>(UpdateMercariCrawlSettingRequiredKeywordDocument, variables, {...requestHeaders, ...wrappedRequestHeaders}), 'updateMercariCrawlSettingRequiredKeyword', 'mutation', variables);
    },
    deleteMercariCrawlSettingRequiredKeyword(variables: DeleteMercariCrawlSettingRequiredKeywordMutationVariables, requestHeaders?: GraphQLClientRequestHeaders): Promise<DeleteMercariCrawlSettingRequiredKeywordMutation> {
      return withWrapper((wrappedRequestHeaders) => client.request<DeleteMercariCrawlSettingRequiredKeywordMutation>(DeleteMercariCrawlSettingRequiredKeywordDocument, variables, {...requestHeaders, ...wrappedRequestHeaders}), 'deleteMercariCrawlSettingRequiredKeyword', 'mutation', variables);
    },
    getProductPageData(variables?: GetProductPageDataQueryVariables, requestHeaders?: GraphQLClientRequestHeaders): Promise<GetProductPageDataQuery> {
      return withWrapper((wrappedRequestHeaders) => client.request<GetProductPageDataQuery>(GetProductPageDataDocument, variables, {...requestHeaders, ...wrappedRequestHeaders}), 'getProductPageData', 'query', variables);
    },
    getProductDetailPageData(variables: GetProductDetailPageDataQueryVariables, requestHeaders?: GraphQLClientRequestHeaders): Promise<GetProductDetailPageDataQuery> {
      return withWrapper((wrappedRequestHeaders) => client.request<GetProductDetailPageDataQuery>(GetProductDetailPageDataDocument, variables, {...requestHeaders, ...wrappedRequestHeaders}), 'getProductDetailPageData', 'query', variables);
    },
    getRecommendsPageData(variables?: GetRecommendsPageDataQueryVariables, requestHeaders?: GraphQLClientRequestHeaders): Promise<GetRecommendsPageDataQuery> {
      return withWrapper((wrappedRequestHeaders) => client.request<GetRecommendsPageDataQuery>(GetRecommendsPageDataDocument, variables, {...requestHeaders, ...wrappedRequestHeaders}), 'getRecommendsPageData', 'query', variables);
    }
  };
}
export type Sdk = ReturnType<typeof getSdk>;