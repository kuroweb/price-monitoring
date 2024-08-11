module GraphqlSchema
  module Mutations
    module Categories
      class DeleteCategory < Base
        input_object_class InputObjects::Categories::DeleteCategoryInput

        type Unions::Categories::DeleteCategory::DeleteCategoryResultUnion, null: false

        def resolve(input)
          category = Category.find(input[:id])

          if category.destroy
            {
              __typename: "DeleteCategoryResultSuccessType",
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
            __typename: "DeleteCategoryResultErrorType",
            error: {
              __typename: "DeleteCategoryResultValidationFailedType",
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
