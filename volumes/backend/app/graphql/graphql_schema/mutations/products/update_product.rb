module GraphqlSchema
  module Mutations
    module Products
      class UpdateProduct < Base
        input_object_class InputObjects::Products::UpdateProductInput

        field :result, Unions::Products::UpdateProductResult, null: false

        type Unions::Products::UpdateProductResult

        def resolve(input) # rubocop:disable Metrics/MethodLength
          params = input.as_json.deep_symbolize_keys
          product = Product.find(params[:id])
          ::Products::Update.call(product:, params:)

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
