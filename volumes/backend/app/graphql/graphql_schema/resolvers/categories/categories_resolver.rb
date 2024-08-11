module GraphqlSchema
  module Resolvers
    module Categories
      class CategoriesResolver < Base
        type [Objects::Categories::CategoryType], null: false

        argument :root_only, Boolean, required: false
        argument :name, String, required: false

        def resolve(**args)
          CategoryFinder.new(params: args).execute
        end
      end
    end
  end
end
