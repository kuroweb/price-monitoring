module GraphqlSchema
  module Resolvers
    module Products
      class ProductsResolver < Base
        type [Objects::Products::ProductType], null: false

        argument :id, ID, required: false
        argument :name, String, required: false

        def resolve(**args)
          ProductFinder.new(params: args).execute
        end
      end
    end
  end
end
