module GraphqlSchema
  module Resolvers
    module Categories
      class Category < Base
        type Objects::Categories::CategoryType, null: false

        argument :name, String, required: true

        def resolve(name:)
          Category.find_by(name:)
        end
      end
    end
  end
end
