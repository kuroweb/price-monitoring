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

export type Product = {
  __typename?: 'Product';
  id: Scalars['ID']['output'];
  name: Scalars['String']['output'];
};

export type Query = {
  __typename?: 'Query';
  getProduct: Product;
  getProducts: Array<Product>;
  getUser: User;
  getUsers: Array<User>;
};


export type QueryGetProductArgs = {
  id: Scalars['Int']['input'];
};


export type QueryGetProductsArgs = {
  id?: InputMaybe<Scalars['Int']['input']>;
  name?: InputMaybe<Scalars['String']['input']>;
};


export type QueryGetUserArgs = {
  id: Scalars['Int']['input'];
};


export type QueryGetUsersArgs = {
  id?: InputMaybe<Scalars['Int']['input']>;
  name?: InputMaybe<Scalars['String']['input']>;
};

export type User = {
  __typename?: 'User';
  id: Scalars['ID']['output'];
  name: Scalars['String']['output'];
};

export type GetProductsQueryVariables = Exact<{
  id?: InputMaybe<Scalars['Int']['input']>;
  name?: InputMaybe<Scalars['String']['input']>;
}>;


export type GetProductsQuery = { __typename?: 'Query', getProducts: Array<{ __typename?: 'Product', id: string, name: string }> };

export type GetProductQueryVariables = Exact<{
  id: Scalars['Int']['input'];
}>;


export type GetProductQuery = { __typename?: 'Query', getProduct: { __typename?: 'Product', id: string, name: string } };


export const GetProductsDocument = gql`
    query getProducts($id: Int, $name: String) {
  getProducts(id: $id, name: $name) {
    id
    name
  }
}
    `;
export const GetProductDocument = gql`
    query getProduct($id: Int!) {
  getProduct(id: $id) {
    id
    name
  }
}
    `;

export type SdkFunctionWrapper = <T>(action: (requestHeaders?:Record<string, string>) => Promise<T>, operationName: string, operationType?: string) => Promise<T>;


const defaultWrapper: SdkFunctionWrapper = (action, _operationName, _operationType) => action();

export function getSdk(client: GraphQLClient, withWrapper: SdkFunctionWrapper = defaultWrapper) {
  return {
    getProducts(variables?: GetProductsQueryVariables, requestHeaders?: GraphQLClientRequestHeaders): Promise<GetProductsQuery> {
      return withWrapper((wrappedRequestHeaders) => client.request<GetProductsQuery>(GetProductsDocument, variables, {...requestHeaders, ...wrappedRequestHeaders}), 'getProducts', 'query');
    },
    getProduct(variables: GetProductQueryVariables, requestHeaders?: GraphQLClientRequestHeaders): Promise<GetProductQuery> {
      return withWrapper((wrappedRequestHeaders) => client.request<GetProductQuery>(GetProductDocument, variables, {...requestHeaders, ...wrappedRequestHeaders}), 'getProduct', 'query');
    }
  };
}
export type Sdk = ReturnType<typeof getSdk>;