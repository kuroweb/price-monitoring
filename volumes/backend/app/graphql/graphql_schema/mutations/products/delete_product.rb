module GraphqlSchema
  module Mutations
    module Products
      class DeleteProduct < Base
        input_object_class InputObjects::Products::DeleteProductInput

        type Unions::Products::DeleteProduct::DeleteProductResult, null: false

        def resolve(input)
          product = Product.find(input[:id])

          if product.destroy
            {
              __typename: "DeleteProductResultSuccess",
              ok: true
            }
          else
            error_response("400", "Bad Request.")
          end
        rescue StandardError => e
          handle_error(e)
        end

        private

        def handle_error(exception)
          case exception
          when ActiveRecord::RecordNotFound
            error_response("404", "Not Found.")
          else
            Rails.logger.error("Internal Server Error. exception: #{exception.full_message}")
            error_response("503", "Internal Server Error.")
          end
        end

        def error_response(code, message)
          {
            __typename: "DeleteProductResultError",
            error: {
              __typename: "DeleteProductResultValidationFailed",
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
