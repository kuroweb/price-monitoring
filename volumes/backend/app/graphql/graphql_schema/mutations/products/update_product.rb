module GraphqlSchema
  module Mutations
    module Products
      class UpdateProduct < Base
        input_object_class InputObjects::Products::UpdateProductInput

        field :result, Unions::Products::UpdateProductResult, null: false

        type Unions::Products::UpdateProductResult

        def resolve(input)
          params = input.as_json.deep_symbolize_keys
          product = Product.find(params[:id])
          ::Products::Update.call(product:, params:)

          inspect(product)

          {
            __typename: "UpdateProductResultSuccess",
            product:,
            ok: true
          }
        rescue StandardError => e
          handle_error(e)
        end

        private

        def inspect(product)
          ::Products::Inspect::DeleteYahooAuctionProducts.call(product:)
          ::Products::Inspect::DeleteYahooFleamarketProducts.call(product:)
        end

        def handle_error(exception)
          case exception
          when ActiveRecord::RecordInvalid
            Rails.logger.error("Bad Request. exception: #{exception.full_message}")
            error_response("400", "Bad Request.")
          when ActiveRecord::RecordNotFound
            error_response("404", "Not Found.")
          when ActiveRecord::RecordNotUnique
            error_response("409", "Conflict.")
          else
            Rails.logger.error("Internal Server Error. exception: #{exception.full_message}")
            error_response("503", "Internal Server Error.")
          end
        end

        def error_response(code, message)
          {
            __typename: "UpdateProductResultError",
            error: {
              __typename: "UpdateProductResultValidationFailed",
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
