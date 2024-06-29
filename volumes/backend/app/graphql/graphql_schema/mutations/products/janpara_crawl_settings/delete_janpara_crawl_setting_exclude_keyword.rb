module GraphqlSchema
  module Mutations
    module Products
      module JanparaCrawlSettings
        class DeleteJanparaCrawlSettingExcludeKeyword < Base
          input_object_class InputObjects::Products::JanparaCrawlSettings::
                             DeleteJanparaCrawlSettingExcludeKeywordInput

          type Unions::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingExcludeKeyword::
               DeleteJanparaCrawlSettingExcludeKeywordResult, null: false

          def resolve(input) # rubocop:disable Metrics/MethodLength
            product = Product.find(input[:product_id])
            janpara_crawl_setting_exclude_keyword =
              product
              .janpara_crawl_setting
              .janpara_crawl_setting_exclude_keywords
              .find(input[:id])

            if janpara_crawl_setting_exclude_keyword.destroy
              {
                __typename: "DeleteJanparaCrawlSettingExcludeKeywordResultSuccess",
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
              __typename: "DeleteJanparaCrawlSettingExcludeKeywordResultError",
              error: {
                __typename: "DeleteJanparaCrawlSettingExcludeKeywordResultValidationFailed",
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
end
