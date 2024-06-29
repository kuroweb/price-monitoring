module GraphqlSchema
  module Objects
    module Categories
      class Category < Base
        implements GraphQL::Types::Relay::Node

        field :id, ID, null: false
        field :parent_id, ID, null: true
        field :name, String, null: false
        field :children, [Objects::Categories::Category], null: false

        def children
          object.children
        end
      end
    end
  end
end
