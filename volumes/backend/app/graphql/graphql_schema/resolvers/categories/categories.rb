module GraphqlSchema
  module Resolvers
    module Categories
      class Categories < Base
        type [Objects::Categories::Category], null: false

        argument :root_only, Boolean, required: false

        def resolve(**args)
          categories = ::Category.all
          categories = categories.roots if args[:root_only]
          categories
        end
      end
    end
  end
end
