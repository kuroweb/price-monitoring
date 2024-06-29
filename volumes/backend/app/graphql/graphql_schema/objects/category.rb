module GraphqlSchema
  module Objects
    class Category < Base
      implements GraphQL::Types::Relay::Node

      field :id, ID, null: false
      field :parent_id, ID, null: true
      field :name, String, null: false
      field :children, [Objects::Category], null: false

      def children
        object.children
      end
    end
  end
end
