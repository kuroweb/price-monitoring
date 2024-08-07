module GraphqlSchema
  module Objects
    class QueryType < Base
      include GraphQL::Types::Relay::HasNodeField
      include GraphQL::Types::Relay::HasNodesField

      field :product, resolver: Resolvers::Products::Product
      field :products, resolver: Resolvers::Products::Products
      field :category, resolver: Resolvers::Categories::Category
      field :categories, resolver: Resolvers::Categories::Categories
    end
  end
end
