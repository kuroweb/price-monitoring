module GraphqlSchema
  module Mutations
    module Products
      class CreateProduct < Base
        input_object_class InputObjects::Products::CreateProductInput

        field :result, Unions::Products::CreateProductResult, null: false

        type Unions::Products::CreateProductResult

        # rubocop:disable Metrics/MethodLength
        def resolve(input)
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
        # rubocop:enable Metrics/MethodLength
      end
    end
  end
end
