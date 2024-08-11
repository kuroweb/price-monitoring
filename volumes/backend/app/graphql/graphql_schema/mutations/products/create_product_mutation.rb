module GraphqlSchema
  module Mutations
    module Products
      class CreateProductMutation < Base
        input_object_class InputObjects::Products::CreateProduct::CreateProductInput

        type Unions::Products::CreateProduct::CreateProductResult, null: false

        def resolve(input)
          product = ::Products::Create.call(params: input.as_json.deep_symbolize_keys)

          {
            __typename: "CreateProductResultSuccess",
            product:,
            ok: true
          }
        rescue StandardError => e
          handle_error(e)
        end

        private

        def handle_error(exception)
          case exception
          when ActiveRecord::RecordInvalid
            Rails.logger.error("Bad Request. exception: #{exception.full_message}")
            error_response("400", "Bad Request.")
          when ActiveRecord::RecordNotFound
            exception.model == "Product" ? error_response("404", "Not Found.") : error_response("400", "Bad Request.")
          when ActiveRecord::RecordNotUnique
            error_response("409", "Conflict.")
          else
            Rails.logger.error("Internal Server Error. exception: #{exception.full_message}")
            error_response("503", "Internal Server Error.")
          end
        end

        def error_response(code, message)
          {
            __typename: "CreateProductResultError",
            error: {
              __typename: "CreateProductResultValidationFailed",
              code:,
              message:,
              details: []
            },
            ok: false
          }
        end
      end
    end
  end
end
