module GraphqlSchema
  module Resolvers
    class Categories < Base
      type [Objects::Categories::Category], null: false

      def resolve
        ::Category.roots
      end
    end
  end
end
