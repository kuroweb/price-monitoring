module GraphqlSchema
  module Resolvers
    module Products
      class RelatedProducts < Base
        type [Objects::Products::RelatedProduct], null: false

        argument :platform_mask, String, required: true
        argument :page, Int, required: false
        argument :per, Int, required: false
        argument :sort, String, required: false
        argument :order, String, required: false

        def resolve(**args)
          Search::RetrieveRelatedProduct.call(
            params: { product_id: object.id, **args }
          ).products
        end
      end
    end
  end
end
