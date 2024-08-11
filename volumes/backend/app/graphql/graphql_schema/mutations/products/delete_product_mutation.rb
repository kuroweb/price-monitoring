module GraphqlSchema
  module Mutations
    module Products
      class DeleteProductMutation < Base
        input_object_class InputObjects::Products::DeleteProductInput

        type Unions::Products::DeleteProduct::DeleteProductResultUnion, null: false

        def resolve(input)
          product = Product.find(input[:id])

          if product.destroy
            {
              __typename: "DeleteProductResultSuccessType",
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
            __typename: "DeleteProductResultErrorType",
            error: {
              __typename: "DeleteProductResultValidationFailedType",
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
