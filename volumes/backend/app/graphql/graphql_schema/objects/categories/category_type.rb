module GraphqlSchema
  module Objects
    module Categories
      class CategoryType < Base
        implements GraphQL::Types::Relay::Node

        field :id, ID, null: false
        field :parent_id, ID, null: true
        field :name, String, null: false
        field :parent, Objects::Categories::CategoryType, null: true
        field :children, [Objects::Categories::CategoryType], null: false
        field :products, [Objects::Products::ProductType], null: false

        delegate :parent, :children, to: :object

        def products
          category_ids = object.self_and_descendant_ids
          Product.joins(:category).where(categories: { id: category_ids })
        end
      end
    end
  end
end
