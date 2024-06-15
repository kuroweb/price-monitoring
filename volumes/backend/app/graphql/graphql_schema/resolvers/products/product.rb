module GraphqlSchema
  module Resolvers
    module Products
      class Product < Base
        type Objects::Products::Product, null: false

        argument :id, ID, required: true

        def resolve(id:)
          ::Product.find_by(id:)
        end
      end
    end
  end
end
