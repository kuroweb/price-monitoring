module GraphqlSchema
  module Objects
    class QueryType < Base
      include GraphQL::Types::Relay::HasNodeField
      include GraphQL::Types::Relay::HasNodesField

      field :product, resolver: Resolvers::Products::ProductResolver
      field :products, resolver: Resolvers::Products::ProductsResolver
      field :category, resolver: Resolvers::Categories::CategoryResolver
      field :categories, resolver: Resolvers::Categories::CategoriesResolver
    end
  end
end
