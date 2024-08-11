module GraphqlSchema
  module Resolvers
    module Products
      class ProductResolver < Base
        type Objects::Products::ProductType, null: false

        argument :id, ID, required: true

        def resolve(id:)
          ::Product.find_by(id:)
        end
      end
    end
  end
end
