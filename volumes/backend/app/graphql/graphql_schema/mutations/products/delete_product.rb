module GraphqlSchema
  module Mutations
    module Products
      class DeleteProduct < Base
        argument :id, ID, required: true

        field :result, Unions::Products::DeleteProductResult, null: false

        type Unions::Products::DeleteProductResult

        def resolve(id:) # rubocop:disable Metrics/MethodLength
          product = Product.find(id)

          if product.destroy
            {
              __typename: "DeleteProductResultSuccess",
              product:,
              ok: true
            }
          else
            {
              __typename: "DeleteProductResultError",
              error: {
                __typename: "DeleteProductResultValidationFailed",
                code: "400",
                message: "Bad Request.",
                details: []
              },
              ok: false
            }
          end
        rescue ActiveRecord::RecordNotFound
          {
            __typename: "DeleteProductResultError",
            error: {
              __typename: "DeleteProductResultValidationFailed",
              code: "404",
              message: "Not Found.",
              details: []
            },
            ok: false
          }
        end
      end
    end
  end
end
