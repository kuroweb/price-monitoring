module GraphqlSchema
  module Mutations
    module Categories
      class CreateCategoryMutation < Base
        input_object_class InputObjects::Categories::CreateCategoryInput

        type Unions::Categories::CreateCategory::CreateCategoryResult, null: false

        def resolve(input)
          parent_category = Category.find_by(id: input[:parent_id])

          category =
            if parent_category
              parent_category.children.create!(name: input[:name])
            else
              Category.create!(name: input[:name])
            end

          {
            __typename: "CreateCategoryResultSuccessType",
            category:,
            ok: true
          }
        rescue StandardError => e
          handle_error(e)
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
            __typename: "CreateCategoryResultErrorType",
            error: {
              __typename: "CreateCategoryResultValidationFailedType",
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
