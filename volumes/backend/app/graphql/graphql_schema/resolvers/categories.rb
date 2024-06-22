module GraphqlSchema
  module Resolvers
    class Categories < Base
      type [Objects::Category], null: false

      def resolve
        ::Category.roots
      end
    end
  end
end
