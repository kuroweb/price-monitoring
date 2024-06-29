module GraphqlSchema
  module Mutations
    class DeleteCategory < Base
      input_object_class InputObjects::DeleteCategoryInput

      type Unions::DeleteCategory::DeleteCategoryResult, null: false

      def resolve(input)
        category = Category.find(input[:id])

        if category.destroy
          {
            __typename: "DeleteCategoryResultSuccess",
            category:,
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
          __typename: "DeleteCategoryResultError",
          error: {
            __typename: "DeleteCategoryResultValidationFailed",
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