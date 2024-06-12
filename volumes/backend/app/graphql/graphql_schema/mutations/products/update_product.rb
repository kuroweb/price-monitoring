module GraphqlSchema
  module Mutations
    module Products
      class UpdateProduct < Base
        argument :product, InputObjects::Products::UpdateProduct, required: true

        field :result, Unions::Products::UpdateProductResult, null: false

        type Unions::Products::UpdateProductResult

        graphql_name :UpdateProduct

        def resolve(product:) # rubocop:disable Metrics/MethodLength
          product = Product.find(product.id)
          ::Products::Update.call(product:, params: product.as_json.deep_symbolize_keys)

          {
            __typename: "UpdateProductResultSuccess",
            product:,
            ok: true
          }
        rescue ActiveRecord::RecordNotFound
          {
            __typename: "UpdateProductResultError",
            error: {
              __typename: "UpdateProductResultValidationFailed",
              code: "404",
              message: "Not Found.",
              details: []
            },
            ok: false
          }
        rescue ActiveRecord::RecordInvalid => e
          Rails.logger.error("Bad Request. exception: #{e.full_message}")

          {
            __typename: "UpdateProductResultError",
            error: {
              __typename: "UpdateProductResultValidationFailed",
              code: "400",
              message: "Bad Request.",
              details: []
            },
            ok: false
          }
        end
      end
    end
  end
end
