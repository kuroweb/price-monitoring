module GraphqlSchema
  module Resolvers
    module Products
      class Products < Base
        type [Objects::Products::Product], null: false

        argument :id, ID, required: false
        argument :name, String, required: false

        def resolve(**args)
          ProductFinder.new(params: args).execute
        end
      end
    end
  end
end
