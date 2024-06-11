module GraphqlSchema
  module Mutations
    module Products
      class CreateProduct < Base
        argument :input, InputObjects::Products::CreateProduct, required: true

        field :result, Unions::Products::CreateProductResult, null: false

        type Unions::Products::CreateProductResult

        def resolve(input:) # rubocop:disable Metrics/MethodLength
          product = ::Products::Create.call(params: input.as_json.deep_symbolize_keys)

          {
            __typename: "CreateProductResultSuccess",
            product:,
            ok: true
          }
        rescue ActiveRecord::RecordInvalid => e
          Rails.logger.error("Bad Request. exception: #{e.full_message}")

          {
            __typename: "CreateProductResultError",
            error: {
              __typename: "CreateProductResultValidationFailed",
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
