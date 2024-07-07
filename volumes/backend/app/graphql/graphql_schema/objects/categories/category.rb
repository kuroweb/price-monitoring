module GraphqlSchema
  module Objects
    module Categories
      class Category < Base
        implements GraphQL::Types::Relay::Node

        field :id, ID, null: false
        field :parent_id, ID, null: true
        field :name, String, null: false
        field :parent, Objects::Categories::Category, null: true
        field :children, [Objects::Categories::Category], null: false
        field :products, [Objects::Products::Product], null: false

        def parent
          object.parent
        end

        def children
          object.children
        end

        def products
          category_ids = object.self_and_descendant_ids
          Product.joins(:category).where(categories: { id: category_ids })
        end
      end
    end
  end
end
